import 'package:flutter/material.dart';

class AuthViewModel extends ChangeNotifier {
  bool _isLoading = false;
  bool _hidePassword = true;
  bool _hideConfirmPassword = true;

  // Getters Start
  bool get isLoading => _isLoading;
  bool get hidePassword => _hidePassword;
  bool get hideConfirmPassword => _hideConfirmPassword;
  // Getters End

  // Password Visibility Start
  void togglePassword() {
    _hidePassword = !_hidePassword;
    notifyListeners();
  }

  void toggleConfirmPassword() {
    _hideConfirmPassword = !_hideConfirmPassword;
    notifyListeners();
  }
  // Password Visibility End

  // Loading Start
  void setLoading(bool value) {
    _isLoading = value;
    notifyListeners();
  }
  // Loading End
}