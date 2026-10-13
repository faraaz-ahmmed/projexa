import 'package:flutter/material.dart';
import 'views/splash/splash_screen.dart';

void main() {
  runApp(const ProjexaApp());
}

// Projexa App Start
class ProjexaApp extends StatelessWidget {
  const ProjexaApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      // App Settings Start
      debugShowCheckedModeBanner: false,
      title: 'Projexa',
      // App Settings End

      // Theme Start
      theme: ThemeData(
        useMaterial3: true,
        colorScheme: ColorScheme.fromSeed(
          seedColor: const Color(0xFF126BFF),
        ),
      ),
      // Theme End

      // Splash Start
      home: const SplashScreen(),
      // Splash End
    );
  }
}
// Projexa App End