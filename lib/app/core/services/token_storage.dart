import 'dart:convert';
import 'package:shared_preferences/shared_preferences.dart';

/// Secure token storage using SharedPreferences
class TokenStorage {
  static const String _accessTokenKey = 'portal_warp_access_token';
  static const String _refreshTokenKey = 'portal_warp_refresh_token';
  static const String _userKey = 'portal_warp_user';
  
  SharedPreferences? _prefs;
  
  /// Initialize shared preferences
  Future<void> init() async {
    _prefs ??= await SharedPreferences.getInstance();
  }
  
  /// Save tokens
  Future<void> saveTokens({
    required String accessToken,
    required String refreshToken,
  }) async {
    await init();
    await _prefs!.setString(_accessTokenKey, accessToken);
    await _prefs!.setString(_refreshTokenKey, refreshToken);
  }
  
  /// Get access token
  Future<String?> getAccessToken() async {
    await init();
    return _prefs!.getString(_accessTokenKey);
  }
  
  /// Get refresh token
  Future<String?> getRefreshToken() async {
    await init();
    return _prefs!.getString(_refreshTokenKey);
  }
  
  /// Save user data
  Future<void> saveUser(Map<String, dynamic> user) async {
    await init();
    await _prefs!.setString(_userKey, jsonEncode(user));
  }
  
  /// Get user data
  Future<Map<String, dynamic>?> getUser() async {
    await init();
    final userJson = _prefs!.getString(_userKey);
    if (userJson != null) {
      return jsonDecode(userJson) as Map<String, dynamic>;
    }
    return null;
  }
  
  /// Clear all tokens
  Future<void> clearTokens() async {
    await init();
    await _prefs!.remove(_accessTokenKey);
    await _prefs!.remove(_refreshTokenKey);
    await _prefs!.remove(_userKey);
  }
  
  /// Check if user has a valid token
  Future<bool> hasValidToken() async {
    final token = await getAccessToken();
    return token != null && token.isNotEmpty;
  }
}


