import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../routes/app_routes.dart';
import '../../utils/app_colors.dart';
import '../../viewmodels/auth_viewmodel.dart';

class SplashScreen
    extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() =>
      _SplashScreenState();
}

class _SplashScreenState
    extends State<SplashScreen> {
  // Session Check Start
  @override
  void initState() {
    super.initState();

    checkSession();
  }

  Future<void> checkSession() async {
    await Future.delayed(
      const Duration(
        seconds: 2,
      ),
    );

    if (!mounted) {
      return;
    }

    final authViewModel =
        context.read<AuthViewModel>();

    // Not Logged In Start
    if (!authViewModel.isLoggedIn) {
      Navigator
          .pushNamedAndRemoveUntil(
        context,
        AppRoutes.login,
        (route) => false,
      );

      return;
    }
    // Not Logged In End

    final user =
        await authViewModel
            .loadUserProfile();

    if (!mounted) {
      return;
    }

    if (user == null) {
      await authViewModel.logout();

      if (!mounted) {
        return;
      }

      Navigator
          .pushNamedAndRemoveUntil(
        context,
        AppRoutes.login,
        (route) => false,
      );

      return;
    }

    // Owner Start
    if (user.role == 'owner' &&
        user.accountStatus ==
            'approved') {
      Navigator
          .pushNamedAndRemoveUntil(
        context,
        AppRoutes.dashboard,
        (route) => false,
      );

      return;
    }
    // Owner End

    // Pending Start
    if (user.accountStatus ==
        'pending') {
      Navigator
          .pushNamedAndRemoveUntil(
        context,
        AppRoutes
            .pendingApproval,
        (route) => false,
      );

      return;
    }
    // Pending End

    // Member Start
    if (user.role == 'member' &&
        user.accountStatus ==
            'approved') {
      Navigator
          .pushNamedAndRemoveUntil(
        context,
        AppRoutes.memberHome,
        (route) => false,
      );

      return;
    }
    // Member End

    // Rejected / Invalid Start
    await authViewModel.logout();

    if (!mounted) {
      return;
    }

    Navigator.pushNamedAndRemoveUntil(
      context,
      AppRoutes.login,
      (route) => false,
    );
    // Rejected / Invalid End
  }
  // Session Check End

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor:
          AppColors.white,
      body: Center(
        child: Column(
          mainAxisAlignment:
              MainAxisAlignment.center,
          children: [
            // Logo Start
            SizedBox(
              width: 120,
              height: 120,
              child: Image.asset(
                'assets/icons/projexa_icon.png',
              ),
            ),
            // Logo End

            const SizedBox(
              height: 20,
            ),

            // App Name Start
            const Text(
              'Projexa',
              style: TextStyle(
                fontSize: 30,
                fontWeight:
                    FontWeight.bold,
                color:
                    AppColors.darkBlue,
              ),
            ),
            // App Name End

            const SizedBox(
              height: 25,
            ),

            // Loading Start
            const SizedBox(
              width: 25,
              height: 25,
              child:
                  CircularProgressIndicator(
                strokeWidth: 2.5,
              ),
            ),
            // Loading End
          ],
        ),
      ),
    );
  }
}