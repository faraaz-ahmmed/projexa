import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../models/project_model.dart';
import '../../viewmodels/project_viewmodel.dart';

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
  // Progress state section start
  late double progress;
  late double savedProgress;

  @override
  void initState() {
    super.initState();
    progress = widget.project.progress.clamp(0.0, 1.0);
    savedProgress = progress;
  }
  // Progress state section end

  // Save progress section start
  Future<void> saveProgress() async {
    final vm = context.read<ProjectViewModel>();

    final success = await vm.updateProgress(
      widget.project.id,
      progress,
    );

    if (!mounted) return;

    if (success) {
      setState(() => savedProgress = progress);
    }

    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(
          success ? 'Progress updated' : vm.error ?? 'Update failed',
        ),
      ),
    );
  }
  // Save progress section end

  // Delete confirmation section start
  Future<void> deleteProject() async {
    final vm = context.read<ProjectViewModel>();

    final confirmed = await showDialog<bool>(
      context: context,
      builder: (dialogContext) => AlertDialog(
        title: const Text('Delete project?'),
        content: const Text('This project will be permanently deleted.'),
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

    final success = await vm.deleteProject(widget.project.id);

    if (!mounted) return;

    if (success) {
      Navigator.of(context).pop();
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text(vm.error ?? 'Delete failed')),
      );
    }
  }
  // Delete confirmation section end

  @override
  Widget build(BuildContext context) {
    final vm = context.watch<ProjectViewModel>();
    final project = widget.project;
    final isOwner =
        FirebaseAuth.instance.currentUser?.uid == project.ownerId;

    final status = savedProgress == 1.0
        ? 'Completed'
        : savedProgress == 0.0
            ? 'Remaining'
            : 'In Progress';

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
          child: Center(
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
                  Text('Status: $status'),
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
                    'Progress: ${(progress * 100).round()}%',
                    style: const TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 16),
                  LinearProgressIndicator(
                    value: progress,
                    minHeight: 10,
                    color: Colors.green,
                    backgroundColor: const Color(0xffE8EDF5),
                    borderRadius: BorderRadius.circular(8),
                  ),
                  // Progress section end

                  // Owner controls section start
                  if (isOwner) ...[
                    Slider(
                      value: progress,
                      divisions: 20,
                      label: '${(progress * 100).round()}%',
                      onChanged: vm.isSaving
                          ? null
                          : (value) => setState(() => progress = value),
                    ),
                    const Text(
                      '0% = Remaining • 1–99% = In Progress • 100% = Completed',
                      textAlign: TextAlign.center,
                    ),
                    const SizedBox(height: 24),
                    FilledButton(
                      onPressed: vm.isSaving || progress == savedProgress
                          ? null
                          : saveProgress,
                      child: Text(
                        vm.isSaving ? 'Please wait...' : 'Save Progress',
                      ),
                    ),
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
                  // Owner controls section end
                ],
              ),
            ),
          ),
        ),
        // Body end
      ),
    );
  }
}