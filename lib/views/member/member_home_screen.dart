import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../routes/app_routes.dart';
import '../../utils/app_colors.dart';
import '../../viewmodels/auth_viewmodel.dart';

class MemberHomeScreen
    extends StatelessWidget {
  const MemberHomeScreen({super.key});

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

    final user =
        authViewModel.userProfile;

    return Scaffold(
      // AppBar Start
      appBar: AppBar(
        automaticallyImplyLeading:
            false,
        title: const Text(
          'Projexa',
          style: TextStyle(
            fontWeight:
                FontWeight.bold,
          ),
        ),
        actions: [
          IconButton(
            tooltip: 'Logout',
            onPressed: () {
              logout(context);
            },
            icon: const Icon(
              Icons.logout_rounded,
            ),
          ),
        ],
      ),
      // AppBar End

      // Body Start
      body: SafeArea(
        child: SingleChildScrollView(
          padding:
              const EdgeInsets.all(20),
          child: Center(
            child: ConstrainedBox(
              constraints:
                  const BoxConstraints(
                maxWidth: 800,
              ),
              child: Column(
                crossAxisAlignment:
                    CrossAxisAlignment
                        .start,
                children: [
                  // Welcome Start
                  Text(
                    'Welcome, ${user?.name ?? 'Member'}',
                    style:
                        const TextStyle(
                      fontSize: 26,
                      fontWeight:
                          FontWeight.bold,
                      color:
                          AppColors.darkBlue,
                    ),
                  ),

                  const SizedBox(
                    height: 6,
                  ),

                  const Text(
                    'Here you can manage your assigned work.',
                    style: TextStyle(
                      color:
                          AppColors.grey,
                    ),
                  ),
                  // Welcome End

                  const SizedBox(
                    height: 25,
                  ),

                  // Role Card Start
                  Container(
                    width:
                        double.infinity,
                    padding:
                        const EdgeInsets
                            .all(20),
                    decoration:
                        BoxDecoration(
                      color: AppColors
                          .primary
                          .withValues(
                        alpha: 0.08,
                      ),
                      borderRadius:
                          BorderRadius
                              .circular(18),
                    ),
                    child: Row(
                      children: [
                        Container(
                          width: 55,
                          height: 55,
                          decoration:
                              BoxDecoration(
                            color:
                                AppColors
                                    .primary,
                            borderRadius:
                                BorderRadius
                                    .circular(
                              15,
                            ),
                          ),
                          child:
                              const Icon(
                            Icons
                                .person_rounded,
                            color:
                                AppColors
                                    .white,
                          ),
                        ),

                        const SizedBox(
                          width: 15,
                        ),

                        Expanded(
                          child: Column(
                            crossAxisAlignment:
                                CrossAxisAlignment
                                    .start,
                            children: [
                              Text(
                                user?.name ??
                                    'Member',
                                style:
                                    const TextStyle(
                                  fontSize:
                                      18,
                                  fontWeight:
                                      FontWeight
                                          .bold,
                                ),
                              ),

                              const SizedBox(
                                height: 4,
                              ),

                              Text(
                                user?.email ??
                                    '',
                                style:
                                    const TextStyle(
                                  color:
                                      AppColors
                                          .grey,
                                ),
                              ),
                            ],
                          ),
                        ),

                        Container(
                          padding:
                              const EdgeInsets
                                  .symmetric(
                            horizontal:
                                12,
                            vertical: 6,
                          ),
                          decoration:
                              BoxDecoration(
                            color:
                                AppColors
                                    .primary,
                            borderRadius:
                                BorderRadius
                                    .circular(
                              20,
                            ),
                          ),
                          child:
                              const Text(
                            'MEMBER',
                            style:
                                TextStyle(
                              color:
                                  AppColors
                                      .white,
                              fontSize: 12,
                              fontWeight:
                                  FontWeight
                                      .bold,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                  // Role Card End

                  const SizedBox(
                    height: 30,
                  ),

                  // Section Start
                  const Text(
                    'My Workspace',
                    style: TextStyle(
                      fontSize: 20,
                      fontWeight:
                          FontWeight.bold,
                    ),
                  ),

                  const SizedBox(
                    height: 15,
                  ),

                  const Row(
                    children: [
                      Expanded(
                        child:
                            _MemberCard(
                          icon: Icons
                              .folder_outlined,
                          title:
                              'Assigned Projects',
                          value: '0',
                        ),
                      ),

                      SizedBox(
                        width: 12,
                      ),

                      Expanded(
                        child:
                            _MemberCard(
                          icon: Icons
                              .task_alt_rounded,
                          title:
                              'My Tasks',
                          value: '0',
                        ),
                      ),
                    ],
                  ),

                  const SizedBox(
                    height: 12,
                  ),

                  const Row(
                    children: [
                      Expanded(
                        child:
                            _MemberCard(
                          icon: Icons
                              .schedule_rounded,
                          title:
                              'Deadlines',
                          value: '0',
                        ),
                      ),

                      SizedBox(
                        width: 12,
                      ),

                      Expanded(
                        child:
                            _MemberCard(
                          icon: Icons
                              .chat_bubble_outline_rounded,
                          title:
                              'Messages',
                          value: '0',
                        ),
                      ),
                    ],
                  ),
                  // Section End

                  const SizedBox(
                    height: 30,
                  ),

                  // Information Start
                  Container(
                    width:
                        double.infinity,
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
                    child: const Row(
                      crossAxisAlignment:
                          CrossAxisAlignment
                              .start,
                      children: [
                        Icon(
                          Icons
                              .info_outline_rounded,
                          color:
                              AppColors
                                  .primary,
                        ),

                        SizedBox(
                          width: 12,
                        ),

                        Expanded(
                          child: Text(
                            'Projects and tasks assigned to you by the owner will appear here.',
                            style:
                                TextStyle(
                              color:
                                  AppColors
                                      .grey,
                              height: 1.4,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                  // Information End
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

// Member Card Start
class _MemberCard
    extends StatelessWidget {
  final IconData icon;
  final String title;
  final String value;

  const _MemberCard({
    required this.icon,
    required this.title,
    required this.value,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding:
          const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: AppColors.white,
        borderRadius:
            BorderRadius.circular(16),
        border: Border.all(
          color: AppColors.lightGrey,
        ),
      ),
      child: Column(
        crossAxisAlignment:
            CrossAxisAlignment.start,
        children: [
          Icon(
            icon,
            color: AppColors.primary,
          ),

          const SizedBox(
            height: 14,
          ),

          Text(
            value,
            style: const TextStyle(
              fontSize: 24,
              fontWeight:
                  FontWeight.bold,
            ),
          ),

          const SizedBox(
            height: 4,
          ),

          Text(
            title,
            style: const TextStyle(
              fontSize: 12,
              color: AppColors.grey,
            ),
          ),
        ],
      ),
    );
  }
}
// Member Card End