import 'dart:async';

import 'package:flutter/material.dart';

import '../auth/login_screen.dart';

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

      Navigator.pushReplacement(
        context,
        MaterialPageRoute(
          builder: (_) => const LoginScreen(),
        ),
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
              Color(0xFF071B4A),
              Color(0xFF063C9D),
              Color(0xFF071B4A),
            ],
          ),
        ),
        child: SafeArea(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
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
                'Projexa',
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 40,
                  fontWeight: FontWeight.bold,
                ),
              ),

              const SizedBox(height: 12),

              const Text(
                'Collaborative Project\nExecution & Tracking Platform',
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
                  color: Color(0xFF22D3EE),
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