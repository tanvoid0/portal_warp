import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../../core/services/api_client.dart';
import '../../../routes/app_routes.dart';

/// Auth controller for login/register functionality
class AuthController extends GetxController {
  final ApiClient _apiClient = Get.find<ApiClient>();
  
  // Form controllers
  final emailController = TextEditingController();
  final passwordController = TextEditingController();
  final nameController = TextEditingController();
  final confirmPasswordController = TextEditingController();
  
  // State
  final isLoading = false.obs;
  final isLogin = true.obs;
  final obscurePassword = true.obs;
  final obscureConfirmPassword = true.obs;
  final errorMessage = ''.obs;
  
  // Form key
  final formKey = GlobalKey<FormState>();
  
  @override
  void onClose() {
    emailController.dispose();
    passwordController.dispose();
    nameController.dispose();
    confirmPasswordController.dispose();
    super.onClose();
  }
  
  /// Toggle between login and register
  void toggleMode() {
    isLogin.value = !isLogin.value;
    errorMessage.value = '';
    // Clear form
    emailController.clear();
    passwordController.clear();
    nameController.clear();
    confirmPasswordController.clear();
  }
  
  /// Toggle password visibility
  void togglePasswordVisibility() {
    obscurePassword.value = !obscurePassword.value;
  }
  
  /// Toggle confirm password visibility
  void toggleConfirmPasswordVisibility() {
    obscureConfirmPassword.value = !obscureConfirmPassword.value;
  }
  
  /// Validate email
  String? validateEmail(String? value) {
    if (value == null || value.isEmpty) {
      return 'Email is required';
    }
    if (!GetUtils.isEmail(value)) {
      return 'Please enter a valid email';
    }
    return null;
  }
  
  /// Validate password
  String? validatePassword(String? value) {
    if (value == null || value.isEmpty) {
      return 'Password is required';
    }
    if (value.length < 6) {
      return 'Password must be at least 6 characters';
    }
    return null;
  }
  
  /// Validate name
  String? validateName(String? value) {
    if (!isLogin.value) {
      if (value == null || value.isEmpty) {
        return 'Name is required';
      }
    }
    return null;
  }
  
  /// Validate confirm password
  String? validateConfirmPassword(String? value) {
    if (!isLogin.value) {
      if (value == null || value.isEmpty) {
        return 'Please confirm your password';
      }
      if (value != passwordController.text) {
        return 'Passwords do not match';
      }
    }
    return null;
  }
  
  /// Submit form (login or register)
  Future<void> submit() async {
    if (!formKey.currentState!.validate()) return;
    
    isLoading.value = true;
    errorMessage.value = '';
    
    try {
      if (isLogin.value) {
        await _login();
      } else {
        await _register();
      }
      
      // Navigate to main app
      Get.offAllNamed(Routes.today);
    } on ApiException catch (e) {
      errorMessage.value = e.message;
    } catch (e) {
      errorMessage.value = 'Connection error. Please check your internet.';
    } finally {
      isLoading.value = false;
    }
  }
  
  /// Login
  Future<void> _login() async {
    await _apiClient.login(
      email: emailController.text.trim(),
      password: passwordController.text,
    );
  }
  
  /// Register
  Future<void> _register() async {
    await _apiClient.register(
      email: emailController.text.trim(),
      password: passwordController.text,
      name: nameController.text.trim(),
    );
  }
  
  /// Check if user is already logged in
  Future<bool> checkAuthStatus() async {
    return await _apiClient.isLoggedIn();
  }
  
  /// Logout
  Future<void> logout() async {
    await _apiClient.logout();
    Get.offAllNamed(Routes.login);
  }
}


