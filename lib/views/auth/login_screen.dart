import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../routes/app_routes.dart';
import '../../utils/app_colors.dart';
import '../../utils/app_strings.dart';
import '../../viewmodels/auth_viewmodel.dart';

class LoginScreen
    extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() =>
      _LoginScreenState();
}

class _LoginScreenState
    extends State<LoginScreen> {
  final formKey =
      GlobalKey<FormState>();

  final emailController =
      TextEditingController();

  final passwordController =
      TextEditingController();

  // Dispose Start
  @override
  void dispose() {
    emailController.dispose();
    passwordController.dispose();

    super.dispose();
  }
  // Dispose End

  // Login Start
  Future<void> login() async {
    if (!formKey.currentState!
        .validate()) {
      return;
    }

    final authViewModel =
        context.read<AuthViewModel>();

    final success =
        await authViewModel.login(
      email:
          emailController.text,
      password:
          passwordController.text,
    );

    if (!mounted) {
      return;
    }

    if (!success) {
      ScaffoldMessenger.of(context)
          .showSnackBar(
        SnackBar(
          content: Text(
            authViewModel
                    .errorMessage ??
                'Unable to login.',
          ),
          backgroundColor:
              AppColors.error,
        ),
      );

      return;
    }

    final user =
        authViewModel.userProfile;

    if (user == null) {
      ScaffoldMessenger.of(context)
          .showSnackBar(
        const SnackBar(
          content: Text(
            'User profile not found.',
          ),
        ),
      );

      return;
    }

    // Owner Navigation Start
    if (user.role == 'owner' &&
        user.accountStatus ==
            'approved') {
      Navigator
          .pushNamedAndRemoveUntil(
        context,
        AppRoutes.dashboard,
        (route) => false,
      );

      return;
    }
    // Owner Navigation End

    // Pending Navigation Start
    if (user.accountStatus ==
        'pending') {
      Navigator
          .pushNamedAndRemoveUntil(
        context,
        AppRoutes
            .pendingApproval,
        (route) => false,
      );

      return;
    }
    // Pending Navigation End

    // Approved Member Start
    if (user.role == 'member' &&
        user.accountStatus ==
            'approved') {
      Navigator
          .pushNamedAndRemoveUntil(
        context,
        AppRoutes.memberHome,
        (route) => false,
      );

      return;
    }
    // Approved Member End

    // Rejected Account Start
    if (user.accountStatus ==
        'rejected') {
      await authViewModel.logout();

      if (!mounted) {
        return;
      }

      ScaffoldMessenger.of(context)
          .showSnackBar(
        const SnackBar(
          content: Text(
            'Your account request was rejected.',
          ),
          backgroundColor:
              AppColors.error,
        ),
      );

      return;
    }
    // Rejected Account End

    await authViewModel.logout();

    if (!mounted) {
      return;
    }

    ScaffoldMessenger.of(context)
        .showSnackBar(
      const SnackBar(
        content: Text(
          'Account access is not available.',
        ),
      ),
    );
  }
  // Login End

  @override
  Widget build(BuildContext context) {
    final authViewModel =
        context.watch<AuthViewModel>();

    return Scaffold(
      // Body Start
      body: SafeArea(
        child: Center(
          child:
              SingleChildScrollView(
            padding:
                const EdgeInsets.all(
              24,
            ),
            child: ConstrainedBox(
              constraints:
                  const BoxConstraints(
                maxWidth: 430,
              ),
              child: Form(
                key: formKey,
                child: Column(
                  crossAxisAlignment:
                      CrossAxisAlignment
                          .stretch,
                  children: [
                    // Logo Start
                    Center(
                      child: Container(
                        width: 85,
                        height: 85,
                        padding:
                            const EdgeInsets
                                .all(12),
                        decoration:
                            BoxDecoration(
                          color: AppColors
                              .primary
                              .withValues(
                            alpha: 0.10,
                          ),
                          borderRadius:
                              BorderRadius
                                  .circular(
                            22,
                          ),
                        ),
                        child:
                            Image.asset(
                          'assets/icons/projexa_icon.png',
                        ),
                      ),
                    ),
                    // Logo End

                    const SizedBox(
                      height: 25,
                    ),

                    // Heading Start
                    const Text(
                      AppStrings
                          .welcomeBack,
                      textAlign:
                          TextAlign.center,
                      style: TextStyle(
                        fontSize: 28,
                        fontWeight:
                            FontWeight.bold,
                        color: AppColors
                            .darkBlue,
                      ),
                    ),

                    const SizedBox(
                      height: 8,
                    ),

                    const Text(
                      AppStrings
                          .loginSubtitle,
                      textAlign:
                          TextAlign.center,
                      style: TextStyle(
                        color:
                            AppColors.grey,
                      ),
                    ),
                    // Heading End

                    const SizedBox(
                      height: 35,
                    ),

                    // Email Start
                    TextFormField(
                      controller:
                          emailController,
                      keyboardType:
                          TextInputType
                              .emailAddress,
                      decoration:
                          const InputDecoration(
                        labelText:
                            'Email',
                        prefixIcon: Icon(
                          Icons
                              .email_outlined,
                        ),
                        border:
                            OutlineInputBorder(),
                      ),
                      validator: (value) {
                        final email =
                            value
                                ?.trim() ??
                                '';

                        if (email
                            .isEmpty) {
                          return 'Please enter your email.';
                        }

                        if (!email
                                .contains(
                                    '@') ||
                            !email
                                .contains(
                                    '.')) {
                          return 'Please enter a valid email.';
                        }

                        return null;
                      },
                    ),
                    // Email End

                    const SizedBox(
                      height: 16,
                    ),

                    // Password Start
                    TextFormField(
                      controller:
                          passwordController,
                      obscureText:
                          authViewModel
                              .hidePassword,
                      decoration:
                          InputDecoration(
                        labelText:
                            'Password',
                        prefixIcon:
                            const Icon(
                          Icons
                              .lock_outline_rounded,
                        ),
                        suffixIcon:
                            IconButton(
                          onPressed:
                              authViewModel
                                  .togglePassword,
                          icon: Icon(
                            authViewModel
                                    .hidePassword
                                ? Icons
                                    .visibility_off_outlined
                                : Icons
                                    .visibility_outlined,
                          ),
                        ),
                        border:
                            const OutlineInputBorder(),
                      ),
                      validator: (value) {
                        if (value ==
                                null ||
                            value.isEmpty) {
                          return 'Please enter your password.';
                        }

                        if (value.length <
                            6) {
                          return 'Password must be at least 6 characters.';
                        }

                        return null;
                      },
                    ),
                    // Password End

                    const SizedBox(
                      height: 8,
                    ),

                    // Forgot Password Start
                    Align(
                      alignment:
                          Alignment
                              .centerRight,
                      child:
                          TextButton(
                        onPressed: () {
                          Navigator
                              .pushNamed(
                            context,
                            AppRoutes
                                .forgotPassword,
                          );
                        },
                        child:
                            const Text(
                          AppStrings
                              .forgotPassword,
                        ),
                      ),
                    ),
                    // Forgot Password End

                    const SizedBox(
                      height: 10,
                    ),

                    // Login Button Start
                    SizedBox(
                      height: 52,
                      child:
                          ElevatedButton(
                        onPressed:
                            authViewModel
                                    .isLoading
                                ? null
                                : login,
                        child: authViewModel
                                .isLoading
                            ? const SizedBox(
                                width: 22,
                                height: 22,
                                child:
                                    CircularProgressIndicator(
                                  strokeWidth:
                                      2,
                                ),
                              )
                            : const Text(
                                AppStrings
                                    .login,
                              ),
                      ),
                    ),
                    // Login Button End

                    const SizedBox(
                      height: 22,
                    ),

                    // Sign Up Start
                    Row(
                      mainAxisAlignment:
                          MainAxisAlignment
                              .center,
                      children: [
                        const Text(
                          AppStrings
                              .noAccount,
                        ),

                        TextButton(
                          onPressed: () {
                            Navigator
                                .pushNamed(
                              context,
                              AppRoutes
                                  .signUp,
                            );
                          },
                          child:
                              const Text(
                            AppStrings
                                .signUp,
                          ),
                        ),
                      ],
                    ),
                    // Sign Up End
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
      // Body End
    );
  }
}