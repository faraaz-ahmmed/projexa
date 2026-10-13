import 'package:flutter/material.dart';

import '../views/auth/forgot_password_screen.dart';
import '../views/auth/login_screen.dart';
import '../views/auth/signup_screen.dart';
import '../views/splash/splash_screen.dart';

class AppRoutes {
  AppRoutes._();

  // Route Names Start
  static const splash = '/';
  static const login = '/login';
  static const signUp = '/signup';
  static const forgotPassword = '/forgot-password';
  // Route Names End

  // Routes Start
  static Map<String, WidgetBuilder> get routes {
    return {
      splash: (_) => const SplashScreen(),
      login: (_) => const LoginScreen(),
      signUp: (_) => const SignUpScreen(),
      forgotPassword: (_) => const ForgotPasswordScreen(),
    };
  }
  // Routes End
}