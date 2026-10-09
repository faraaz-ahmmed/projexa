import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../viewmodels/auth_viewmodel.dart';
import '../auth/login_screen.dart';

class DashboardScreen extends StatelessWidget {
  const DashboardScreen({super.key});

  @override
  Widget build(BuildContext context) {
    // User data section start
    final auth = context.watch<AuthViewModel>();
    final user = FirebaseAuth.instance.currentUser;
    final name = user?.displayName;
    final greeting = name == null || name.isEmpty ? 'User' : name;
    // User data section end

    // Sample projects section start
    const projects = [
      ('Website Redesign', 'UI/UX • Frontend', 0.8, Colors.purple),
      ('Mobile App Development', 'Backend • API', 0.5, Colors.teal),
      ('Marketing Campaign', 'Content • Social Media', 1.0, Colors.orange),
    ];
    // Sample projects section end

    return Scaffold(
      // AppBar section start
      appBar: AppBar(
        title: const Text(
          'Projexa',
          style: TextStyle(fontWeight: FontWeight.bold),
        ),
        actions: [
          // Logout section start
          IconButton(
            tooltip: 'Logout',
            onPressed: auth.isLoading
                ? null
                : () async {
                    final success = await auth.logout();

                    if (!context.mounted) return;

                    if (success) {
                      Navigator.of(context).pushAndRemoveUntil(
                        MaterialPageRoute(
                          builder: (_) => const LoginScreen(),
                        ),
                        (_) => false,
                      );
                    } else {
                      ScaffoldMessenger.of(context).showSnackBar(
                        SnackBar(
                          content: Text(auth.error ?? 'Logout failed'),
                        ),
                      );
                    }
                  },
            icon: const Icon(Icons.logout),
          ),
          // Logout section end
        ],
      ),
      // AppBar section end

      // Body start
      body: SafeArea(
        child: Center(
          child: ConstrainedBox(
            constraints: const BoxConstraints(maxWidth: 1000),
            child: ListView(
              padding: const EdgeInsets.all(20),
              children: [
                // Welcome section start
                Text(
                  'Welcome, $greeting! 👋',
                  style: const TextStyle(
                    fontSize: 24,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: 6),
                const Text(
                  "Here's an overview of your projects.",
                  style: TextStyle(color: Colors.grey),
                ),
                const SizedBox(height: 24),
                // Welcome section end

                // Project cards section start
                LayoutBuilder(
                  builder: (context, constraints) {
                    final columns = constraints.maxWidth >= 700 ? 4 : 2;
                    final width =
                        (constraints.maxWidth - (columns - 1) * 12) / columns;

                    return Wrap(
                      spacing: 12,
                      runSpacing: 12,
                      children: [
                        SizedBox(
                          width: width,
                          child: const _StatCard(
                            title: 'Total Projects',
                            value: '5',
                            icon: Icons.folder_outlined,
                            color: Color(0xff155DFC),
                          ),
                        ),
                        SizedBox(
                          width: width,
                          child: const _StatCard(
                            title: 'Completed',
                            value: '3',
                            icon: Icons.check_circle_outline,
                            color: Colors.green,
                          ),
                        ),
                        SizedBox(
                          width: width,
                          child: const _StatCard(
                            title: 'In Progress',
                            value: '2',
                            icon: Icons.timelapse,
                            color: Colors.orange,
                          ),
                        ),
                        SizedBox(
                          width: width,
                          child: const _StatCard(
                            title: 'Remaining',
                            value: '0',
                            icon: Icons.pending_outlined,
                            color: Colors.red,
                          ),
                        ),
                      ],
                    );
                  },
                ),
                const SizedBox(height: 20),
                // Project cards section end

                // Progress overview section start
                Card(
                  color: Colors.white,
                  child: Padding(
                    padding: const EdgeInsets.all(20),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const Text(
                          'Project Progress Overview',
                          style: TextStyle(
                            fontSize: 18,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        const SizedBox(height: 24),
                        Wrap(
                          spacing: 32,
                          runSpacing: 24,
                          crossAxisAlignment: WrapCrossAlignment.center,
                          children: [
                            // Circular progress section start
                            SizedBox(
                              width: 120,
                              height: 120,
                              child: Stack(
                                alignment: Alignment.center,
                                children: [
                                  const SizedBox.expand(
                                    child: CircularProgressIndicator(
                                      value: 0.6,
                                      strokeWidth: 12,
                                      backgroundColor: Color(0xffE8EDF5),
                                      color: Colors.green,
                                    ),
                                  ),
                                  Column(
                                    mainAxisSize: MainAxisSize.min,
                                    children: [
                                      const Text(
                                        '60%',
                                        style: TextStyle(
                                          fontSize: 28,
                                          fontWeight: FontWeight.bold,
                                        ),
                                      ),
                                      Text(
                                        'Completed',
                                        style: TextStyle(
                                          color: Colors.grey.shade600,
                                        ),
                                      ),
                                    ],
                                  ),
                                ],
                              ),
                            ),
                            // Circular progress section end

                            // Project status section start
                            const Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                _StatusRow(
                                  title: 'Completed',
                                  value: '3',
                                  color: Colors.green,
                                ),
                                SizedBox(height: 16),
                                _StatusRow(
                                  title: 'In Progress',
                                  value: '2',
                                  color: Color(0xff155DFC),
                                ),
                                SizedBox(height: 16),
                                _StatusRow(
                                  title: 'Remaining',
                                  value: '0',
                                  color: Colors.grey,
                                ),
                              ],
                            ),
                            // Project status section end
                          ],
                        ),
                      ],
                    ),
                  ),
                ),
                const SizedBox(height: 20),
                // Progress overview section end

                // Recent projects section start
                const Text(
                  'Recent Projects',
                  style: TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: 12),
                for (final project in projects)
                  Card(
                    color: Colors.white,
                    margin: const EdgeInsets.only(bottom: 12),
                    child: Padding(
                      padding: const EdgeInsets.all(16),
                      child: Row(
                        children: [
                          CircleAvatar(
                            backgroundColor: project.$4,
                            child: const Icon(
                              Icons.assignment_outlined,
                              color: Colors.white,
                            ),
                          ),
                          const SizedBox(width: 12),
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  project.$1,
                                  style: const TextStyle(
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                                const SizedBox(height: 4),
                                Text(
                                  project.$2,
                                  style: const TextStyle(
                                    fontSize: 12,
                                    color: Colors.grey,
                                  ),
                                ),
                                const SizedBox(height: 10),
                                LinearProgressIndicator(
                                  value: project.$3,
                                  minHeight: 6,
                                  borderRadius: BorderRadius.circular(8),
                                  backgroundColor: const Color(0xffE8EDF5),
                                  color: Colors.green,
                                ),
                              ],
                            ),
                          ),
                          const SizedBox(width: 12),
                          Text(
                            '${(project.$3 * 100).round()}%',
                            style: const TextStyle(
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                const SizedBox(height: 8),
                // Recent projects section end

                // Footer section start
                const Text(
                  'Demo data • Firebase projects will be connected next.',
                  textAlign: TextAlign.center,
                  style: TextStyle(fontSize: 12, color: Colors.grey),
                ),
                // Footer section end
              ],
            ),
          ),
        ),
      ),
      // Body end
    );
  }
}

// Stat card widget section start
class _StatCard extends StatelessWidget {
  final String title;
  final String value;
  final IconData icon;
  final Color color;

  const _StatCard({
    required this.title,
    required this.value,
    required this.icon,
    required this.color,
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      color: Colors.white,
      margin: EdgeInsets.zero,
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Icon(icon, color: color, size: 30),
            const SizedBox(height: 12),
            Text(
              title,
              style: const TextStyle(fontSize: 12, color: Colors.grey),
            ),
            const SizedBox(height: 4),
            Text(
              value,
              style: const TextStyle(
                fontSize: 26,
                fontWeight: FontWeight.bold,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
// Stat card widget section end

// Status row widget section start
class _StatusRow extends StatelessWidget {
  final String title;
  final String value;
  final Color color;

  const _StatusRow({
    required this.title,
    required this.value,
    required this.color,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        Icon(Icons.circle, size: 10, color: color),
        const SizedBox(width: 8),
        Text('$title   $value'),
      ],
    );
  }
}
// Status row widget section end