import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../models/project_model.dart';
import '../../utils/app_colors.dart';
import '../../viewmodels/project_viewmodel.dart';
import 'create_project_screen.dart';
import 'project_details_screen.dart';

class MyProjectsScreen extends StatefulWidget {
  const MyProjectsScreen({super.key});

  @override
  State<MyProjectsScreen> createState() =>
      _MyProjectsScreenState();
}

class _MyProjectsScreenState
    extends State<MyProjectsScreen> {
  // Load Projects Start
  @override
  void initState() {
    super.initState();

    WidgetsBinding.instance.addPostFrameCallback((_) {
      context.read<ProjectViewModel>().loadProjects();
    });
  }
  // Load Projects End

  // Open Create Project Start
  Future<void> openCreateProject() async {
    await Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) =>
            const CreateProjectScreen(),
      ),
    );
  }
  // Open Create Project End

  // Open Project Details Start
  void openProjectDetails(
    ProjectModel project,
  ) {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) =>
            ProjectDetailsScreen(
          project: project,
        ),
      ),
    );
  }
  // Open Project Details End

  @override
  Widget build(BuildContext context) {
    final projectViewModel =
        context.watch<ProjectViewModel>();

    return Scaffold(
      // AppBar Start
      appBar: AppBar(
        title: const Text(
          'My Projects',
          style: TextStyle(
            fontWeight: FontWeight.bold,
          ),
        ),
      ),
      // AppBar End

      // Body Start
      body: SafeArea(
        child: projectViewModel.isLoading
            ? const Center(
                child: CircularProgressIndicator(),
              )
            : Center(
                child: ConstrainedBox(
                  constraints: const BoxConstraints(
                    maxWidth: 900,
                  ),
                  child: SingleChildScrollView(
                    padding: const EdgeInsets.all(20),
                    child: Column(
                      crossAxisAlignment:
                          CrossAxisAlignment.start,
                      children: [
                        // Header Start
                        const Text(
                          'Projects',
                          style: TextStyle(
                            fontSize: 26,
                            fontWeight:
                                FontWeight.bold,
                            color: AppColors.black,
                          ),
                        ),

                        const SizedBox(height: 6),

                        const Text(
                          'Manage and track all your projects.',
                          style: TextStyle(
                            fontSize: 14,
                            color: AppColors.grey,
                          ),
                        ),
                        // Header End

                        const SizedBox(height: 25),

                        // Summary Start
                        Row(
                          children: [
                            Expanded(
                              child: _ProjectInfoCard(
                                title: 'Total',
                                value: projectViewModel
                                    .totalProjects
                                    .toString(),
                                icon:
                                    Icons.folder_outlined,
                              ),
                            ),
                            const SizedBox(width: 10),
                            Expanded(
                              child: _ProjectInfoCard(
                                title: 'Active',
                                value: projectViewModel
                                    .inProgressProjects
                                    .toString(),
                                icon: Icons
                                    .timelapse_rounded,
                              ),
                            ),
                            const SizedBox(width: 10),
                            Expanded(
                              child: _ProjectInfoCard(
                                title: 'Completed',
                                value: projectViewModel
                                    .completedProjects
                                    .toString(),
                                icon: Icons
                                    .check_circle_outline,
                              ),
                            ),
                          ],
                        ),
                        // Summary End

                        const SizedBox(height: 25),

                        // Filters Start
                        SingleChildScrollView(
                          scrollDirection:
                              Axis.horizontal,
                          child: Row(
                            children: [
                              _FilterButton(
                                title: 'All',
                                selected:
                                    projectViewModel
                                            .selectedFilter ==
                                        'All',
                                onTap: () {
                                  projectViewModel
                                      .changeFilter(
                                    'All',
                                  );
                                },
                              ),
                              const SizedBox(width: 8),
                              _FilterButton(
                                title: 'In Progress',
                                selected:
                                    projectViewModel
                                            .selectedFilter ==
                                        'In Progress',
                                onTap: () {
                                  projectViewModel
                                      .changeFilter(
                                    'In Progress',
                                  );
                                },
                              ),
                              const SizedBox(width: 8),
                              _FilterButton(
                                title: 'Completed',
                                selected:
                                    projectViewModel
                                            .selectedFilter ==
                                        'Completed',
                                onTap: () {
                                  projectViewModel
                                      .changeFilter(
                                    'Completed',
                                  );
                                },
                              ),
                              const SizedBox(width: 8),
                              _FilterButton(
                                title: 'Remaining',
                                selected:
                                    projectViewModel
                                            .selectedFilter ==
                                        'Remaining',
                                onTap: () {
                                  projectViewModel
                                      .changeFilter(
                                    'Remaining',
                                  );
                                },
                              ),
                            ],
                          ),
                        ),
                        // Filters End

                        const SizedBox(height: 25),

                        // Error Start
                        if (projectViewModel
                                .errorMessage !=
                            null)
                          Container(
                            width: double.infinity,
                            margin:
                                const EdgeInsets.only(
                              bottom: 20,
                            ),
                            padding:
                                const EdgeInsets.all(14),
                            decoration: BoxDecoration(
                              color: AppColors.error
                                  .withValues(
                                alpha: 0.08,
                              ),
                              borderRadius:
                                  BorderRadius.circular(
                                12,
                              ),
                            ),
                            child: Text(
                              projectViewModel
                                  .errorMessage!,
                              style: const TextStyle(
                                color: AppColors.error,
                              ),
                            ),
                          ),
                        // Error End

                        // Projects Start
                        if (projectViewModel
                            .filteredProjects.isEmpty)
                          _EmptyProjects(
                            onCreate:
                                openCreateProject,
                          )
                        else
                          ListView.separated(
                            shrinkWrap: true,
                            physics:
                                const NeverScrollableScrollPhysics(),
                            itemCount: projectViewModel
                                .filteredProjects
                                .length,
                            separatorBuilder:
                                (context, index) {
                              return const SizedBox(
                                height: 12,
                              );
                            },
                            itemBuilder:
                                (context, index) {
                              final project =
                                  projectViewModel
                                          .filteredProjects[
                                      index];

                              return _ProjectCard(
                                project: project,
                                onTap: () {
                                  openProjectDetails(
                                    project,
                                  );
                                },
                              );
                            },
                          ),
                        // Projects End

                        const SizedBox(height: 100),
                      ],
                    ),
                  ),
                ),
              ),
      ),
      // Body End

      // Floating Button Start
      floatingActionButton:
          FloatingActionButton.extended(
        onPressed: openCreateProject,
        icon: const Icon(
          Icons.add_rounded,
        ),
        label: const Text(
          'New Project',
        ),
      ),
      // Floating Button End
    );
  }
}

