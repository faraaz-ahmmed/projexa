import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../utils/app_strings.dart';
import '../../viewmodels/auth_viewmodel.dart';

class SignUpScreen extends StatefulWidget {
  const SignUpScreen({super.key});

  @override
  State<SignUpScreen> createState() => _SignUpScreenState();
}

class _SignUpScreenState extends State<SignUpScreen> {
  final formKey = GlobalKey<FormState>();

  final nameController = TextEditingController();
  final emailController = TextEditingController();
  final passwordController = TextEditingController();
  final confirmPasswordController = TextEditingController();

  // Email Validation Start
  String? validateEmail(String? value) {
    if (value == null || value.trim().isEmpty) {
      return 'Please enter your email';
    }

    if (!value.contains('@') || !value.contains('.')) {
      return 'Please enter a valid email';
    }

    return null;
  }
  // Email Validation End

  @override
  void dispose() {
    nameController.dispose();
    emailController.dispose();
    passwordController.dispose();
    confirmPasswordController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final authViewModel = context.watch<AuthViewModel>();

    return Scaffold(
      // Body Start
      body: SafeArea(
        child: Center(
          child: SingleChildScrollView(
            padding: const EdgeInsets.symmetric(
              horizontal: 24,
              vertical: 30,
            ),
            child: ConstrainedBox(
              constraints: const BoxConstraints(maxWidth: 420),

              // Sign Up Form Start
              child: Form(
                key: formKey,
                child: Column(
                  children: [
                    // Logo Start
                    Image.asset(
                      'assets/icons/projexa_icon.png',
                      width: 90,
                      height: 90,
                    ),
                    // Logo End

                    const SizedBox(height: 18),

                    // Header Start
                    const Text(
                      AppStrings.createAccount,
                      style: TextStyle(
                        fontSize: 30,
                        fontWeight: FontWeight.bold,
                      ),
                    ),

                    const SizedBox(height: 8),

                    const Text(
                      AppStrings.signUpSubtitle,
                      style: TextStyle(
                        color: Colors.grey,
                        fontSize: 15,
                      ),
                    ),
                    // Header End

                    const SizedBox(height: 30),

                    // Name Start
                    TextFormField(
                      controller: nameController,
                      textInputAction: TextInputAction.next,
                      validator: (value) {
                        if (value == null ||
                            value.trim().isEmpty) {
                          return 'Please enter your full name';
                        }

                        return null;
                      },
                      decoration: const InputDecoration(
                        labelText: 'Full Name',
                        prefixIcon:
                            Icon(Icons.person_outline),
                        border: OutlineInputBorder(),
                      ),
                    ),
                    // Name End

                    const SizedBox(height: 16),

                    // Email Start
                    TextFormField(
                      controller: emailController,
                      keyboardType:
                          TextInputType.emailAddress,
                      textInputAction: TextInputAction.next,
                      validator: validateEmail,
                      decoration: const InputDecoration(
                        labelText: 'Email',
                        prefixIcon:
                            Icon(Icons.email_outlined),
                        border: OutlineInputBorder(),
                      ),
                    ),
                    // Email End

                    const SizedBox(height: 16),

                    // Password Start
                    TextFormField(
                      controller: passwordController,
                      obscureText:
                          authViewModel.hidePassword,
                      textInputAction: TextInputAction.next,
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return 'Please enter a password';
                        }

                        if (value.length < 6) {
                          return 'Password must be at least 6 characters';
                        }

                        return null;
                      },
                      decoration: InputDecoration(
                        labelText: 'Password',
                        prefixIcon:
                            const Icon(Icons.lock_outline),
                        border: const OutlineInputBorder(),
                        suffixIcon: IconButton(
                          onPressed:
                              authViewModel.togglePassword,
                          icon: Icon(
                            authViewModel.hidePassword
                                ? Icons
                                    .visibility_off_outlined
                                : Icons.visibility_outlined,
                          ),
                        ),
                      ),
                    ),
                    // Password End

                    const SizedBox(height: 16),

                    // Confirm Password Start
                    TextFormField(
                      controller: confirmPasswordController,
                      obscureText:
                          authViewModel.hideConfirmPassword,
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return 'Please confirm your password';
                        }

                        if (value !=
                            passwordController.text) {
                          return 'Passwords do not match';
                        }

                        return null;
                      },
                      decoration: InputDecoration(
                        labelText: 'Confirm Password',
                        prefixIcon:
                            const Icon(Icons.lock_outline),
                        border: const OutlineInputBorder(),
                        suffixIcon: IconButton(
                          onPressed: authViewModel
                              .toggleConfirmPassword,
                          icon: Icon(
                            authViewModel
                                    .hideConfirmPassword
                                ? Icons
                                    .visibility_off_outlined
                                : Icons.visibility_outlined,
                          ),
                        ),
                      ),
                    ),
                    // Confirm Password End

                    const SizedBox(height: 25),

                    // Sign Up Button Start
                    SizedBox(
                      width: double.infinity,
                      height: 52,
                      child: FilledButton(
                        onPressed: authViewModel.isLoading
                            ? null
                            : () {
                                if (formKey.currentState!
                                    .validate()) {
                                  ScaffoldMessenger.of(context)
                                      .showSnackBar(
                                    const SnackBar(
                                      content: Text(
                                        'Sign up form is valid',
                                      ),
                                    ),
                                  );
                                }
                              },
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
                                AppStrings.signUp,
                                style: TextStyle(
                                  fontSize: 16,
                                ),
                              ),
                      ),
                    ),
                    // Sign Up Button End

                    const SizedBox(height: 20),

                    // Login Navigation Start
                    Row(
                      mainAxisAlignment:
                          MainAxisAlignment.center,
                      children: [
                        const Text(
                          AppStrings.alreadyHaveAccount,
                        ),
                        TextButton(
                          onPressed: () {
                            Navigator.pop(context);
                          },
                          child: const Text(
                            AppStrings.login,
                          ),
                        ),
                      ],
                    ),
                    // Login Navigation End
                  ],
                ),
              ),
              // Sign Up Form End
            ),
          ),
        ),
      ),
      // Body End
    );
  }
}