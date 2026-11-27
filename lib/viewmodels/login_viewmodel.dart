import 'package:flutter/material.dart';

class LoginViewModel extends ChangeNotifier {
  bool isPasswordHidden = true;

  void togglePassword() {
    isPasswordHidden = !isPasswordHidden;
    notifyListeners();
  }
}