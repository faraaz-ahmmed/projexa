import 'package:flutter/material.dart';

class ForgotPasswordScreen extends StatefulWidget {
  const ForgotPasswordScreen({super.key});

  @override
  State<ForgotPasswordScreen> createState() =>
      _ForgotPasswordScreenState();
}

class _ForgotPasswordScreenState
    extends State<ForgotPasswordScreen> {
  final emailController = TextEditingController();

  @override
  void dispose() {
    emailController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
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
              constraints: const BoxConstraints(maxWidth: 420),
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
                    'Enter your email address and we will send you a password reset link.',
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
                  TextField(
                    controller: emailController,
                    keyboardType: TextInputType.emailAddress,
                    decoration: const InputDecoration(
                      labelText: 'Email Address',
                      prefixIcon: Icon(Icons.email_outlined),
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
                      onPressed: () {
                        final email =
                            emailController.text.trim();

                        if (email.isEmpty) {
                          ScaffoldMessenger.of(context)
                              .showSnackBar(
                            const SnackBar(
                              content: Text(
                                'Please enter your email address',
                              ),
                            ),
                          );
                          return;
                        }

                        ScaffoldMessenger.of(context)
                            .showSnackBar(
                          const SnackBar(
                            content: Text(
                              'Firebase password reset will be connected soon.',
                            ),
                          ),
                        );
                      },
                      child: const Text(
                        'Send Reset Link',
                        style: TextStyle(fontSize: 16),
                      ),
                    ),
                  ),
                  // Reset Button End

                  const SizedBox(height: 20),

                  // Back To Login Start
                  TextButton.icon(
                    onPressed: () {
                      Navigator.pop(context);
                    },
                    icon: const Icon(Icons.arrow_back),
                    label: const Text('Back to Login'),
                  ),
                  // Back To Login End
                ],
              ),
            ),
          ),
        ),
      ),
      // Body End
    );
  }
}