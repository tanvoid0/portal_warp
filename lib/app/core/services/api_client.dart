import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:get/get.dart';
import 'token_storage.dart';

/// API Client for backend communication
/// Handles authentication, token refresh, and HTTP requests
class ApiClient extends GetxService {
  // TODO: Update this to your PythonAnywhere URL after deployment
  static const String baseUrl = 'http://localhost:8000';
  
  final TokenStorage _tokenStorage = TokenStorage();
  
  /// Initialize the API client
  Future<ApiClient> init() async {
    await _tokenStorage.init();
    return this;
  }
  
  /// Get authorization headers
  Future<Map<String, String>> _getHeaders({bool requireAuth = true}) async {
    final headers = <String, String>{
      'Content-Type': 'application/json',
      'Accept': 'application/json',
    };
    
    if (requireAuth) {
      final token = await _tokenStorage.getAccessToken();
      if (token != null) {
        headers['Authorization'] = 'Bearer $token';
      }
    }
    
    return headers;
  }
  
  /// Handle response and check for errors
  dynamic _handleResponse(http.Response response) {
    if (response.statusCode >= 200 && response.statusCode < 300) {
      if (response.body.isEmpty) return null;
      return jsonDecode(response.body);
    } else if (response.statusCode == 401) {
      // Token expired - will be handled by interceptor
      throw ApiException('Unauthorized', response.statusCode);
    } else if (response.statusCode == 404) {
      throw ApiException('Not found', response.statusCode);
    } else {
      final body = response.body.isNotEmpty ? jsonDecode(response.body) : {};
      final message = body['detail'] ?? 'Request failed';
      throw ApiException(message, response.statusCode);
    }
  }
  
  /// Refresh access token using refresh token
  Future<bool> refreshToken() async {
    final refreshToken = await _tokenStorage.getRefreshToken();
    if (refreshToken == null) return false;
    
    try {
      final response = await http.post(
        Uri.parse('$baseUrl/auth/refresh'),
        headers: {'Content-Type': 'application/json'},
        body: jsonEncode({'refresh_token': refreshToken}),
      );
      
      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);
        await _tokenStorage.saveTokens(
          accessToken: data['access_token'],
          refreshToken: data['refresh_token'],
        );
        return true;
      }
    } catch (e) {
      // Refresh failed
    }
    
    return false;
  }
  
  /// Make a request with automatic token refresh
  Future<dynamic> _requestWithRetry(
    Future<http.Response> Function(Map<String, String> headers) request,
  ) async {
    var headers = await _getHeaders();
    var response = await request(headers);
    
    // If unauthorized, try to refresh token
    if (response.statusCode == 401) {
      final refreshed = await refreshToken();
      if (refreshed) {
        headers = await _getHeaders();
        response = await request(headers);
      } else {
        // Clear tokens and redirect to login
        await _tokenStorage.clearTokens();
        throw ApiException('Session expired. Please login again.', 401);
      }
    }
    
    return _handleResponse(response);
  }
  
  /// GET request
  Future<dynamic> get(String endpoint, {Map<String, String>? queryParams}) async {
    var uri = Uri.parse('$baseUrl$endpoint');
    if (queryParams != null && queryParams.isNotEmpty) {
      uri = uri.replace(queryParameters: queryParams);
    }
    
    return _requestWithRetry((headers) => http.get(uri, headers: headers));
  }
  
  /// POST request
  Future<dynamic> post(String endpoint, {dynamic body}) async {
    final uri = Uri.parse('$baseUrl$endpoint');
    
    return _requestWithRetry(
      (headers) => http.post(uri, headers: headers, body: jsonEncode(body)),
    );
  }
  
  /// PUT request
  Future<dynamic> put(String endpoint, {dynamic body}) async {
    final uri = Uri.parse('$baseUrl$endpoint');
    
    return _requestWithRetry(
      (headers) => http.put(uri, headers: headers, body: jsonEncode(body)),
    );
  }
  
  /// PATCH request
  Future<dynamic> patch(String endpoint, {dynamic body}) async {
    final uri = Uri.parse('$baseUrl$endpoint');
    
    return _requestWithRetry(
      (headers) => http.patch(uri, headers: headers, body: jsonEncode(body)),
    );
  }
  
  /// DELETE request
  Future<dynamic> delete(String endpoint) async {
    final uri = Uri.parse('$baseUrl$endpoint');
    
    return _requestWithRetry((headers) => http.delete(uri, headers: headers));
  }
  
  // ============ Auth Methods (no token required) ============
  
  /// Register a new user
  Future<Map<String, dynamic>> register({
    required String email,
    required String password,
    required String name,
  }) async {
    final response = await http.post(
      Uri.parse('$baseUrl/auth/register'),
      headers: {'Content-Type': 'application/json'},
      body: jsonEncode({
        'email': email,
        'password': password,
        'name': name,
      }),
    );
    
    final data = _handleResponse(response);
    
    // Save tokens
    await _tokenStorage.saveTokens(
      accessToken: data['tokens']['access_token'],
      refreshToken: data['tokens']['refresh_token'],
    );
    await _tokenStorage.saveUser(data['user']);
    
    return data;
  }
  
  /// Login user
  Future<Map<String, dynamic>> login({
    required String email,
    required String password,
  }) async {
    final response = await http.post(
      Uri.parse('$baseUrl/auth/login'),
      headers: {'Content-Type': 'application/json'},
      body: jsonEncode({
        'email': email,
        'password': password,
      }),
    );
    
    final data = _handleResponse(response);
    
    // Save tokens
    await _tokenStorage.saveTokens(
      accessToken: data['tokens']['access_token'],
      refreshToken: data['tokens']['refresh_token'],
    );
    await _tokenStorage.saveUser(data['user']);
    
    return data;
  }
  
  /// Logout user
  Future<void> logout() async {
    await _tokenStorage.clearTokens();
  }
  
  /// Check if user is logged in
  Future<bool> isLoggedIn() async {
    return await _tokenStorage.hasValidToken();
  }
  
  /// Get current user
  Future<Map<String, dynamic>?> getCurrentUser() async {
    return await _tokenStorage.getUser();
  }
}

/// API Exception
class ApiException implements Exception {
  final String message;
  final int statusCode;
  
  ApiException(this.message, this.statusCode);
  
  @override
  String toString() => 'ApiException: $message (status: $statusCode)';
}


