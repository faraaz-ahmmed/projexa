import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../utils/app_colors.dart';
import '../../viewmodels/dashboard_viewmodel.dart';

class DashboardScreen extends StatefulWidget {
  const DashboardScreen({super.key});

  @override
  State<DashboardScreen> createState() =>
      _DashboardScreenState();
}

class _DashboardScreenState
    extends State<DashboardScreen> {

  // Dashboard Load Start
  @override
  void initState() {
    super.initState();

    WidgetsBinding.instance.addPostFrameCallback((_) {
      context
          .read<DashboardViewModel>()
          .loadDashboard();
    });
  }
  // Dashboard Load End

  @override
  Widget build(BuildContext context) {
    final dashboardViewModel =
        context.watch<DashboardViewModel>();

    return Scaffold(
      // AppBar Start
      appBar: AppBar(
        title: const Text(
          'Projexa',
          style: TextStyle(
            fontWeight: FontWeight.bold,
          ),
        ),
        actions: [
          IconButton(
            onPressed: () {},
            icon: const Icon(
              Icons.notifications_none_rounded,
            ),
          ),
          const SizedBox(width: 8),
        ],
      ),
      // AppBar End

      // Body Start
      body: SafeArea(
        child: dashboardViewModel.isLoading
            ? const Center(
                child: CircularProgressIndicator(),
              )
            : SingleChildScrollView(
                padding: const EdgeInsets.all(20),
                child: Column(
                  crossAxisAlignment:
                      CrossAxisAlignment.start,
                  children: [
                    // Welcome Start
                    const Text(
                      'Good Morning 👋',
                      style: TextStyle(
                        fontSize: 14,
                        color: AppColors.grey,
                      ),
                    ),

                    const SizedBox(height: 5),

                    Text(
                      dashboardViewModel.userName,
                      style: const TextStyle(
                        fontSize: 26,
                        fontWeight: FontWeight.bold,
                        color: AppColors.black,
                      ),
                    ),
                    // Welcome End

                    const SizedBox(height: 25),

                    // Project Summary Start
                    GridView.count(
                      crossAxisCount: 2,
                      crossAxisSpacing: 12,
                      mainAxisSpacing: 12,
                      shrinkWrap: true,
                      physics:
                          const NeverScrollableScrollPhysics(),
                      childAspectRatio: 1.6,
                      children: [
                        _SummaryCard(
                          title: 'Total Projects',
                          value: dashboardViewModel
                              .totalProjects
                              .toString(),
                          icon: Icons.folder_outlined,
                        ),
                        _SummaryCard(
                          title: 'Completed',
                          value: dashboardViewModel
                              .completedProjects
                              .toString(),
                          icon:
                              Icons.check_circle_outline,
                        ),
                        _SummaryCard(
                          title: 'In Progress',
                          value: dashboardViewModel
                              .inProgressProjects
                              .toString(),
                          icon: Icons.timelapse_rounded,
                        ),
                        _SummaryCard(
                          title: 'Remaining',
                          value: dashboardViewModel
                              .remainingProjects
                              .toString(),
                          icon:
                              Icons.pending_actions_outlined,
                        ),
                      ],
                    ),
                    // Project Summary End

                    const SizedBox(height: 30),

                    // Progress Header Start
                    const Text(
                      'Project Progress Overview',
                      style: TextStyle(
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    // Progress Header End

                    const SizedBox(height: 15),

                    // Progress Card Start
                    Container(
                      width: double.infinity,
                      padding: const EdgeInsets.all(20),
                      decoration: BoxDecoration(
                        color: AppColors.lightGrey,
                        borderRadius:
                            BorderRadius.circular(18),
                      ),
                      child: Column(
                        crossAxisAlignment:
                            CrossAxisAlignment.start,
                        children: [
                          const Text(
                            'Overall Progress',
                            style: TextStyle(
                              fontSize: 15,
                              color: AppColors.grey,
                            ),
                          ),
                          const SizedBox(height: 10),
                          Text(
                            '${dashboardViewModel.overallProgressPercentage}%',
                            style: const TextStyle(
                              fontSize: 28,
                              fontWeight:
                                  FontWeight.bold,
                            ),
                          ),
                          const SizedBox(height: 15),
                          LinearProgressIndicator(
                            value: dashboardViewModel
                                .overallProgress,
                            minHeight: 8,
                            borderRadius:
                                BorderRadius.circular(10),
                          ),
                        ],
                      ),
                    ),
                    // Progress Card End

                    const SizedBox(height: 30),

                    // My Projects Header Start
                    Row(
                      mainAxisAlignment:
                          MainAxisAlignment
                              .spaceBetween,
                      children: [
                        const Text(
                          'My Projects',
                          style: TextStyle(
                            fontSize: 20,
                            fontWeight:
                                FontWeight.bold,
                          ),
                        ),
                        TextButton(
                          onPressed: () {},
                          child:
                              const Text('View All'),
                        ),
                      ],
                    ),
                    // My Projects Header End

                    const SizedBox(height: 10),

                    // Empty Projects Start
                    Container(
                      width: double.infinity,
                      padding:
                          const EdgeInsets.symmetric(
                        vertical: 35,
                        horizontal: 20,
                      ),
                      decoration: BoxDecoration(
                        color: AppColors.white,
                        border: Border.all(
                          color: AppColors.lightGrey,
                        ),
                        borderRadius:
                            BorderRadius.circular(18),
                      ),
                      child: const Column(
                        children: [
                          Icon(
                            Icons.folder_open_outlined,
                            size: 45,
                            color: AppColors.grey,
                          ),
                          SizedBox(height: 10),
                          Text(
                            'No projects yet',
                            style: TextStyle(
                              fontSize: 16,
                              fontWeight:
                                  FontWeight.w600,
                            ),
                          ),
                          SizedBox(height: 5),
                          Text(
                            'Your projects will appear here.',
                            textAlign:
                                TextAlign.center,
                            style: TextStyle(
                              color: AppColors.grey,
                            ),
                          ),
                        ],
                      ),
                    ),
                    // Empty Projects End

                    const SizedBox(height: 30),

                    // Upcoming Tasks Header Start
                    const Text(
                      'Upcoming Tasks',
                      style: TextStyle(
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    // Upcoming Tasks Header End

                    const SizedBox(height: 15),

                    // Upcoming Tasks Start
                    Container(
                      width: double.infinity,
                      padding:
                          const EdgeInsets.all(25),
                      decoration: BoxDecoration(
                        color: AppColors.lightGrey,
                        borderRadius:
                            BorderRadius.circular(18),
                      ),
                      child: const Column(
                        children: [
                          Icon(
                            Icons.task_alt_rounded,
                            size: 40,
                            color: AppColors.grey,
                          ),
                          SizedBox(height: 10),
                          Text(
                            'No upcoming tasks',
                            style: TextStyle(
                              fontWeight:
                                  FontWeight.w600,
                            ),
                          ),
                          SizedBox(height: 5),
                          Text(
                            'Your upcoming tasks will appear here.',
                            textAlign:
                                TextAlign.center,
                            style: TextStyle(
                              color: AppColors.grey,
                            ),
                          ),
                        ],
                      ),
                    ),
                    // Upcoming Tasks End

                    const SizedBox(height: 30),
                  ],
                ),
              ),
      ),
      // Body End
    );
  }
}

// Summary Card Start
class _SummaryCard extends StatelessWidget {
  final String title;
  final String value;
  final IconData icon;

  const _SummaryCard({
    required this.title,
    required this.value,
    required this.icon,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: AppColors.lightGrey,
        borderRadius: BorderRadius.circular(18),
      ),
      child: Row(
        children: [
          // Icon Start
          Container(
            width: 45,
            height: 45,
            decoration: BoxDecoration(
              color: AppColors.primary.withValues(
                alpha: 0.10,
              ),
              borderRadius: BorderRadius.circular(12),
            ),
            child: Icon(
              icon,
              color: AppColors.primary,
            ),
          ),
          // Icon End

          const SizedBox(width: 12),

          // Information Start
          Expanded(
            child: Column(
              mainAxisAlignment:
                  MainAxisAlignment.center,
              crossAxisAlignment:
                  CrossAxisAlignment.start,
              children: [
                Text(
                  value,
                  style: const TextStyle(
                    fontSize: 22,
                    fontWeight: FontWeight.bold,
                    color: AppColors.black,
                  ),
                ),
                const SizedBox(height: 2),
                Text(
                  title,
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: const TextStyle(
                    fontSize: 12,
                    color: AppColors.grey,
                  ),
                ),
              ],
            ),
          ),
          // Information End
        ],
      ),
    );
  }
}
// Summary Card End