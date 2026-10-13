import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import 'utils/app_colors.dart';
import 'viewmodels/auth_viewmodel.dart';
import 'views/splash/splash_screen.dart';

void main() {
  runApp(const ProjexaApp());
}

// Projexa App Start
class ProjexaApp extends StatelessWidget {
  const ProjexaApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      // Providers Start
      providers: [
        ChangeNotifierProvider(
          create: (_) => AuthViewModel(),
        ),
      ],
      // Providers End

      child: MaterialApp(
        // App Settings Start
        debugShowCheckedModeBanner: false,
        title: 'Projexa',
        // App Settings End

        // Theme Start
        theme: ThemeData(
          useMaterial3: true,
          colorScheme: ColorScheme.fromSeed(
            seedColor: AppColors.primary,
          ),
          scaffoldBackgroundColor: AppColors.white,
        ),
        // Theme End

        // App Start
        home: const SplashScreen(),
        // App End
      ),
    );
  }
}
// Projexa App End