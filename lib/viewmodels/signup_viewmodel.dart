import 'package:flutter/material.dart';

class SignUpViewModel extends ChangeNotifier {
  bool isPasswordHidden = true;
  bool isConfirmHidden = true;

  void togglePassword() {
    isPasswordHidden = !isPasswordHidden;
    notifyListeners();
  }

  void toggleConfirm() {
    isConfirmHidden = !isConfirmHidden;
    notifyListeners();
  }
}