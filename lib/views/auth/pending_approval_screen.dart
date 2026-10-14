import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../routes/app_routes.dart';
import '../../utils/app_colors.dart';
import '../../viewmodels/auth_viewmodel.dart';

class PendingApprovalScreen extends StatelessWidget {
  const PendingApprovalScreen({super.key});

  // Logout Start
  Future<void> logout(
    BuildContext context,
  ) async {
    await context
        .read<AuthViewModel>()
        .logout();

    if (!context.mounted) {
      return;
    }

    Navigator.pushNamedAndRemoveUntil(
      context,
      AppRoutes.login,
      (route) => false,
    );
  }
  // Logout End

  @override
  Widget build(BuildContext context) {
    final authViewModel =
        context.watch<AuthViewModel>();

    return Scaffold(
      // Body Start
      body: SafeArea(
        child: Center(
          child: SingleChildScrollView(
            padding:
                const EdgeInsets.all(24),
            child: ConstrainedBox(
              constraints:
                  const BoxConstraints(
                maxWidth: 450,
              ),
              child: Column(
                children: [
                  // Icon Start
                  Container(
                    width: 100,
                    height: 100,
                    decoration:
                        BoxDecoration(
                      color: AppColors
                          .primary
                          .withValues(
                        alpha: 0.10,
                      ),
                      shape:
                          BoxShape.circle,
                    ),
                    child: const Icon(
                      Icons
                          .hourglass_top_rounded,
                      size: 50,
                      color:
                          AppColors.primary,
                    ),
                  ),
                  // Icon End

                  const SizedBox(
                    height: 30,
                  ),

                  // Title Start
                  const Text(
                    'Account Pending Approval',
                    textAlign:
                        TextAlign.center,
                    style: TextStyle(
                      fontSize: 25,
                      fontWeight:
                          FontWeight.bold,
                      color:
                          AppColors.darkBlue,
                    ),
                  ),
                  // Title End

                  const SizedBox(
                    height: 12,
                  ),

                  // Message Start
                  const Text(
                    'Your registration has been submitted successfully. Please wait for the owner to approve your account.',
                    textAlign:
                        TextAlign.center,
                    style: TextStyle(
                      fontSize: 15,
                      height: 1.5,
                      color:
                          AppColors.grey,
                    ),
                  ),
                  // Message End

                  const SizedBox(
                    height: 30,
                  ),

                  // User Info Start
                  Container(
                    width: double.infinity,
                    padding:
                        const EdgeInsets
                            .all(18),
                    decoration:
                        BoxDecoration(
                      color: AppColors
                          .lightGrey,
                      borderRadius:
                          BorderRadius
                              .circular(16),
                    ),
                    child: Column(
                      children: [
                        const Icon(
                          Icons
                              .person_outline_rounded,
                          color: AppColors
                              .primary,
                        ),

                        const SizedBox(
                          height: 8,
                        ),

                        Text(
                          authViewModel
                                  .userProfile
                                  ?.name ??
                              'Member',
                          style:
                              const TextStyle(
                            fontSize: 17,
                            fontWeight:
                                FontWeight
                                    .bold,
                          ),
                        ),

                        const SizedBox(
                          height: 4,
                        ),

                        Text(
                          authViewModel
                                  .userProfile
                                  ?.email ??
                              '',
                          textAlign:
                              TextAlign
                                  .center,
                          style:
                              const TextStyle(
                            color:
                                AppColors.grey,
                          ),
                        ),

                        const SizedBox(
                          height: 10,
                        ),

                        Container(
                          padding:
                              const EdgeInsets
                                  .symmetric(
                            horizontal: 12,
                            vertical: 6,
                          ),
                          decoration:
                              BoxDecoration(
                            color: Colors
                                .orange
                                .withValues(
                              alpha: 0.12,
                            ),
                            borderRadius:
                                BorderRadius
                                    .circular(
                              20,
                            ),
                          ),
                          child:
                              const Text(
                            'PENDING',
                            style:
                                TextStyle(
                              color: Colors
                                  .orange,
                              fontWeight:
                                  FontWeight
                                      .bold,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                  // User Info End

                  const SizedBox(
                    height: 30,
                  ),

                  // Logout Button Start
                  SizedBox(
                    width:
                        double.infinity,
                    height: 52,
                    child:
                        OutlinedButton.icon(
                      onPressed: () {
                        logout(context);
                      },
                      icon: const Icon(
                        Icons
                            .logout_rounded,
                      ),
                      label:
                          const Text(
                        'Logout',
                      ),
                    ),
                  ),
                  // Logout Button End
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