// Project Info Card Start
class _ProjectInfoCard extends StatelessWidget {
  final String title;
  final String value;
  final IconData icon;

  const _ProjectInfoCard({
    required this.title,
    required this.value,
    required this.icon,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: AppColors.lightGrey,
        borderRadius: BorderRadius.circular(16),
      ),
      child: Column(
        children: [
          Icon(
            icon,
            color: AppColors.primary,
          ),
          const SizedBox(height: 8),
          Text(
            value,
            style: const TextStyle(
              fontSize: 20,
              fontWeight: FontWeight.bold,
              color: AppColors.black,
            ),
          ),
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
    );
  }
}
// Project Info Card End

// Filter Button Start
class _FilterButton extends StatelessWidget {
  final String title;
  final bool selected;
  final VoidCallback onTap;

  const _FilterButton({
    required this.title,
    required this.selected,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return ChoiceChip(
      label: Text(title),
      selected: selected,
      onSelected: (_) {
        onTap();
      },
    );
  }
}
// Filter Button End

// Empty Projects Start
class _EmptyProjects extends StatelessWidget {
  final VoidCallback onCreate;

  const _EmptyProjects({
    required this.onCreate,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.symmetric(
        horizontal: 25,
        vertical: 50,
      ),
      decoration: BoxDecoration(
        color: AppColors.lightGrey,
        borderRadius: BorderRadius.circular(20),
      ),
      child: Column(
        children: [
          Container(
            width: 75,
            height: 75,
            decoration: BoxDecoration(
              color: AppColors.primary.withValues(
                alpha: 0.10,
              ),
              borderRadius:
                  BorderRadius.circular(20),
            ),
            child: const Icon(
              Icons.folder_open_rounded,
              size: 38,
              color: AppColors.primary,
            ),
          ),

          const SizedBox(height: 18),

          const Text(
            'No Projects Yet',
            style: TextStyle(
              fontSize: 20,
              fontWeight: FontWeight.bold,
            ),
          ),

          const SizedBox(height: 8),

          const Text(
            'Create your first project and start collaborating with your team.',
            textAlign: TextAlign.center,
            style: TextStyle(
              color: AppColors.grey,
              height: 1.5,
            ),
          ),

          const SizedBox(height: 22),

          FilledButton.icon(
            onPressed: onCreate,
            icon: const Icon(
              Icons.add_rounded,
            ),
            label: const Text(
              'Create Project',
            ),
          ),
        ],
      ),
    );
  }
}
// Empty Projects End

// Project Card Start
class _ProjectCard extends StatelessWidget {
  final ProjectModel project;
  final VoidCallback onTap;

