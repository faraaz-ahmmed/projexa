import 'package:flutter/material.dart';

import '../views/auth/forgot_password_screen.dart';
import '../views/auth/login_screen.dart';
import '../views/auth/signup_screen.dart';
import '../views/dashboard/dashboard_screen.dart';
import '../views/splash/splash_screen.dart';

class AppRoutes {
  AppRoutes._();

  // Route Names Start
  static const String splash = '/';
  static const String login = '/login';
  static const String signUp = '/signup';
  static const String forgotPassword = '/forgot-password';
  static const String dashboard = '/dashboard';
  // Route Names End

  // Routes Start
  static Map<String, WidgetBuilder> get routes {
    return {
      splash: (context) => const SplashScreen(),
      login: (context) => const LoginScreen(),
      signUp: (context) => const SignUpScreen(),
      forgotPassword: (context) => const ForgotPasswordScreen(),
      dashboard: (context) => const DashboardScreen(),
    };
  }
  // Routes End
}