import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../viewmodels/auth_viewmodel.dart';
import '../auth/login_screen.dart';

class DashboardScreen extends StatelessWidget {
  const DashboardScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final auth = context.watch<AuthViewModel>();
    final user = FirebaseAuth.instance.currentUser;
    final name = user?.displayName;
    final greeting = name == null || name.isEmpty ? 'User' : name;

    return Scaffold(
      appBar: AppBar(
        title: const Text('Projexa'),
        actions: [
          IconButton(
            tooltip: 'Logout',
            onPressed: auth.isLoading
                ? null
                : () async {
                    final success = await auth.logout();

                    if (!context.mounted) return;

                    if (success) {
                      Navigator.of(context).pushAndRemoveUntil(
                        MaterialPageRoute(
                          builder: (_) => const LoginScreen(),
                        ),
                        (_) => false,
                      );
                    } else {
                      ScaffoldMessenger.of(context).showSnackBar(
                        SnackBar(
                          content: Text(auth.error ?? 'Logout failed'),
                        ),
                      );
                    }
                  },
            icon: const Icon(Icons.logout),
          ),
        ],
      ),
      body: Center(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text(
              'Welcome, $greeting!',
              style: const TextStyle(
                fontSize: 24,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 8),
            Text(user?.email ?? ''),
          ],
        ),
      ),
    );
  }
}