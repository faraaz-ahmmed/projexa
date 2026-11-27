import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'core/app_theme.dart';
import 'viewmodels/login_viewmodel.dart';
import 'views/auth/login_view.dart';

void main() {
  runApp(const ProjexaApp());
}

class ProjexaApp extends StatelessWidget {
  const ProjexaApp({super.key});

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (_) => LoginViewModel(),
      child: MaterialApp(
        debugShowCheckedModeBanner: false,
        theme: AppTheme.light,
        home: const LoginView(),
      ),
    );
  }
}