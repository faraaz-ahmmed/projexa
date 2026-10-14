import 'package:flutter/material.dart';

import '../../utils/app_colors.dart';

class MyProjectsScreen extends StatelessWidget {
  const MyProjectsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      // AppBar Start
      appBar: AppBar(
        title: const Text(
          'My Projects',
          style: TextStyle(
            fontWeight: FontWeight.bold,
          ),
        ),
        actions: [
          IconButton(
            onPressed: () {},
            tooltip: 'Search',
            icon: const Icon(
              Icons.search_rounded,
            ),
          ),
          const SizedBox(width: 8),
        ],
      ),
      // AppBar End

      // Body Start
      body: SafeArea(
        child: Center(
          child: ConstrainedBox(
            constraints: const BoxConstraints(
              maxWidth: 900,
            ),
            child: SingleChildScrollView(
              padding: const EdgeInsets.all(20),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Header Start
                  const Text(
                    'Projects',
                    style: TextStyle(
                      fontSize: 26,
                      fontWeight: FontWeight.bold,
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

                  // Project Summary Start
                  Row(
                    children: [
                      Expanded(
                        child: _ProjectInfoCard(
                          title: 'Total',
                          value: '0',
                          icon: Icons.folder_outlined,
                        ),
                      ),
                      const SizedBox(width: 12),
                      Expanded(
                        child: _ProjectInfoCard(
                          title: 'Active',
                          value: '0',
                          icon: Icons.timelapse_rounded,
                        ),
                      ),
                      const SizedBox(width: 12),
                      Expanded(
                        child: _ProjectInfoCard(
                          title: 'Completed',
                          value: '0',
                          icon: Icons.check_circle_outline,
                        ),
                      ),
                    ],
                  ),
                  // Project Summary End

                  const SizedBox(height: 30),

                  // Filter Start
                  SingleChildScrollView(
                    scrollDirection: Axis.horizontal,
                    child: Row(
                      children: [
                        _FilterButton(
                          title: 'All',
                          selected: true,
                          onTap: () {},
                        ),
                        const SizedBox(width: 10),
                        _FilterButton(
                          title: 'In Progress',
                          selected: false,
                          onTap: () {},
                        ),
                        const SizedBox(width: 10),
                        _FilterButton(
                          title: 'Completed',
                          selected: false,
                          onTap: () {},
                        ),
                        const SizedBox(width: 10),
                        _FilterButton(
                          title: 'Remaining',
                          selected: false,
                          onTap: () {},
                        ),
                      ],
                    ),
                  ),
                  // Filter End

                  const SizedBox(height: 30),

                  // Empty Projects Start
                  Container(
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
                            borderRadius: BorderRadius.circular(20),
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
                            color: AppColors.black,
                          ),
                        ),

                        const SizedBox(height: 8),

                        const Text(
                          'Create your first project and start collaborating with your team.',
                          textAlign: TextAlign.center,
                          style: TextStyle(
                            fontSize: 14,
                            height: 1.5,
                            color: AppColors.grey,
                          ),
                        ),

                        const SizedBox(height: 22),

                        FilledButton.icon(
                          onPressed: () {},
                          icon: const Icon(
                            Icons.add_rounded,
                          ),
                          label: const Text(
                            'Create Project',
                          ),
                        ),
                      ],
                    ),
                  ),
                  // Empty Projects End

                  const SizedBox(height: 100),
                ],
              ),
            ),
          ),
        ),
      ),
      // Body End

      // Floating Button Start
      floatingActionButton: FloatingActionButton.extended(
        onPressed: () {},
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
      padding: const EdgeInsets.all(15),
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
              fontSize: 21,
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