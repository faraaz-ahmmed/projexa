import 'package:flutter/material.dart';

import '../../utils/app_colors.dart';
import '../dashboard/dashboard_screen.dart';
import '../projects/my_projects_screen.dart';

class MainNavigationScreen extends StatefulWidget {
  const MainNavigationScreen({super.key});

  @override
  State<MainNavigationScreen> createState() =>
      _MainNavigationScreenState();
}

class _MainNavigationScreenState
    extends State<MainNavigationScreen> {
  int selectedIndex = 0;

  // Pages Start
  final List<Widget> pages = const [
    DashboardScreen(),
    MyProjectsScreen(),
    _ComingSoonPage(
      icon: Icons.task_alt_outlined,
      title: 'Tasks',
    ),
    _ComingSoonPage(
      icon: Icons.calendar_month_outlined,
      title: 'Calendar',
    ),
    _ComingSoonPage(
      icon: Icons.person_outline_rounded,
      title: 'Profile',
    ),
  ];
  // Pages End

  // Navigation Start
  void changePage(int index) {
    setState(() {
      selectedIndex = index;
    });
  }
  // Navigation End

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      // Body Start
      body: IndexedStack(
        index: selectedIndex,
        children: pages,
      ),
      // Body End

      // Bottom Navigation Start
      bottomNavigationBar: NavigationBar(
        selectedIndex: selectedIndex,
        onDestinationSelected: changePage,
        indicatorColor: AppColors.primary.withValues(
          alpha: 0.12,
        ),
        destinations: const [
          NavigationDestination(
            icon: Icon(
              Icons.dashboard_outlined,
            ),
            selectedIcon: Icon(
              Icons.dashboard_rounded,
              color: AppColors.primary,
            ),
            label: 'Dashboard',
          ),
          NavigationDestination(
            icon: Icon(
              Icons.folder_outlined,
            ),
            selectedIcon: Icon(
              Icons.folder_rounded,
              color: AppColors.primary,
            ),
            label: 'Projects',
          ),
          NavigationDestination(
            icon: Icon(
              Icons.task_alt_outlined,
            ),
            selectedIcon: Icon(
              Icons.task_alt_rounded,
              color: AppColors.primary,
            ),
            label: 'Tasks',
          ),
          NavigationDestination(
            icon: Icon(
              Icons.calendar_month_outlined,
            ),
            selectedIcon: Icon(
              Icons.calendar_month_rounded,
              color: AppColors.primary,
            ),
            label: 'Calendar',
          ),
          NavigationDestination(
            icon: Icon(
              Icons.person_outline_rounded,
            ),
            selectedIcon: Icon(
              Icons.person_rounded,
              color: AppColors.primary,
            ),
            label: 'Profile',
          ),
        ],
      ),
      // Bottom Navigation End
    );
  }
}

// Coming Soon Page Start
class _ComingSoonPage extends StatelessWidget {
  final IconData icon;
  final String title;

  const _ComingSoonPage({
    required this.icon,
    required this.title,
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      // AppBar Start
      appBar: AppBar(
        title: Text(
          title,
          style: const TextStyle(
            fontWeight: FontWeight.bold,
          ),
        ),
      ),
      // AppBar End

      // Body Start
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              icon,
              size: 65,
              color: AppColors.primary,
            ),
            const SizedBox(height: 16),
            Text(
              title,
              style: const TextStyle(
                fontSize: 24,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 8),
            const Text(
              'Coming Soon',
              style: TextStyle(
                color: AppColors.grey,
              ),
            ),
          ],
        ),
      ),
      // Body End
    );
  }
}
// Coming Soon Page End