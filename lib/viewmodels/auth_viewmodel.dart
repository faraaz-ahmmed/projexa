import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';

import '../models/user_model.dart';
import '../services/auth_service.dart';
import '../services/user_service.dart';

class AuthViewModel extends ChangeNotifier {
  final AuthService _authService =
      AuthService();

  final UserService _userService =
      UserService();

  bool _isLoading = false;

  bool _hidePassword = true;
  bool _hideConfirmPassword = true;

  String? _errorMessage;

  UserModel? _userProfile;

  // Getters Start
  bool get isLoading => _isLoading;

  bool get hidePassword => _hidePassword;

  bool get hideConfirmPassword =>
      _hideConfirmPassword;

  String? get errorMessage =>
      _errorMessage;

  User? get currentUser =>
      _authService.currentUser;

  UserModel? get userProfile =>
      _userProfile;

  bool get isLoggedIn =>
      _authService.isLoggedIn;

  bool get isOwner =>
      _userProfile?.isOwner ?? false;

  bool get isMember =>
      _userProfile?.isMember ?? false;

  bool get isApproved =>
      _userProfile?.isApproved ?? false;

  bool get isPending =>
      _userProfile?.isPending ?? false;
  // Getters End

  // Password Visibility Start
  void togglePassword() {
    _hidePassword = !_hidePassword;

    notifyListeners();
  }

  void toggleConfirmPassword() {
    _hideConfirmPassword =
        !_hideConfirmPassword;

    notifyListeners();
  }
  // Password Visibility End

  // Load User Profile Start
  Future<UserModel?> loadUserProfile() async {
    final user = _authService.currentUser;

    if (user == null) {
      _userProfile = null;

      notifyListeners();

      return null;
    }

    try {
      _userProfile =
          await _userService.getUser(
        user.uid,
      );

      _errorMessage = null;

      notifyListeners();

      return _userProfile;
    } on FirebaseException catch (e) {
      _errorMessage =
          'Database error: ${e.message ?? 'Unable to load user profile.'}';

      notifyListeners();

      return null;
    } catch (_) {
      _errorMessage =
          'Unable to load user profile.';

      notifyListeners();

      return null;
    }
  }
  // Load User Profile End

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

      final profile =
          await loadUserProfile();

      if (profile == null) {
        await _authService.logout();

        _errorMessage =
            'User profile not found.';

        return false;
      }

      _errorMessage = null;

      return true;
    } on FirebaseAuthException catch (e) {
      _errorMessage =
          _getErrorMessage(e.code);

      return false;
    } on FirebaseException catch (e) {
      _errorMessage =
          'Database error: ${e.message ?? 'Unable to login.'}';

      return false;
    } catch (_) {
      _errorMessage =
          'Something went wrong. Please try again.';

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
      final result =
          await _authService.signUp(
        email: email,
        password: password,
      );

      final user = result.user;

      if (user == null) {
        _errorMessage =
            'Unable to create account.';

        return false;
      }

      // New Member Start
      final userModel = UserModel(
        uid: user.uid,
        name: name.trim(),
        email: email.trim().toLowerCase(),
        role: 'member',
        accountStatus: 'pending',
        createdAt: DateTime.now(),
      );
      // New Member End

      await _userService.createUser(
        userModel,
      );

      _userProfile = userModel;

      _errorMessage = null;

      return true;
    } on FirebaseAuthException catch (e) {
      _errorMessage =
          _getErrorMessage(e.code);

      return false;
    } on FirebaseException catch (e) {
      _errorMessage =
          'Database error: ${e.message ?? 'Unable to save user profile.'}';

      return false;
    } catch (_) {
      _errorMessage =
          'Something went wrong. Please try again.';

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
      _errorMessage =
          _getErrorMessage(e.code);

      return false;
    } catch (_) {
      _errorMessage =
          'Something went wrong. Please try again.';

      return false;
    } finally {
      _setLoading(false);
    }
  }
  // Forgot Password End

  // Logout Start
  Future<void> logout() async {
    try {
      await _authService.logout();

      _userProfile = null;
      _errorMessage = null;
    } on FirebaseAuthException catch (e) {
      _errorMessage =
          _getErrorMessage(e.code);
    } catch (_) {
      _errorMessage =
          'Unable to logout. Please try again.';
    }

    notifyListeners();
  }
  // Logout End

  // Loading Start
  void _setLoading(
    bool value,
  ) {
    _isLoading = value;

    notifyListeners();
  }
  // Loading End

  // Firebase Errors Start
  String _getErrorMessage(
    String code,
  ) {
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