import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

import '../services/auth_service.dart';

class AuthViewModel extends ChangeNotifier {
  final _service = AuthService();

  bool isLoading = false;
  String? error;

  Future<bool> login(String email, String password) async {
    if (isLoading) return false;

    isLoading = true;
    error = null;
    notifyListeners();

    try {
      await _service.login(email, password);
      return true;
    } on FirebaseAuthException catch (e) {
      error = e.message ?? 'Login failed. Please try again.';
      return false;
    } catch (_) {
      error = 'Something went wrong. Please try again.';
      return false;
    } finally {
      isLoading = false;
      notifyListeners();
    }
  }

  Future<bool> signUp(
    String name,
    String email,
    String password,
  ) async {
    if (isLoading) return false;

    isLoading = true;
    error = null;
    notifyListeners();

    try {
      await _service.signUp(name, email, password);
      return true;
    } on FirebaseAuthException catch (e) {
      error = e.message ?? 'Sign up failed. Please try again.';
      return false;
    } catch (_) {
      error = 'Something went wrong. Please try again.';
      return false;
    } finally {
      isLoading = false;
      notifyListeners();
    }
  }

  Future<bool> resetPassword(String email) async {
    if (isLoading) return false;

    isLoading = true;
    error = null;
    notifyListeners();

    try {
      await _service.resetPassword(email);
      return true;
    } on FirebaseAuthException catch (e) {
      error = e.message ?? 'Could not send reset email.';
      return false;
    } catch (_) {
      error = 'Something went wrong. Please try again.';
      return false;
    } finally {
      isLoading = false;
      notifyListeners();
    }
  }

  Future<bool> logout() async {
    if (isLoading) return false;

    isLoading = true;
    error = null;
    notifyListeners();

    try {
      await _service.logout();
      return true;
    } catch (_) {
      error = 'Logout failed. Please try again.';
      return false;
    } finally {
      isLoading = false;
      notifyListeners();
    }
  }
}