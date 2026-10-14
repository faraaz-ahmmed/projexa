import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import 'firebase_options.dart';
import 'routes/app_routes.dart';
import 'utils/app_colors.dart';
import 'viewmodels/auth_viewmodel.dart';
import 'viewmodels/dashboard_viewmodel.dart';

// Main Start
Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();

  // Firebase Start
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
  // Firebase End

  runApp(const ProjexaApp());
}
// Main End

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
        ChangeNotifierProvider(
          create: (_) => DashboardViewModel(),
        ),
      ],
      // Providers End

      child: MaterialApp(
        // App Settings Start
        debugShowCheckedModeBanner: false,
        title: 'Projexa',
        initialRoute: AppRoutes.splash,
        routes: AppRoutes.routes,
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
      ),
    );
  }
}
// Projexa App End