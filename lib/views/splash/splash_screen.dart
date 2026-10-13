import 'dart:async';

import 'package:flutter/material.dart';

import '../../routes/app_routes.dart';
import '../../utils/app_colors.dart';
import '../../utils/app_strings.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  // Splash Timer Start
  @override
  void initState() {
    super.initState();

    Timer(const Duration(seconds: 3), () {
      if (!mounted) return;

      Navigator.pushReplacementNamed(
        context,
        AppRoutes.login,
      );
    });
  }
  // Splash Timer End

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
              AppColors.darkBlue,
            ],
          ),
        ),
        child: SafeArea(
          child: Column(
            children: [
              const Spacer(),

              // Logo Start
              Image.asset(
                'assets/icons/projexa_icon.png',
                width: 150,
                height: 150,
              ),
              // Logo End

              const SizedBox(height: 25),

              // App Name Start
              const Text(
                AppStrings.appName,
                style: TextStyle(
                  color: AppColors.white,
                  fontSize: 40,
                  fontWeight: FontWeight.bold,
                ),
              ),

              const SizedBox(height: 12),

              const Text(
                AppStrings.appTagline,
                textAlign: TextAlign.center,
                style: TextStyle(
                  color: Colors.white70,
                  fontSize: 15,
                  height: 1.5,
                ),
              ),
              // App Name End

              const Spacer(),

              // Loading Start
              const SizedBox(
                width: 35,
                height: 35,
                child: CircularProgressIndicator(
                  color: AppColors.secondary,
                  strokeWidth: 3,
                ),
              ),

              const SizedBox(height: 15),

              const Text(
                'Loading...',
                style: TextStyle(
                  color: Colors.white70,
                  fontSize: 14,
                ),
              ),

              const SizedBox(height: 45),
              // Loading End
            ],
          ),
        ),
      ),
      // Body End
    );
  }
}