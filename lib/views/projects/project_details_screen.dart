import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../models/project_model.dart';
import '../../viewmodels/project_viewmodel.dart';
import '../tasks/tasks_screen.dart';

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

class _ProjectDetailsScreenState extends State<ProjectDetailsScreen> {
  // Live project section start
  late final Stream<DocumentSnapshot<Map<String, dynamic>>> projectStream;

  @override
  void initState() {
    super.initState();

    projectStream = FirebaseFirestore.instance
        .collection('projects')
        .doc(widget.project.id)
        .snapshots();
  }
  // Live project section end

  // Project delete section start
  Future<void> deleteProject() async {
    final vm = context.read<ProjectViewModel>();

    final confirmed = await showDialog<bool>(
      context: context,
      builder: (dialogContext) => AlertDialog(
        title: const Text('Delete project?'),
        content: const Text(
          'Please delete all tasks before deleting this project.',
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(dialogContext, false),
            child: const Text('Cancel'),
          ),
          TextButton(
            onPressed: () => Navigator.pop(dialogContext, true),
            child: const Text('Delete'),
          ),
        ],
      ),
    );

    if (!mounted || confirmed != true) return;

    try {
      final tasks = await FirebaseFirestore.instance
          .collection('projects')
          .doc(widget.project.id)
          .collection('tasks')
          .limit(1)
          .get(const GetOptions(source: Source.server));

      if (!mounted) return;

      if (tasks.docs.isNotEmpty) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('Open Tasks and delete the tasks first.'),
          ),
        );
        return;
      }

      final success = await vm.deleteProject(widget.project.id);

      if (!mounted) return;

      if (success) {
        Navigator.of(context).pop();
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text(vm.error ?? 'Delete failed')),
        );
      }
    } catch (_) {
      if (!mounted) return;

      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Could not delete project. Try again.')),
      );
    }
  }
  // Project delete section end

  @override
  Widget build(BuildContext context) {
    final vm = context.watch<ProjectViewModel>();

    return PopScope(
      canPop: !vm.isSaving,
      child: Scaffold(
        // AppBar section start
        appBar: AppBar(
          title: const Text('Project Details'),
          automaticallyImplyLeading: !vm.isSaving,
        ),
        // AppBar section end

        // Body start
        body: SafeArea(
          child: StreamBuilder<DocumentSnapshot<Map<String, dynamic>>>(
            stream: projectStream,
            builder: (context, snapshot) {
              // Loading aur error section start
              if (snapshot.hasError) {
                return const Center(
                  child: Text('Project load nahi hua.'),
                );
              }

              if (!snapshot.hasData) {
                return const Center(child: CircularProgressIndicator());
              }

              if (!snapshot.data!.exists) {
                return const Center(child: Text('Project deleted'));
              }
              // Loading aur error section end

              final project = ProjectModel.fromDoc(snapshot.data!);
              final isOwner =
                  FirebaseAuth.instance.currentUser?.uid == project.ownerId;

              return Center(
                child: ConstrainedBox(
                  constraints: const BoxConstraints(maxWidth: 600),
                  child: ListView(
                    padding: const EdgeInsets.all(24),
                    children: [
                      // Project information section start
                      Text(
                        project.name,
                        style: const TextStyle(
                          fontSize: 26,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      const SizedBox(height: 12),
                      Text(project.description),
                      const SizedBox(height: 20),
                      Text('Status: ${project.status}'),
                      const SizedBox(height: 8),
                      Text(
                        'Due: ${MaterialLocalizations.of(context).formatMediumDate(project.dueDate)}',
                      ),
                      const SizedBox(height: 8),
                      Text('Team members: ${project.memberIds.length}'),
                      const SizedBox(height: 32),
                      // Project information section end

                      // Progress section start
                      Text(
                        'Progress: ${(project.progress * 100).round()}%',
                        style: const TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      const SizedBox(height: 16),
                      LinearProgressIndicator(
                        value: project.progress.clamp(0.0, 1.0),
                        minHeight: 10,
                        color: Colors.green,
                        backgroundColor: const Color(0xffE8EDF5),
                        borderRadius: BorderRadius.circular(8),
                      ),
                      const SizedBox(height: 12),
                      const Text(
                        'Progress updates automatically when tasks change.',
                      ),
                      const SizedBox(height: 24),
                      // Progress section end

                      // Open tasks section start
                      FilledButton.icon(
                        onPressed: vm.isSaving
                            ? null
                            : () {
                                Navigator.of(context).push(
                                  MaterialPageRoute(
                                    builder: (_) =>
                                        TasksScreen(project: project),
                                  ),
                                );
                              },
                        icon: const Icon(Icons.checklist),
                        label: const Text('Open Tasks'),
                      ),
                      // Open tasks section end

                      // Delete button section start
                      if (isOwner) ...[
                        const SizedBox(height: 16),
                        OutlinedButton.icon(
                          onPressed: vm.isSaving ? null : deleteProject,
                          icon: const Icon(Icons.delete_outline),
                          label: const Text('Delete Project'),
                          style: OutlinedButton.styleFrom(
                            foregroundColor: Colors.red,
                          ),
                        ),
                      ],
                      // Delete button section end
                    ],
                  ),
                ),
              );
            },
          ),
        ),
        // Body end
      ),
    );
  }
}