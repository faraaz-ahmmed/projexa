import 'package:flutter/material.dart';

import 'views/splash_screen.dart';

void main() {
  runApp(const ProjexaApp());
}

class ProjexaApp extends StatelessWidget {
  const ProjexaApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Projexa',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        useMaterial3: true,
        colorScheme: ColorScheme.fromSeed(
          seedColor: const Color(0xff155DFC),
        ),
        scaffoldBackgroundColor: const Color(0xffF5F7FF),
      ),
      home: const SplashScreen(),
    );
  }
}