import 'package:firebase_auth/firebase_auth.dart';

class AuthService {
  final FirebaseAuth _auth = FirebaseAuth.instance;

  // Current User Start
  User? get currentUser => _auth.currentUser;

  bool get isLoggedIn => _auth.currentUser != null;
  // Current User End

  // Auth State Start
  Stream<User?> get authStateChanges {
    return _auth.authStateChanges();
  }
  // Auth State End

  // Sign Up Start
  Future<UserCredential> signUp({
    required String email,
    required String password,
  }) async {
    return await _auth.createUserWithEmailAndPassword(
      email: email.trim(),
      password: password.trim(),
    );
  }
  // Sign Up End

  // Login Start
  Future<UserCredential> login({
    required String email,
    required String password,
  }) async {
    return await _auth.signInWithEmailAndPassword(
      email: email.trim(),
      password: password.trim(),
    );
  }
  // Login End

  // Forgot Password Start
  Future<void> resetPassword({
    required String email,
  }) async {
    await _auth.sendPasswordResetEmail(
      email: email.trim(),
    );
  }
  // Forgot Password End

  // Logout Start
  Future<void> logout() async {
    await _auth.signOut();
  }
  // Logout End
}