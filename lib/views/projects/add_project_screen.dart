import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../viewmodels/project_viewmodel.dart';

class AddProjectScreen extends StatefulWidget {
  const AddProjectScreen({super.key});

  @override
  State<AddProjectScreen> createState() => _AddProjectScreenState();
}

class _AddProjectScreenState extends State<AddProjectScreen> {
  // Form state section start
  final formKey = GlobalKey<FormState>();
  final nameController = TextEditingController();
  final descriptionController = TextEditingController();

  DateTime? dueDate;

  @override
  void dispose() {
    nameController.dispose();
    descriptionController.dispose();
    super.dispose();
  }
  // Form state section end

  // Date selection section start
  Future<void> selectDate() async {
    final today = DateUtils.dateOnly(DateTime.now());

    final selected = await showDatePicker(
      context: context,
      initialDate: dueDate ?? today,
      firstDate: today,
      lastDate: DateTime(today.year + 10),
    );

    if (!mounted || selected == null) return;

    setState(() => dueDate = selected);
  }
  // Date selection section end

  // Save section start
  Future<void> saveProject() async {
    final vm = context.read<ProjectViewModel>();

    if (vm.isSaving) return;
    if (!formKey.currentState!.validate()) return;

    if (dueDate == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Please select a due date')),
      );
      return;
    }

    FocusScope.of(context).unfocus();

    final success = await vm.addProject(
      name: nameController.text,
      description: descriptionController.text,
      dueDate: dueDate!,
    );

    if (!mounted) return;

    if (success) {
      Navigator.of(context).pop(true);
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text(vm.error ?? 'Could not save project')),
      );
    }
  }
  // Save section end

  @override
  Widget build(BuildContext context) {
    final vm = context.watch<ProjectViewModel>();

    return PopScope(
      canPop: !vm.isSaving,
      child: Scaffold(
        // AppBar section start
        appBar: AppBar(
          title: const Text('Add Project'),
          automaticallyImplyLeading: !vm.isSaving,
        ),
        // AppBar section end

        // Body start
        body: SafeArea(
          child: Center(
            child: SingleChildScrollView(
              padding: const EdgeInsets.all(24),
              child: ConstrainedBox(
                constraints: const BoxConstraints(maxWidth: 500),
                child: Form(
                  key: formKey,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    children: [
                      // Project details section start
                      TextFormField(
                        controller: nameController,
                        enabled: !vm.isSaving,
                        textInputAction: TextInputAction.next,
                        decoration: const InputDecoration(
                          labelText: 'Project name',
                          prefixIcon: Icon(Icons.folder_outlined),
                          border: OutlineInputBorder(),
                        ),
                        validator: (value) {
                          if (value == null || value.trim().isEmpty) {
                            return 'Enter project name';
                          }
                          return null;
                        },
                      ),
                      const SizedBox(height: 16),
                      TextFormField(
                        controller: descriptionController,
                        enabled: !vm.isSaving,
                        minLines: 3,
                        maxLines: 5,
                        decoration: const InputDecoration(
                          labelText: 'Description',
                          border: OutlineInputBorder(),
                        ),
                        validator: (value) {
                          if (value == null || value.trim().isEmpty) {
                            return 'Enter project description';
                          }
                          return null;
                        },
                      ),
                      const SizedBox(height: 16),
                      // Project details section end

                      // Due date section start
                      OutlinedButton.icon(
                        onPressed: vm.isSaving ? null : selectDate,
                        icon: const Icon(Icons.calendar_month),
                        label: Text(
                          dueDate == null
                              ? 'Select due date'
                              : MaterialLocalizations.of(context)
                                  .formatMediumDate(dueDate!),
                        ),
                      ),
                      const SizedBox(height: 24),
                      // Due date section end

                      // Save button section start
                      FilledButton(
                        onPressed: vm.isSaving ? null : saveProject,
                        style: FilledButton.styleFrom(
                          padding: const EdgeInsets.symmetric(vertical: 16),
                        ),
                        child: Text(
                          vm.isSaving ? 'Saving...' : 'Create Project',
                        ),
                      ),
                      // Save button section end
                    ],
                  ),
                ),
              ),
            ),
          ),
        ),
        // Body end
      ),
    );
  }
}