  const _ProjectCard({
    required this.project,
    required this.onTap,
  });

  String get formattedDate {
    final day =
        project.dueDate.day.toString().padLeft(2, '0');

    final month =
        project.dueDate.month.toString().padLeft(2, '0');

    return '$day/$month/${project.dueDate.year}';
  }

  String get statusText {
    switch (project.status) {
      case 'completed':
        return 'Completed';

      case 'in_progress':
        return 'In Progress';

      default:
        return 'Remaining';
    }
  }

  @override
  Widget build(BuildContext context) {
    return Material(
      color: AppColors.white,
      borderRadius: BorderRadius.circular(16),
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(16),
        child: Container(
          padding: const EdgeInsets.all(18),
          decoration: BoxDecoration(
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
              // Project Header Start
              Row(
                children: [
                  Container(
                    width: 45,
                    height: 45,
                    decoration: BoxDecoration(
                      color: AppColors.primary
                          .withValues(
                        alpha: 0.10,
                      ),
                      borderRadius:
                          BorderRadius.circular(12),
                    ),
                    child: const Icon(
                      Icons.folder_rounded,
                      color: AppColors.primary,
                    ),
                  ),

                  const SizedBox(width: 12),

                  Expanded(
                    child: Text(
                      project.name,
                      style: const TextStyle(
                        fontSize: 17,
                        fontWeight:
                            FontWeight.bold,
                      ),
                    ),
                  ),

                  const Icon(
                    Icons.chevron_right_rounded,
                    color: AppColors.grey,
                  ),
                ],
              ),
              // Project Header End

              const SizedBox(height: 14),

              // Description Start
              Text(
                project.description,
                maxLines: 2,
                overflow: TextOverflow.ellipsis,
                style: const TextStyle(
                  color: AppColors.grey,
                  height: 1.4,
                ),
              ),
              // Description End

              const SizedBox(height: 16),

              // Project Footer Start
              Row(
                children: [
                  const Icon(
                    Icons.calendar_month_outlined,
                    size: 18,
                    color: AppColors.grey,
                  ),

                  const SizedBox(width: 6),

                  Text(
                    'Due: $formattedDate',
                    style: const TextStyle(
                      color: AppColors.grey,
                    ),
                  ),

                  const Spacer(),

                  Text(
                    statusText,
                    style: const TextStyle(
                      color: AppColors.primary,
                      fontWeight:
                          FontWeight.w600,
                    ),
                  ),
                ],
              ),
              // Project Footer End
            ],
          ),
        ),
      ),
    );
  }
}
// Project Card End