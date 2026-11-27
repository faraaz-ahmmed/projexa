import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../core/app_colors.dart';
import '../../core/input_style.dart';
import '../../viewmodels/signup_viewmodel.dart';

class SignUpView extends StatelessWidget {
  const SignUpView({super.key});

  @override
  Widget build(BuildContext context) {
    final viewModel = context.watch<SignUpViewModel>();

    return Scaffold(
      backgroundColor: AppColors.navy,
      appBar: AppBar(
        backgroundColor: AppColors.navy,
        foregroundColor: Colors.white,
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(24),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Text(
                'Create Account',
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 24,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: 8),
              const Text(
                'Join ProJexa and start managing your projects today.',
                style: TextStyle(color: Colors.white70),
              ),
              const SizedBox(height: 24),
              TextField(
                decoration: inputStyle('Full name', Icons.person_outline),
              ),
              const SizedBox(height: 16),
              TextField(
                keyboardType: TextInputType.emailAddress,
                decoration: inputStyle('Email address', Icons.email_outlined),
              ),
              const SizedBox(height: 16),
              TextField(
                obscureText: viewModel.isPasswordHidden,
                decoration: inputStyle(
                  'Password',
                  Icons.lock_outline,
                  suffix: _eyeButton(
                    viewModel.isPasswordHidden,
                    viewModel.togglePassword,
                  ),
                ),
              ),
              const SizedBox(height: 16),
              TextField(
                obscureText: viewModel.isConfirmHidden,
                decoration: inputStyle(
                  'Confirm password',
                  Icons.lock_outline,
                  suffix: _eyeButton(
                    viewModel.isConfirmHidden,
                    viewModel.toggleConfirm,
                  ),
                ),
              ),
              const SizedBox(height: 24),
              ElevatedButton(
                onPressed: () {},
                child: const Text('Sign Up'),
              ),
              const SizedBox(height: 16),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const Text(
                    'Already have an account?',
                    style: TextStyle(color: Colors.white70),
                  ),
                  TextButton(
                    onPressed: () => Navigator.pop(context),
                    child: const Text('Login'),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _eyeButton(bool isHidden, VoidCallback onTap) {
    return IconButton(
      onPressed: onTap,
      icon: Icon(isHidden ? Icons.visibility_off : Icons.visibility),
    );
  }
}