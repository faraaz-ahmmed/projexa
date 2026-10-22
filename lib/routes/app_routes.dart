import 'package:flutter/material.dart';

import '../views/auth/forgot_password_screen.dart';
import '../views/auth/login_screen.dart';
import '../views/auth/pending_approval_screen.dart';
import '../views/auth/signup_screen.dart';
import '../views/main/main_navigation_screen.dart';
import '../views/member/member_home_screen.dart';
import '../views/splash/splash_screen.dart';

class AppRoutes {
  AppRoutes._();

  // Routes Start
  static const String splash = '/';

  static const String login =
      '/login';

  static const String signUp =
      '/signup';

  static const String forgotPassword =
      '/forgot-password';

  static const String dashboard =
      '/dashboard';

  static const String pendingApproval =
      '/pending-approval';

  static const String memberHome =
      '/member-home';
  // Routes End

  // Route Map Start
  static Map<String, WidgetBuilder>
      get routes {
    return {
      splash: (context) =>
          const SplashScreen(),

      login: (context) =>
          const LoginScreen(),

      signUp: (context) =>
          const SignUpScreen(),

      forgotPassword: (context) =>
          const ForgotPasswordScreen(),

      dashboard: (context) =>
          const MainNavigationScreen(),

      pendingApproval: (context) =>
          const PendingApprovalScreen(),

      memberHome: (context) =>
          const MemberHomeScreen(),
    };
  }
  // Route Map End
}