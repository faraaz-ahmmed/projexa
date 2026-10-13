import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../routes/app_routes.dart';
import '../../utils/app_strings.dart';
import '../../viewmodels/auth_viewmodel.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final formKey = GlobalKey<FormState>();

  final emailController = TextEditingController();
  final passwordController = TextEditingController();

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
    emailController.dispose();
    passwordController.dispose();
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

              // Login Form Start
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

                    const SizedBox(height: 20),

                    // Header Start
                    const Text(
                      AppStrings.welcomeBack,
                      style: TextStyle(
                        fontSize: 30,
                        fontWeight: FontWeight.bold,
                      ),
                    ),

                    const SizedBox(height: 8),

                    const Text(
                      AppStrings.loginSubtitle,
                      style: TextStyle(
                        color: Colors.grey,
                        fontSize: 15,
                      ),
                    ),
                    // Header End

                    const SizedBox(height: 35),

                    // Email Start
                    TextFormField(
                      controller: emailController,
                      keyboardType: TextInputType.emailAddress,
                      textInputAction: TextInputAction.next,
                      validator: validateEmail,
                      decoration: const InputDecoration(
                        labelText: 'Email',
                        prefixIcon: Icon(
                          Icons.email_outlined,
                        ),
                        border: OutlineInputBorder(),
                      ),
                    ),
                    // Email End

                    const SizedBox(height: 18),

                    // Password Start
                    TextFormField(
                      controller: passwordController,
                      obscureText: authViewModel.hidePassword,
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return 'Please enter your password';
                        }

                        return null;
                      },
                      decoration: InputDecoration(
                        labelText: 'Password',
                        prefixIcon: const Icon(
                          Icons.lock_outline,
                        ),
                        border: const OutlineInputBorder(),
                        suffixIcon: IconButton(
                          onPressed:
                              authViewModel.togglePassword,
                          icon: Icon(
                            authViewModel.hidePassword
                                ? Icons.visibility_off_outlined
                                : Icons.visibility_outlined,
                          ),
                        ),
                      ),
                    ),
                    // Password End

                    const SizedBox(height: 8),

                    // Forgot Password Start
                    Align(
                      alignment: Alignment.centerRight,
                      child: TextButton(
                        onPressed: () {
                          Navigator.pushNamed(
                            context,
                            AppRoutes.forgotPassword,
                          );
                        },
                        child: const Text(
                          AppStrings.forgotPassword,
                        ),
                      ),
                    ),
                    // Forgot Password End

                    const SizedBox(height: 8),

                    // Login Button Start
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
                                        'Login form is valid',
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
                                AppStrings.login,
                                style: TextStyle(
                                  fontSize: 16,
                                ),
                              ),
                      ),
                    ),
                    // Login Button End

                    const SizedBox(height: 25),

                    // Sign Up Navigation Start
                    Row(
                      mainAxisAlignment:
                          MainAxisAlignment.center,
                      children: [
                        const Text(
                          AppStrings.noAccount,
                        ),
                        TextButton(
                          onPressed: () {
                            Navigator.pushNamed(
                              context,
                              AppRoutes.signUp,
                            );
                          },
                          child: const Text(
                            AppStrings.signUp,
                          ),
                        ),
                      ],
                    ),
                    // Sign Up Navigation End
                  ],
                ),
              ),
              // Login Form End
            ),
          ),
        ),
      ),
      // Body End
    );
  }
}