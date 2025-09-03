// login_provider.dart
import 'package:flutter/material.dart';

class LoginProvider extends ChangeNotifier {
  final TextEditingController _idController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();

  bool _isPasswordVisible = false;
  bool _isLoading = false;
  bool _rememberMe = false;
  String? _errorMessage;

  // Getters
  TextEditingController get idController => _idController;

  TextEditingController get passwordController => _passwordController;

  GlobalKey<FormState> get formKey => _formKey;

  bool get isPasswordVisible => _isPasswordVisible;

  bool get isLoading => _isLoading;

  bool get rememberMe => _rememberMe;

  String? get errorMessage => _errorMessage;

  // Methods
  void togglePasswordVisibility() {
    _isPasswordVisible = !_isPasswordVisible;
    notifyListeners();
  }

  void toggleRememberMe(bool? value) {
    _rememberMe = value ?? false;
    notifyListeners();
  }

  void clearError() {
    _errorMessage = null;
    notifyListeners();
  }

  Future<bool> signIn() async {
    if (!_formKey.currentState!.validate()) {
      return false;
    }

    _isLoading = true;
    _errorMessage = null;
    notifyListeners();

    try {
      // Simulate API call
      await Future.delayed(const Duration(milliseconds: 1500));

      // Mock authentication logic
      if (_idController.text.toLowerCase() == '123456' &&
          _passwordController.text == '123456') {
        // Save remember me preference if needed
        if (_rememberMe) {
          // Save credentials to secure storage
          await _saveCredentials();
        }

        _isLoading = false;
        notifyListeners();
        return true;
      } else {
        throw Exception('Invalid credentials');
      }
    } catch (e) {
      _errorMessage = 'Login failed. Please check your credentials.';
      _isLoading = false;
      notifyListeners();
      return false;
    }
  }

  Future<void> _saveCredentials() async {
    // Implement secure storage for remember me functionality
    // Example: await FlutterSecureStorage().write(key: 'user_id', value: _idController.text);
    print('Credentials saved for remember me');
  }

  String? validateUserId(String? value) {
    if (value == null || value.isEmpty) {
      return 'Please enter your User ID';
    }
    if (value.length < 3) {
      return 'User ID must be at least 3 characters';
    }
    return null;
  }

  String? validatePassword(String? value) {
    if (value == null || value.isEmpty) {
      return 'Please enter your password';
    }
    if (value.length < 6) {
      return 'Password must be at least 6 characters';
    }
    return null;
  }

  @override
  void dispose() {
    _idController.dispose();
    _passwordController.dispose();
    super.dispose();
  }
}
