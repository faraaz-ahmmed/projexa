import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../models/project_member_model.dart';
import '../../models/project_model.dart';
import '../../utils/app_colors.dart';
import '../../viewmodels/team_viewmodel.dart';
import '../team/add_member_screen.dart';

class ProjectDetailsScreen extends StatefulWidget {
  final ProjectModel project;

  const ProjectDetailsScreen({
    super.key,
    required this.project,
  });

  @override
  State<ProjectDetailsScreen> createState() =>
      _ProjectDetailsScreenState();
}

class _ProjectDetailsScreenState
    extends State<ProjectDetailsScreen> {
  // Load Team Start
  @override
  void initState() {
    super.initState();

    WidgetsBinding.instance.addPostFrameCallback((_) {
      context.read<TeamViewModel>().loadMembers(
            widget.project.id,
          );
    });
  }
  // Load Team End

  // Date Start
  String get formattedDueDate {
    final day = widget.project.dueDate.day
        .toString()
        .padLeft(2, '0');

    final month = widget.project.dueDate.month
        .toString()
        .padLeft(2, '0');

    return '$day/$month/${widget.project.dueDate.year}';
  }
  // Date End

  // Status Start
  String get statusText {
    switch (widget.project.status) {
      case 'completed':
        return 'Completed';

      case 'in_progress':
        return 'In Progress';

      default:
        return 'Remaining';
    }
  }
  // Status End

  // Progress Start
  double get projectProgress {
    switch (widget.project.status) {
      case 'completed':
        return 1.0;

      case 'in_progress':
        return 0.5;

      default:
        return 0.0;
    }
  }

  int get progressPercentage {
    return (projectProgress * 100).round();
  }
  // Progress End

  // Add Member Start
  Future<void> openAddMember() async {
    await Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => AddMemberScreen(
          projectId: widget.project.id,
        ),
      ),
    );
  }
  // Add Member End

  // Remove Member Start
  Future<void> removeMember(
    ProjectMemberModel member,
  ) async {
    final shouldRemove =
        await showDialog<bool>(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: const Text(
            'Remove Member',
          ),
          content: Text(
            'Remove ${member.name} from this project?',
          ),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.pop(
                  context,
                  false,
                );
              },
              child: const Text(
                'Cancel',
              ),
            ),
            FilledButton(
              onPressed: () {
                Navigator.pop(
                  context,
                  true,
                );
              },
              child: const Text(
                'Remove',
              ),
            ),
          ],
        );
      },
    );

    if (shouldRemove != true || !mounted) {
      return;
    }

    final teamViewModel =
        context.read<TeamViewModel>();

    final success =
        await teamViewModel.removeMember(
      projectId: widget.project.id,
      userId: member.uid,
    );

    if (!mounted) return;

    if (success) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text(
            'Team member removed.',
          ),
        ),
      );
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(
            teamViewModel.errorMessage ??
                'Unable to remove member.',
          ),
        ),
      );
    }
  }
  // Remove Member End

  @override
  Widget build(BuildContext context) {
    final teamViewModel =
        context.watch<TeamViewModel>();

    return Scaffold(
      // AppBar Start
      appBar: AppBar(
        title: const Text(
          'Project Details',
          style: TextStyle(
            fontWeight: FontWeight.bold,
          ),
        ),
        actions: [
          IconButton(
            onPressed: () {},
            tooltip: 'Edit Project',
            icon: const Icon(
              Icons.edit_outlined,
            ),
          ),
          const SizedBox(width: 8),
        ],
      ),
      // AppBar End

      // Body Start
      body: SafeArea(
        child: Center(
          child: SingleChildScrollView(
            padding: const EdgeInsets.all(20),
            child: ConstrainedBox(
              constraints: const BoxConstraints(
                maxWidth: 800,
              ),
              child: Column(
                crossAxisAlignment:
                    CrossAxisAlignment.start,
                children: [
                  // Project Header Start
                  Row(
                    crossAxisAlignment:
                        CrossAxisAlignment.start,
                    children: [
                      Container(
                        width: 60,
                        height: 60,
                        decoration: BoxDecoration(
                          color: AppColors.primary
                              .withValues(
                            alpha: 0.10,
                          ),
                          borderRadius:
                              BorderRadius.circular(16),
                        ),
                        child: const Icon(
                          Icons.folder_rounded,
                          size: 32,
                          color: AppColors.primary,
                        ),
                      ),

                      const SizedBox(width: 15),

                      Expanded(
                        child: Column(
                          crossAxisAlignment:
                              CrossAxisAlignment.start,
                          children: [
                            Text(
                              widget.project.name,
                              style: const TextStyle(
                                fontSize: 26,
                                fontWeight:
                                    FontWeight.bold,
                                color: AppColors.black,
                              ),
                            ),

                            const SizedBox(height: 7),

                            Container(
                              padding:
                                  const EdgeInsets
                                      .symmetric(
                                horizontal: 12,
                                vertical: 6,
                              ),
                              decoration: BoxDecoration(
                                color: AppColors.primary
                                    .withValues(
                                  alpha: 0.10,
                                ),
                                borderRadius:
                                    BorderRadius.circular(
                                  20,
                                ),
                              ),
                              child: Text(
                                statusText,
                                style: const TextStyle(
                                  color:
                                      AppColors.primary,
                                  fontWeight:
                                      FontWeight.w600,
                                  fontSize: 12,
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                  // Project Header End

                  const SizedBox(height: 30),

                  // Description Start
                  const Text(
                    'Description',
                    style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                    ),
                  ),

                  const SizedBox(height: 10),

                  Text(
                    widget.project.description,
                    style: const TextStyle(
                      color: AppColors.grey,
                      height: 1.6,
                      fontSize: 15,
                    ),
                  ),
                  // Description End

                  const SizedBox(height: 30),

                  // Project Information Start
                  Row(
                    children: [
                      Expanded(
                        child: _InfoCard(
                          icon: Icons
                              .calendar_month_outlined,
                          title: 'Due Date',
                          value: formattedDueDate,
                        ),
                      ),
                      const SizedBox(width: 12),
                      Expanded(
                        child: _InfoCard(
                          icon: Icons.flag_outlined,
                          title: 'Status',
                          value: statusText,
                        ),
                      ),
                    ],
                  ),
                  // Project Information End

                  const SizedBox(height: 30),

                  // Progress Start
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
                        Row(
                          mainAxisAlignment:
                              MainAxisAlignment
                                  .spaceBetween,
                          children: [
                            const Text(
                              'Project Progress',
                              style: TextStyle(
                                fontSize: 17,
                                fontWeight:
                                    FontWeight.bold,
                              ),
                            ),
                            Text(
                              '$progressPercentage%',
                              style: const TextStyle(
                                color:
                                    AppColors.primary,
                                fontWeight:
                                    FontWeight.bold,
                              ),
                            ),
                          ],
                        ),

                        const SizedBox(height: 15),

                        LinearProgressIndicator(
                          value: projectProgress,
                          minHeight: 9,
                          borderRadius:
                              BorderRadius.circular(10),
                        ),
                      ],
                    ),
                  ),
                  // Progress End

                  const SizedBox(height: 30),

                  // Tasks Start
                  Row(
                    mainAxisAlignment:
                        MainAxisAlignment.spaceBetween,
                    children: [
                      const Text(
                        'Tasks',
                        style: TextStyle(
                          fontSize: 20,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      TextButton.icon(
                        onPressed: () {},
                        icon: const Icon(
                          Icons.add_rounded,
                        ),
                        label: const Text(
                          'Add Task',
                        ),
                      ),
                    ],
                  ),

                  const SizedBox(height: 10),

                  const _EmptySection(
                    icon: Icons.task_alt_outlined,
                    title: 'No Tasks Yet',
                    message:
                        'Project tasks will appear here.',
                  ),
                  // Tasks End

                  const SizedBox(height: 30),

                  // Team Header Start
                  Row(
                    mainAxisAlignment:
                        MainAxisAlignment.spaceBetween,
                    children: [
                      Row(
                        children: [
                          const Text(
                            'Team',
                            style: TextStyle(
                              fontSize: 20,
                              fontWeight:
                                  FontWeight.bold,
                            ),
                          ),
                          const SizedBox(width: 8),
                          Container(
                            padding:
                                const EdgeInsets.symmetric(
                              horizontal: 9,
                              vertical: 4,
                            ),
                            decoration: BoxDecoration(
                              color: AppColors.primary
                                  .withValues(
                                alpha: 0.10,
                              ),
                              borderRadius:
                                  BorderRadius.circular(
                                20,
                              ),
                            ),
                            child: Text(
                              teamViewModel.totalMembers
                                  .toString(),
                              style: const TextStyle(
                                color:
                                    AppColors.primary,
                                fontWeight:
                                    FontWeight.bold,
                              ),
                            ),
                          ),
                        ],
                      ),

                      TextButton.icon(
                        onPressed: openAddMember,
                        icon: const Icon(
                          Icons
                              .person_add_alt_1_rounded,
                        ),
                        label: const Text(
                          'Add Member',
                        ),
                      ),
                    ],
                  ),
                  // Team Header End

                  const SizedBox(height: 10),

                  // Team Members Start
                  if (teamViewModel.isLoading)
                    const Center(
                      child: Padding(
                        padding:
                            EdgeInsets.all(30),
                        child:
                            CircularProgressIndicator(),
                      ),
                    )
                  else if (teamViewModel
                      .members.isEmpty)
                    const _EmptySection(
                      icon: Icons.group_outlined,
                      title: 'No Team Members',
                      message:
                          'Add registered Projexa users to this project.',
                    )
                  else
                    ListView.separated(
                      shrinkWrap: true,
                      physics:
                          const NeverScrollableScrollPhysics(),
                      itemCount:
                          teamViewModel.members.length,
                      separatorBuilder:
                          (context, index) {
                        return const SizedBox(
                          height: 10,
                        );
                      },
                      itemBuilder:
                          (context, index) {
                        final member =
                            teamViewModel
                                .members[index];

                        return _MemberCard(
                          member: member,
                          onRemove: () {
                            removeMember(member);
                          },
                        );
                      },
                    ),
                  // Team Members End

                  const SizedBox(height: 30),
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

// Information Card Start
class _InfoCard extends StatelessWidget {
  final IconData icon;
  final String title;
  final String value;

  const _InfoCard({
    required this.icon,
    required this.title,
    required this.value,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: AppColors.lightGrey,
        borderRadius: BorderRadius.circular(16),
      ),
      child: Column(
        crossAxisAlignment:
            CrossAxisAlignment.start,
        children: [
          Icon(
            icon,
            color: AppColors.primary,
          ),
          const SizedBox(height: 12),
          Text(
            title,
            style: const TextStyle(
              fontSize: 12,
              color: AppColors.grey,
            ),
          ),
          const SizedBox(height: 4),
          Text(
            value,
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
            style: const TextStyle(
              fontWeight: FontWeight.bold,
              color: AppColors.black,
            ),
          ),
        ],
      ),
    );
  }
}
// Information Card End

// Team Member Card Start
class _MemberCard extends StatelessWidget {
  final ProjectMemberModel member;
  final VoidCallback onRemove;

  const _MemberCard({
    required this.member,
    required this.onRemove,
  });

  @override
  Widget build(BuildContext context) {
    final firstLetter = member.name.trim().isEmpty
        ? '?'
        : member.name
            .trim()
            .substring(0, 1)
            .toUpperCase();

    return Container(
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: AppColors.white,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(
          color: AppColors.lightGrey,
        ),
      ),
      child: Row(
        children: [
          // Avatar Start
          CircleAvatar(
            radius: 23,
            backgroundColor:
                AppColors.primary.withValues(
              alpha: 0.10,
            ),
            child: Text(
              firstLetter,
              style: const TextStyle(
                color: AppColors.primary,
                fontSize: 18,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
          // Avatar End

          const SizedBox(width: 12),

          // Member Information Start
          Expanded(
            child: Column(
              crossAxisAlignment:
                  CrossAxisAlignment.start,
              children: [
                Text(
                  member.name.isEmpty
                      ? 'Projexa User'
                      : member.name,
                  style: const TextStyle(
                    fontSize: 15,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: 3),
                Text(
                  member.email,
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: const TextStyle(
                    fontSize: 13,
                    color: AppColors.grey,
                  ),
                ),
              ],
            ),
          ),
          // Member Information End

          // Role Start
          Container(
            padding: const EdgeInsets.symmetric(
              horizontal: 10,
              vertical: 5,
            ),
            decoration: BoxDecoration(
              color: AppColors.primary.withValues(
                alpha: 0.08,
              ),
              borderRadius: BorderRadius.circular(20),
            ),
            child: const Text(
              'Member',
              style: TextStyle(
                fontSize: 11,
                color: AppColors.primary,
                fontWeight: FontWeight.w600,
              ),
            ),
          ),
          // Role End

          const SizedBox(width: 5),

          // Remove Start
          IconButton(
            onPressed: onRemove,
            tooltip: 'Remove Member',
            icon: const Icon(
              Icons.delete_outline_rounded,
              color: AppColors.error,
            ),
          ),
          // Remove End
        ],
      ),
    );
  }
}
// Team Member Card End

// Empty Section Start
class _EmptySection extends StatelessWidget {
  final IconData icon;
  final String title;
  final String message;

  const _EmptySection({
    required this.icon,
    required this.title,
    required this.message,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.symmetric(
        vertical: 30,
        horizontal: 20,
      ),
      decoration: BoxDecoration(
        color: AppColors.lightGrey,
        borderRadius: BorderRadius.circular(18),
      ),
      child: Column(
        children: [
          Icon(
            icon,
            size: 38,
            color: AppColors.grey,
          ),
          const SizedBox(height: 10),
          Text(
            title,
            style: const TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 5),
          Text(
            message,
            textAlign: TextAlign.center,
            style: const TextStyle(
              color: AppColors.grey,
            ),
          ),
        ],
      ),
    );
  }
}
// Empty Section End