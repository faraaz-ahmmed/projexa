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
      title: 'Tasks',
      icon: Icons.task_alt_rounded,
    ),
    _ComingSoonPage(
      title: 'Calendar',
      icon: Icons.calendar_month_rounded,
    ),
    _ComingSoonPage(
      title: 'Profile',
      icon: Icons.person_rounded,
    ),
  ];
  // Pages End

  // Change Page Start
  void changePage(int index) {
    setState(() {
      selectedIndex = index;
    });
  }
  // Change Page End

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
        height: 70,
        selectedIndex: selectedIndex,
        onDestinationSelected: changePage,
        backgroundColor: AppColors.white,
        indicatorColor: AppColors.primary.withValues(
          alpha: 0.12,
        ),
        destinations: const [
          // Dashboard Start
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
          // Dashboard End

          // Projects Start
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
          // Projects End

          // Tasks Start
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
          // Tasks End

          // Calendar Start
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
          // Calendar End

          // Profile Start
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
          // Profile End
        ],
      ),
      // Bottom Navigation End
    );
  }
}

// Coming Soon Page Start
class _ComingSoonPage extends StatelessWidget {
  final String title;
  final IconData icon;

  const _ComingSoonPage({
    required this.title,
    required this.icon,
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
              size: 60,
              color: AppColors.primary,
            ),
            const SizedBox(height: 15),
            Text(
              title,
              style: const TextStyle(
                fontSize: 24,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 5),
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