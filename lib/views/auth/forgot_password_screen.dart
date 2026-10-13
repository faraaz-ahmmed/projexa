import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../viewmodels/auth_viewmodel.dart';

class ForgotPasswordScreen extends StatefulWidget {
  const ForgotPasswordScreen({super.key});

  @override
  State<ForgotPasswordScreen> createState() =>
      _ForgotPasswordScreenState();
}

class _ForgotPasswordScreenState
    extends State<ForgotPasswordScreen> {
  final formKey = GlobalKey<FormState>();
  final emailController = TextEditingController();

  // Email Validation Start
  String? validateEmail(String? value) {
    if (value == null || value.trim().isEmpty) {
      return 'Please enter your email address';
    }

    if (!value.contains('@') || !value.contains('.')) {
      return 'Please enter a valid email address';
    }

    return null;
  }
  // Email Validation End

  // Reset Password Start
  Future<void> resetPassword() async {
    if (!formKey.currentState!.validate()) {
      return;
    }

    final authViewModel = context.read<AuthViewModel>();

    final success = await authViewModel.resetPassword(
      email: emailController.text.trim(),
    );

    if (!mounted) return;

    if (success) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text(
            'Password reset email sent. Please check your inbox.',
          ),
        ),
      );

      Navigator.pop(context);
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(
            authViewModel.errorMessage ??
                'Unable to send password reset email.',
          ),
        ),
      );
    }
  }
  // Reset Password End

  @override
  void dispose() {
    emailController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final authViewModel = context.watch<AuthViewModel>();

    return Scaffold(
      // AppBar Start
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
      ),
      // AppBar End

      // Body Start
      body: SafeArea(
        child: Center(
          child: SingleChildScrollView(
            padding: const EdgeInsets.symmetric(
              horizontal: 24,
              vertical: 20,
            ),
            child: ConstrainedBox(
              constraints: const BoxConstraints(
                maxWidth: 420,
              ),

              // Form Start
              child: Form(
                key: formKey,
                child: Column(
                  children: [
                    // Logo Start
                    Image.asset(
                      'assets/icons/projexa_icon.png',
                      width: 100,
                      height: 100,
                    ),
                    // Logo End

                    const SizedBox(height: 25),

                    // Header Start
                    const Text(
                      'Forgot Password?',
                      textAlign: TextAlign.center,
                      style: TextStyle(
                        fontSize: 30,
                        fontWeight: FontWeight.bold,
                      ),
                    ),

                    const SizedBox(height: 10),

                    const Text(
                      'Enter your registered email address and we will send you a password reset link.',
                      textAlign: TextAlign.center,
                      style: TextStyle(
                        color: Colors.grey,
                        fontSize: 15,
                        height: 1.5,
                      ),
                    ),
                    // Header End

                    const SizedBox(height: 35),

                    // Email Start
                    TextFormField(
                      controller: emailController,
                      keyboardType:
                          TextInputType.emailAddress,
                      textInputAction: TextInputAction.done,
                      validator: validateEmail,
                      onFieldSubmitted: (_) {
                        if (!authViewModel.isLoading) {
                          resetPassword();
                        }
                      },
                      decoration: const InputDecoration(
                        labelText: 'Email Address',
                        prefixIcon: Icon(
                          Icons.email_outlined,
                        ),
                        border: OutlineInputBorder(),
                      ),
                    ),
                    // Email End

                    const SizedBox(height: 25),

                    // Reset Button Start
                    SizedBox(
                      width: double.infinity,
                      height: 52,
                      child: FilledButton(
                        onPressed:
                            authViewModel.isLoading
                                ? null
                                : resetPassword,
                        child: authViewModel.isLoading
                            ? const SizedBox(
                                width: 22,
                                height: 22,
                                child:
                                    CircularProgressIndicator(
                                  strokeWidth: 2,
                                ),
                              )
                            : const Text(
                                'Send Reset Link',
                                style: TextStyle(
                                  fontSize: 16,
                                ),
                              ),
                      ),
                    ),
                    // Reset Button End

                    const SizedBox(height: 20),

                    // Back To Login Start
                    TextButton.icon(
                      onPressed:
                          authViewModel.isLoading
                              ? null
                              : () {
                                  Navigator.pop(context);
                                },
                      icon: const Icon(
                        Icons.arrow_back,
                      ),
                      label: const Text(
                        'Back to Login',
                      ),
                    ),
                    // Back To Login End
                  ],
                ),
              ),
              // Form End
            ),
          ),
        ),
      ),
      // Body End
    );
  }
}