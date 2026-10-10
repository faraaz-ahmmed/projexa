import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../models/project_model.dart';
import '../../models/task_model.dart';
import '../../viewmodels/task_viewmodel.dart';

class TasksScreen extends StatelessWidget {
  final ProjectModel project;

  const TasksScreen({super.key, required this.project});

  @override
  Widget build(BuildContext context) {
    // Provider section start
    return ChangeNotifierProvider(
      create: (_) => TaskViewModel(project.id),
      child: _TasksContent(project: project),
    );
    // Provider section end
  }
}

class _TasksContent extends StatefulWidget {
  final ProjectModel project;

  const _TasksContent({required this.project});

  @override
  State<_TasksContent> createState() => _TasksContentState();
}

class _TasksContentState extends State<_TasksContent> {
  // Form section start
  final formKey = GlobalKey<FormState>();
  final titleController = TextEditingController();

  @override
  void dispose() {
    titleController.dispose();
    super.dispose();
  }
  // Form section end

  // Error message section start
  void showError(String? error) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text(error ?? 'Action failed')),
    );
  }
  // Error message section end

  // Task create section start
  Future<void> addTask() async {
    final vm = context.read<TaskViewModel>();

    if (vm.isBusy) return;
    if (!formKey.currentState!.validate()) return;

    FocusScope.of(context).unfocus();

    final success = await vm.addTask(titleController.text);

    if (!mounted) return;

    if (success) {
      titleController.clear();
      formKey.currentState!.reset();
    } else {
      showError(vm.error);
    }
  }
  // Task create section end

  // Task edit section start
  Future<void> editTask(TaskModel task) async {
    final vm = context.read<TaskViewModel>();
    final editFormKey = GlobalKey<FormState>();
    var title = task.title;

    final newTitle = await showDialog<String>(
      context: context,
      builder: (dialogContext) => AlertDialog(
        title: const Text('Edit Task'),
        content: Form(
          key: editFormKey,
          child: TextFormField(
            initialValue: task.title,
            autofocus: true,
            decoration: const InputDecoration(
              labelText: 'Task title',
              border: OutlineInputBorder(),
            ),
            onChanged: (value) => title = value,
            validator: (value) {
              if (value == null || value.trim().isEmpty) {
                return 'Enter task title';
              }
              return null;
            },
          ),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(dialogContext),
            child: const Text('Cancel'),
          ),
          FilledButton(
            onPressed: () {
              if (!editFormKey.currentState!.validate()) return;
              Navigator.pop(dialogContext, title.trim());
            },
            child: const Text('Save'),
          ),
        ],
      ),
    );

    if (!mounted || newTitle == null || newTitle == task.title) return;

    final success = await vm.editTask(task.id, newTitle);

    if (!mounted) return;

    if (success) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Task updated')),
      );
    } else {
      showError(vm.error);
    }
  }
  // Task edit section end

  // Task delete section start
  Future<void> deleteTask(TaskModel task) async {
    final vm = context.read<TaskViewModel>();

    final confirmed = await showDialog<bool>(
      context: context,
      builder: (dialogContext) => AlertDialog(
        title: const Text('Delete task?'),
        content: Text(task.title),
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

    final success = await vm.deleteTask(task.id);

    if (!mounted) return;
    if (!success) showError(vm.error);
  }
  // Task delete section end

  @override
  Widget build(BuildContext context) {
    final vm = context.watch<TaskViewModel>();
    final isOwner =
        FirebaseAuth.instance.currentUser?.uid == widget.project.ownerId;

    return PopScope(
      canPop: !vm.isBusy,
      child: Scaffold(
        // AppBar section start
        appBar: AppBar(
          title: const Text('Tasks'),
          automaticallyImplyLeading: !vm.isBusy,
        ),
        // AppBar section end

        // Body start
        body: SafeArea(
          child: Center(
            child: ConstrainedBox(
              constraints: const BoxConstraints(maxWidth: 700),
              child: Column(
                children: [
                  // Project title section start
                  Padding(
                    padding: const EdgeInsets.all(20),
                    child: Text(
                      widget.project.name,
                      style: const TextStyle(
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                  // Project title section end

                  // Add task section start
                  if (isOwner)
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 20),
                      child: Form(
                        key: formKey,
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.stretch,
                          children: [
                            TextFormField(
                              controller: titleController,
                              enabled: !vm.isBusy,
                              decoration: const InputDecoration(
                                labelText: 'Task title',
                                border: OutlineInputBorder(),
                              ),
                              validator: (value) {
                                if (value == null || value.trim().isEmpty) {
                                  return 'Enter task title';
                                }
                                return null;
                              },
                              onFieldSubmitted: (_) => addTask(),
                            ),
                            const SizedBox(height: 12),
                            FilledButton.icon(
                              onPressed: vm.isBusy ? null : addTask,
                              icon: const Icon(Icons.add),
                              label: Text(
                                vm.isBusy ? 'Please wait...' : 'Add Task',
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  const SizedBox(height: 16),
                  // Add task section end

                  // Tasks list section start
                  Expanded(
                    child: StreamBuilder<List<TaskModel>>(
                      stream: vm.tasks,
                      builder: (context, snapshot) {
                        if (snapshot.hasError) {
                          return const Center(
                            child: Text('Tasks load nahi hue.'),
                          );
                        }

                        if (!snapshot.hasData) {
                          return const Center(
                            child: CircularProgressIndicator(),
                          );
                        }

                        final tasks = snapshot.data!;

                        if (tasks.isEmpty) {
                          return const Center(child: Text('No tasks yet'));
                        }

                        final completed =
                            tasks.where((task) => task.isCompleted).length;

                        return ListView(
                          padding: const EdgeInsets.all(20),
                          children: [
                            Text('$completed of ${tasks.length} completed'),
                            const SizedBox(height: 12),
                            for (final task in tasks)
                              Card(
                                child: ListTile(
                                  leading: Checkbox(
                                    value: task.isCompleted,
                                    onChanged: !isOwner || vm.isBusy
                                        ? null
                                        : (value) async {
                                            final success =
                                                await vm.setCompleted(
                                              task.id,
                                              value ?? false,
                                            );

                                            if (!mounted) return;
                                            if (!success) showError(vm.error);
                                          },
                                  ),
                                  title: Text(
                                    task.title,
                                    style: TextStyle(
                                      decoration: task.isCompleted
                                          ? TextDecoration.lineThrough
                                          : null,
                                    ),
                                  ),

                                  // Edit aur delete controls section start
                                  trailing: isOwner
                                      ? PopupMenuButton<String>(
                                          enabled: !vm.isBusy,
                                          icon: const Icon(Icons.edit_note),
                                          onSelected: (value) {
                                            if (value == 'edit') {
                                              editTask(task);
                                            } else {
                                              deleteTask(task);
                                            }
                                          },
                                          itemBuilder: (_) => const [
                                            PopupMenuItem(
                                              value: 'edit',
                                              child: Text('Edit'),
                                            ),
                                            PopupMenuItem(
                                              value: 'delete',
                                              child: Text('Delete'),
                                            ),
                                          ],
                                        )
                                      : null,
                                  // Edit aur delete controls section end
                                ),
                              ),
                          ],
                        );
                      },
                    ),
                  ),
                  // Tasks list section end
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