import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../routes/app_routes.dart';
import '../../utils/app_colors.dart';
import '../../viewmodels/auth_viewmodel.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  // Splash Start
  @override
  void initState() {
    super.initState();
    startSplash();
  }

  Future<void> startSplash() async {
    await Future.delayed(
      const Duration(seconds: 2),
    );

    if (!mounted) return;

    final authViewModel = context.read<AuthViewModel>();

    if (authViewModel.isLoggedIn) {
      Navigator.pushNamedAndRemoveUntil(
        context,
        AppRoutes.dashboard,
        (route) => false,
      );
    } else {
      Navigator.pushNamedAndRemoveUntil(
        context,
        AppRoutes.login,
        (route) => false,
      );
    }
  }
  // Splash End

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      // Body Start
      body: Container(
        width: double.infinity,
        height: double.infinity,
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
            colors: [
              AppColors.darkBlue,
              AppColors.mediumBlue,
            ],
          ),
        ),
        child: SafeArea(
          child: Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                // Logo Start
                Image.asset(
                  'assets/icons/projexa_icon.png',
                  width: 130,
                  height: 130,
                ),
                // Logo End

                const SizedBox(height: 24),

                // App Name Start
                const Text(
                  'Projexa',
                  style: TextStyle(
                    color: AppColors.white,
                    fontSize: 38,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                // App Name End

                const SizedBox(height: 10),

                // Tagline Start
                const Text(
                  'Collaborative Project\nExecution & Tracking Platform',
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    color: AppColors.white,
                    fontSize: 15,
                    height: 1.5,
                  ),
                ),
                // Tagline End

                const SizedBox(height: 35),

                // Loading Start
                const CircularProgressIndicator(
                  color: AppColors.white,
                ),
                // Loading End
              ],
            ),
          ),
        ),
      ),
      // Body End
    );
  }
}