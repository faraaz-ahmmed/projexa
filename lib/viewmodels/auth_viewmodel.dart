import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

import '../models/user_model.dart';
import '../services/auth_service.dart';
import '../services/user_service.dart';

class AuthViewModel extends ChangeNotifier {
  final AuthService _authService = AuthService();
  final UserService _userService = UserService();

  bool _isLoading = false;
  bool _hidePassword = true;
  bool _hideConfirmPassword = true;

  String? _errorMessage;

  // Getters Start
  bool get isLoading => _isLoading;
  bool get hidePassword => _hidePassword;
  bool get hideConfirmPassword => _hideConfirmPassword;
  String? get errorMessage => _errorMessage;
  User? get currentUser => _authService.currentUser;
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

  // Login Start
  Future<bool> login({
    required String email,
    required String password,
  }) async {
    _setLoading(true);

    try {
      await _authService.login(
        email: email,
        password: password,
      );

      _errorMessage = null;
      return true;
    } on FirebaseAuthException catch (e) {
      _errorMessage = _getErrorMessage(e.code);
      return false;
    } catch (_) {
      _errorMessage = 'Something went wrong. Please try again.';
      return false;
    } finally {
      _setLoading(false);
    }
  }
  // Login End

  // Sign Up Start
  Future<bool> signUp({
    required String name,
    required String email,
    required String password,
  }) async {
    _setLoading(true);

    try {
      final result = await _authService.signUp(
        email: email,
        password: password,
      );

      final user = result.user;

      if (user == null) {
        _errorMessage = 'Unable to create account.';
        return false;
      }

      final userModel = UserModel(
        uid: user.uid,
        name: name.trim(),
        email: email.trim(),
        role: 'member',
        createdAt: DateTime.now(),
      );

      await _userService.createUser(userModel);

      _errorMessage = null;
      return true;
    } on FirebaseAuthException catch (e) {
      _errorMessage = _getErrorMessage(e.code);
      return false;
    } catch (_) {
      _errorMessage = 'Something went wrong. Please try again.';
      return false;
    } finally {
      _setLoading(false);
    }
  }
  // Sign Up End

  // Forgot Password Start
  Future<bool> resetPassword({
    required String email,
  }) async {
    _setLoading(true);

    try {
      await _authService.resetPassword(
        email: email,
      );

      _errorMessage = null;
      return true;
    } on FirebaseAuthException catch (e) {
      _errorMessage = _getErrorMessage(e.code);
      return false;
    } catch (_) {
      _errorMessage = 'Something went wrong. Please try again.';
      return false;
    } finally {
      _setLoading(false);
    }
  }
  // Forgot Password End

  // Logout Start
  Future<void> logout() async {
    await _authService.logout();
    notifyListeners();
  }
  // Logout End

  // Loading Start
  void _setLoading(bool value) {
    _isLoading = value;
    notifyListeners();
  }
  // Loading End

  // Firebase Errors Start
  String _getErrorMessage(String code) {
    switch (code) {
      case 'invalid-email':
        return 'Please enter a valid email address.';

      case 'email-already-in-use':
        return 'This email is already registered.';

      case 'weak-password':
        return 'Password is too weak.';

      case 'user-not-found':
        return 'No account found with this email.';

      case 'wrong-password':
      case 'invalid-credential':
        return 'Incorrect email or password.';

      case 'too-many-requests':
        return 'Too many attempts. Please try again later.';

      case 'network-request-failed':
        return 'Please check your internet connection.';

      default:
        return 'Authentication failed. Please try again.';
    }
  }
  // Firebase Errors End
}