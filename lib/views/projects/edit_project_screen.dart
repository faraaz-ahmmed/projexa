import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../models/project_model.dart';
import '../../viewmodels/project_viewmodel.dart';

class EditProjectScreen extends StatefulWidget {
  final ProjectModel project;

  const EditProjectScreen({
    super.key,
    required this.project,
  });

  @override
  State<EditProjectScreen> createState() => _EditProjectScreenState();
}

class _EditProjectScreenState extends State<EditProjectScreen> {
  // Form state section start
  final formKey = GlobalKey<FormState>();

  late final TextEditingController nameController;
  late final TextEditingController descriptionController;
  late DateTime dueDate;

  @override
  void initState() {
    super.initState();

    nameController = TextEditingController(text: widget.project.name);
    descriptionController =
        TextEditingController(text: widget.project.description);
    dueDate = DateUtils.dateOnly(widget.project.dueDate);
  }

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
    final firstDate = dueDate.isBefore(today) ? dueDate : today;
    final lastYear =
        dueDate.year > today.year ? dueDate.year + 10 : today.year + 10;

    final selected = await showDatePicker(
      context: context,
      initialDate: dueDate,
      firstDate: firstDate,
      lastDate: DateTime(lastYear, 12, 31),
    );

    if (!mounted || selected == null) return;

    setState(() => dueDate = selected);
  }
  // Date selection section end

  // Project save section start
  Future<void> saveProject() async {
    final vm = context.read<ProjectViewModel>();

    if (vm.isSaving) return;
    if (!formKey.currentState!.validate()) return;

    FocusScope.of(context).unfocus();

    final success = await vm.editProject(
      id: widget.project.id,
      name: nameController.text,
      description: descriptionController.text,
      dueDate: dueDate,
    );

    if (!mounted) return;

    if (success) {
      Navigator.of(context).pop(true);
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text(vm.error ?? 'Update failed')),
      );
    }
  }
  // Project save section end

  @override
  Widget build(BuildContext context) {
    final vm = context.watch<ProjectViewModel>();

    return PopScope(
      canPop: !vm.isSaving,
      child: Scaffold(
        // AppBar section start
        appBar: AppBar(
          title: const Text('Edit Project'),
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
                          MaterialLocalizations.of(context)
                              .formatMediumDate(dueDate),
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
                          vm.isSaving ? 'Saving...' : 'Save Changes',
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