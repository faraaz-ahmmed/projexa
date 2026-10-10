import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../models/project_model.dart';
import '../../viewmodels/auth_viewmodel.dart';
import '../../viewmodels/project_viewmodel.dart';
import '../auth/login_screen.dart';
import '../projects/add_project_screen.dart';
import '../projects/project_details_screen.dart';

class DashboardScreen extends StatelessWidget {
  const DashboardScreen({super.key});

  @override
  Widget build(BuildContext context) {
    // Provider section start
    return ChangeNotifierProvider(
      create: (_) => ProjectViewModel(),
      child: const _DashboardContent(),
    );
    // Provider section end
  }
}

class _DashboardContent extends StatelessWidget {
  const _DashboardContent();

  @override
  Widget build(BuildContext context) {
    final auth = context.watch<AuthViewModel>();
    final vm = context.read<ProjectViewModel>();
    final name = FirebaseAuth.instance.currentUser?.displayName;
    final greeting = name == null || name.isEmpty ? 'User' : name;

    return Scaffold(
      // AppBar section start
      appBar: AppBar(
        title: const Text('Projexa'),
        actions: [
          IconButton(
            tooltip: 'Logout',
            icon: const Icon(Icons.logout),
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
          ),
        ],
      ),
      // AppBar section end

      // Body start
      body: SafeArea(
        child: StreamBuilder<List<ProjectModel>>(
          stream: vm.projects,
          builder: (context, snapshot) {
            // Loading aur error section start
            if (snapshot.hasError) {
              return const Center(
                child: Padding(
                  padding: EdgeInsets.all(24),
                  child: Text(
                    'Projects load nahi hue. Internet aur Firestore rules check karein.',
                    textAlign: TextAlign.center,
                  ),
                ),
              );
            }

            if (!snapshot.hasData) {
              return const Center(child: CircularProgressIndicator());
            }
            // Loading aur error section end

            // Counts section start
            final projects = snapshot.data!;
            final completed =
                projects.where((p) => p.status == 'Completed').length;
            final inProgress =
                projects.where((p) => p.status == 'In Progress').length;
            final remaining =
                projects.where((p) => p.status == 'Remaining').length;
            final ratio =
                projects.isEmpty ? 0.0 : completed / projects.length;

            final stats = [
              ('Total Projects', projects.length, Colors.blue),
              ('Completed', completed, Colors.green),
              ('In Progress', inProgress, Colors.orange),
              ('Remaining', remaining, Colors.red),
            ];
            // Counts section end

            return Center(
              child: ConstrainedBox(
                constraints: const BoxConstraints(maxWidth: 1000),
                child: ListView(
                  padding: const EdgeInsets.fromLTRB(20, 20, 20, 100),
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
                    const Text("Here's an overview of your projects."),
                    const SizedBox(height: 24),
                    // Welcome section end

                    // Project cards section start
                    LayoutBuilder(
                      builder: (context, constraints) {
                        final columns = constraints.maxWidth >= 700 ? 4 : 2;
                        final width =
                            (constraints.maxWidth - (columns - 1) * 12) /
                                columns;

                        return Wrap(
                          spacing: 12,
                          runSpacing: 12,
                          children: [
                            for (final stat in stats)
                              SizedBox(
                                width: width,
                                child: Card(
                                  color: Colors.white,
                                  margin: EdgeInsets.zero,
                                  child: Padding(
                                    padding: const EdgeInsets.all(16),
                                    child: Column(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: [
                                        Icon(
                                          Icons.folder_outlined,
                                          color: stat.$3,
                                        ),
                                        const SizedBox(height: 12),
                                        Text(stat.$1),
                                        Text(
                                          '${stat.$2}',
                                          style: const TextStyle(
                                            fontSize: 26,
                                            fontWeight: FontWeight.bold,
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
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
                            const SizedBox(height: 16),
                            LinearProgressIndicator(
                              value: ratio,
                              minHeight: 10,
                              color: Colors.green,
                              backgroundColor: const Color(0xffE8EDF5),
                              borderRadius: BorderRadius.circular(8),
                            ),
                            const SizedBox(height: 12),
                            Text('${(ratio * 100).round()}% completed'),
                          ],
                        ),
                      ),
                    ),
                    const SizedBox(height: 20),
                    // Progress overview section end

                    // Projects list section start
                    const Text(
                      'My Projects',
                      style: TextStyle(
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(height: 12),
                    if (projects.isEmpty)
                      const Padding(
                        padding: EdgeInsets.all(24),
                        child: Text(
                          'No projects yet. Tap Add Project to create one.',
                          textAlign: TextAlign.center,
                        ),
                      ),
                    for (final project in projects)
                      Card(
                        color: Colors.white,
                        clipBehavior: Clip.antiAlias,
                        child: InkWell(
                          onTap: () {
                            Navigator.of(context).push(
                              MaterialPageRoute(
                                builder: (_) => ChangeNotifierProvider.value(
                                  value: vm,
                                  child: ProjectDetailsScreen(
                                    project: project,
                                  ),
                                ),
                              ),
                            );
                          },
                          child: Padding(
                            padding: const EdgeInsets.all(16),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Row(
                                  children: [
                                    Expanded(
                                      child: Text(
                                        project.name,
                                        style: const TextStyle(
                                          fontSize: 16,
                                          fontWeight: FontWeight.bold,
                                        ),
                                      ),
                                    ),
                                    const Icon(Icons.chevron_right),
                                  ],
                                ),
                                const SizedBox(height: 6),
                                Text(project.description),
                                const SizedBox(height: 12),
                                LinearProgressIndicator(
                                  value: project.progress.clamp(0.0, 1.0),
                                  color: Colors.green,
                                  backgroundColor: const Color(0xffE8EDF5),
                                ),
                                const SizedBox(height: 8),
                                Text(
                                  '${project.status} • '
                                  '${(project.progress * 100).round()}%',
                                ),
                                const SizedBox(height: 4),
                                Text(
                                  'Due: ${MaterialLocalizations.of(context).formatMediumDate(project.dueDate)}',
                                ),
                              ],
                            ),
                          ),
                        ),
                      ),
                    // Projects list section end
                  ],
                ),
              ),
            );
          },
        ),
      ),
      // Body end

      // Add project button section start
      floatingActionButton: FloatingActionButton.extended(
        icon: const Icon(Icons.add),
        label: const Text('Add Project'),
        onPressed: auth.isLoading
            ? null
            : () async {
                final saved = await Navigator.of(context).push<bool>(
                  MaterialPageRoute(
                    builder: (_) => ChangeNotifierProvider.value(
                      value: vm,
                      child: const AddProjectScreen(),
                    ),
                  ),
                );

                if (!context.mounted || saved != true) return;

                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(
                    content: Text('Project created successfully'),
                  ),
                );
              },
      ),
      // Add project button section end
    );
  }
}