import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../models/project_model.dart';
import '../../viewmodels/auth_viewmodel.dart';
import '../../viewmodels/project_viewmodel.dart';
import '../auth/login_screen.dart';
import '../projects/add_project_screen.dart';
import '../projects/project_details_screen.dart';
import '../team/team_screen.dart';

class DashboardScreen extends StatelessWidget {
  const DashboardScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (_) => ProjectViewModel(),
      child: const _DashboardContent(),
    );
  }
}

class _DashboardContent extends StatefulWidget {
  const _DashboardContent();

  @override
  State<_DashboardContent> createState() => _DashboardContentState();
}

class _DashboardContentState extends State<_DashboardContent> {
  String searchText = '';
  String selectedStatus = 'All';

  final searchController = TextEditingController();

  static const filters = [
    'All',
    'Remaining',
    'In Progress',
    'Completed',
  ];

  @override
  void dispose() {
    searchController.dispose();
    super.dispose();
  }

  Future<void> logout() async {
    final auth = context.read<AuthViewModel>();
    final success = await auth.logout();

    if (!mounted) return;

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
  }

  Future<void> addProject() async {
    final vm = context.read<ProjectViewModel>();

    final saved = await Navigator.of(context).push<bool>(
      MaterialPageRoute(
        builder: (_) => ChangeNotifierProvider.value(
          value: vm,
          child: const AddProjectScreen(),
        ),
      ),
    );

    if (!mounted || saved != true) return;

    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        content: Text('Project created successfully'),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final auth = context.watch<AuthViewModel>();
    final vm = context.read<ProjectViewModel>();

    final name = FirebaseAuth.instance.currentUser?.displayName;
    final greeting = name == null || name.isEmpty ? 'User' : name;

    return Scaffold(
      appBar: AppBar(
        title: const Text('Projexa'),
        actions: [
          IconButton(
            tooltip: 'Logout',
            onPressed: auth.isLoading ? null : logout,
            icon: const Icon(Icons.logout),
          ),
        ],
      ),
      body: SafeArea(
        child: StreamBuilder<List<ProjectModel>>(
          stream: vm.projects,
          builder: (context, snapshot) {
            if (snapshot.hasError) {
              return const Center(
                child: Padding(
                  padding: EdgeInsets.all(24),
                  child: Text(
                    'Projects load nahi hue. Internet aur permissions check karein.',
                    textAlign: TextAlign.center,
                  ),
                ),
              );
            }

            if (!snapshot.hasData) {
              return const Center(
                child: CircularProgressIndicator(),
              );
            }

            final projects = snapshot.data!;

            final completed =
                projects.where((p) => p.status == 'Completed').length;

            final inProgress =
                projects.where((p) => p.status == 'In Progress').length;

            final remaining =
                projects.where((p) => p.status == 'Remaining').length;

            final ratio =
                projects.isEmpty ? 0.0 : completed / projects.length;

            final filteredProjects = projects.where((project) {
              final matchesStatus =
                  selectedStatus == 'All' ||
                  project.status == selectedStatus;

              final matchesSearch =
                  project.name.toLowerCase().contains(searchText) ||
                  project.description.toLowerCase().contains(searchText);

              return matchesStatus && matchesSearch;
            }).toList();

            final stats = [
              ('Total Projects', projects.length, Colors.blue),
              ('Completed', completed, Colors.green),
              ('In Progress', inProgress, Colors.orange),
              ('Remaining', remaining, Colors.red),
            ];

            return Center(
              child: ConstrainedBox(
                constraints: const BoxConstraints(maxWidth: 1000),
                child: ListView(
                  keyboardDismissBehavior:
                      ScrollViewKeyboardDismissBehavior.onDrag,
                  padding: const EdgeInsets.fromLTRB(
                    20,
                    20,
                    20,
                    100,
                  ),
                  children: [
                    // Welcome section
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
                    ),

                    const SizedBox(height: 24),

                    // Stats section
                    LayoutBuilder(
                      builder: (context, constraints) {
                        final columns =
                            constraints.maxWidth >= 700 ? 4 : 2;

                        final width =
                            (constraints.maxWidth -
                                    (columns - 1) * 12) /
                                columns;

                        return Wrap(
                          spacing: 12,
                          runSpacing: 12,
                          children: [
                            for (final stat in stats)
                              SizedBox(
                                width: width,
                                child: Card(
                                  margin: EdgeInsets.zero,
                                  child: Padding(
                                    padding:
                                        const EdgeInsets.all(16),
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
                                            fontWeight:
                                                FontWeight.bold,
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

                    // Progress overview
                    Card(
                      child: Padding(
                        padding: const EdgeInsets.all(20),
                        child: Column(
                          crossAxisAlignment:
                              CrossAxisAlignment.start,
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
                              borderRadius:
                                  BorderRadius.circular(8),
                            ),

                            const SizedBox(height: 12),

                            Text(
                              '${(ratio * 100).round()}% completed',
                            ),
                          ],
                        ),
                      ),
                    ),

                    const SizedBox(height: 24),

                    // Projects heading
                    const Text(
                      'My Projects',
                      style: TextStyle(
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
                      ),
                    ),

                    const SizedBox(height: 12),

                    // Search
                    TextField(
                      controller: searchController,
                      decoration: InputDecoration(
                        hintText: 'Search projects...',
                        prefixIcon: const Icon(Icons.search),
                        border: const OutlineInputBorder(),
                        suffixIcon: searchController.text.isEmpty
                            ? null
                            : IconButton(
                                tooltip: 'Clear search',
                                icon: const Icon(Icons.close),
                                onPressed: () {
                                  searchController.clear();

                                  setState(() {
                                    searchText = '';
                                  });
                                },
                              ),
                      ),
                      onChanged: (value) {
                        setState(() {
                          searchText =
                              value.trim().toLowerCase();
                        });
                      },
                    ),

                    const SizedBox(height: 12),

                    // Filters
                    Wrap(
                      spacing: 8,
                      runSpacing: 8,
                      children: [
                        for (final filter in filters)
                          ChoiceChip(
                            label: Text(filter),
                            selected:
                                selectedStatus == filter,
                            onSelected: (_) {
                              setState(() {
                                selectedStatus = filter;
                              });
                            },
                          ),
                      ],
                    ),

                    const SizedBox(height: 12),

                    Text(
                      '${filteredProjects.length} of '
                      '${projects.length} projects',
                    ),

                    const SizedBox(height: 12),

                    // Empty projects
                    if (filteredProjects.isEmpty)
                      Padding(
                        padding: const EdgeInsets.all(24),
                        child: Text(
                          projects.isEmpty
                              ? 'No projects yet. Tap Add Project.'
                              : 'No projects match your search or filter.',
                          textAlign: TextAlign.center,
                        ),
                      ),

                    // Project cards
                    for (final project in filteredProjects)
                      Card(
                        margin:
                            const EdgeInsets.only(bottom: 12),
                        clipBehavior: Clip.antiAlias,
                        child: Padding(
                          padding: const EdgeInsets.all(16),
                          child: Column(
                            crossAxisAlignment:
                                CrossAxisAlignment.start,
                            children: [
                              InkWell(
                                onTap: () {
                                  Navigator.of(context).push(
                                    MaterialPageRoute(
                                      builder: (_) =>
                                          ChangeNotifierProvider
                                              .value(
                                        value: vm,
                                        child:
                                            ProjectDetailsScreen(
                                          project: project,
                                        ),
                                      ),
                                    ),
                                  );
                                },
                                child: Row(
                                  children: [
                                    Expanded(
                                      child: Text(
                                        project.name,
                                        style:
                                            const TextStyle(
                                          fontSize: 16,
                                          fontWeight:
                                              FontWeight.bold,
                                        ),
                                      ),
                                    ),
                                    const Icon(
                                      Icons.chevron_right,
                                    ),
                                  ],
                                ),
                              ),

                              const SizedBox(height: 6),

                              Text(project.description),

                              const SizedBox(height: 12),

                              LinearProgressIndicator(
                                value: project.progress
                                    .clamp(0.0, 1.0),
                              ),

                              const SizedBox(height: 8),

                              Text(
                                '${project.status} • '
                                '${(project.progress * 100).round()}%',
                              ),

                              const SizedBox(height: 4),

                              Text(
                                'Due: '
                                '${MaterialLocalizations.of(context).formatMediumDate(project.dueDate)}',
                              ),

                              const SizedBox(height: 10),

                              // Team button
                              Align(
                                alignment:
                                    Alignment.centerRight,
                                child: TextButton.icon(
                                  icon: const Icon(
                                    Icons.groups_outlined,
                                  ),
                                  label:
                                      const Text('Team'),
                                  onPressed: () {
                                    Navigator.of(context)
                                        .push(
                                      MaterialPageRoute(
                                        builder: (_) =>
                                            TeamScreen(
                                          project: project,
                                        ),
                                      ),
                                    );
                                  },
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                  ],
                ),
              ),
            );
          },
        ),
      ),

      // Add project button
      floatingActionButton:
          FloatingActionButton.extended(
        onPressed:
            auth.isLoading ? null : addProject,
        icon: const Icon(Icons.add),
        label: const Text('Add Project'),
      ),
    );
  }
}