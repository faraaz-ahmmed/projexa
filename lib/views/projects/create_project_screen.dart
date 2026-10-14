import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../utils/app_colors.dart';
import '../../viewmodels/project_viewmodel.dart';

class CreateProjectScreen extends StatefulWidget {
  const CreateProjectScreen({super.key});

  @override
  State<CreateProjectScreen> createState() =>
      _CreateProjectScreenState();
}

class _CreateProjectScreenState
    extends State<CreateProjectScreen> {
  final formKey = GlobalKey<FormState>();

  final nameController = TextEditingController();
  final descriptionController = TextEditingController();

  DateTime? selectedDueDate;

  // Select Date Start
  Future<void> selectDueDate() async {
    final now = DateTime.now();

    final date = await showDatePicker(
      context: context,
      initialDate: now.add(
        const Duration(days: 1),
      ),
      firstDate: now,
      lastDate: DateTime(
        now.year + 5,
      ),
    );

    if (date == null) {
      return;
    }

    setState(() {
      selectedDueDate = date;
    });
  }
  // Select Date End

  // Create Project Start
  Future<void> createProject() async {
    if (!formKey.currentState!.validate()) {
      return;
    }

    if (selectedDueDate == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text(
            'Please select a due date.',
          ),
        ),
      );
      return;
    }

    final projectViewModel =
        context.read<ProjectViewModel>();

    final success = await projectViewModel.createProject(
      name: nameController.text,
      description: descriptionController.text,
      dueDate: selectedDueDate!,
    );

    if (!mounted) return;

    if (success) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text(
            'Project created successfully.',
          ),
        ),
      );

      Navigator.pop(context);
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(
            projectViewModel.errorMessage ??
                'Unable to create project.',
          ),
        ),
      );
    }
  }
  // Create Project End

  // Date Text Start
  String get dueDateText {
    if (selectedDueDate == null) {
      return 'Select Due Date';
    }

    final day =
        selectedDueDate!.day.toString().padLeft(2, '0');

    final month =
        selectedDueDate!.month.toString().padLeft(2, '0');

    final year = selectedDueDate!.year;

    return '$day/$month/$year';
  }
  // Date Text End

  @override
  void dispose() {
    nameController.dispose();
    descriptionController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final projectViewModel =
        context.watch<ProjectViewModel>();

    return Scaffold(
      // AppBar Start
      appBar: AppBar(
        title: const Text(
          'Create Project',
          style: TextStyle(
            fontWeight: FontWeight.bold,
          ),
        ),
      ),
      // AppBar End

      // Body Start
      body: SafeArea(
        child: Center(
          child: SingleChildScrollView(
            padding: const EdgeInsets.all(20),
            child: ConstrainedBox(
              constraints: const BoxConstraints(
                maxWidth: 600,
              ),
              child: Form(
                key: formKey,
                child: Column(
                  crossAxisAlignment:
                      CrossAxisAlignment.start,
                  children: [
                    // Header Start
                    const Text(
                      'New Project',
                      style: TextStyle(
                        fontSize: 28,
                        fontWeight: FontWeight.bold,
                        color: AppColors.black,
                      ),
                    ),

                    const SizedBox(height: 8),

                    const Text(
                      'Enter your project details to get started.',
                      style: TextStyle(
                        fontSize: 14,
                        color: AppColors.grey,
                      ),
                    ),
                    // Header End

                    const SizedBox(height: 30),

                    // Project Name Start
                    TextFormField(
                      controller: nameController,
                      textInputAction:
                          TextInputAction.next,
                      decoration: const InputDecoration(
                        labelText: 'Project Name',
                        hintText:
                            'Enter project name',
                        prefixIcon: Icon(
                          Icons.folder_outlined,
                        ),
                        border:
                            OutlineInputBorder(),
                      ),
                      validator: (value) {
                        if (value == null ||
                            value.trim().isEmpty) {
                          return 'Please enter project name';
                        }

                        if (value.trim().length < 3) {
                          return 'Project name must be at least 3 characters';
                        }

                        return null;
                      },
                    ),
                    // Project Name End

                    const SizedBox(height: 20),

                    // Description Start
                    TextFormField(
                      controller:
                          descriptionController,
                      minLines: 4,
                      maxLines: 6,
                      decoration: const InputDecoration(
                        labelText:
                            'Project Description',
                        hintText:
                            'Describe your project',
                        alignLabelWithHint: true,
                        border:
                            OutlineInputBorder(),
                      ),
                      validator: (value) {
                        if (value == null ||
                            value.trim().isEmpty) {
                          return 'Please enter project description';
                        }

                        return null;
                      },
                    ),
                    // Description End

                    const SizedBox(height: 20),

                    // Due Date Start
                    InkWell(
                      onTap:
                          projectViewModel.isCreating
                              ? null
                              : selectDueDate,
                      borderRadius:
                          BorderRadius.circular(12),
                      child: InputDecorator(
                        decoration:
                            const InputDecoration(
                          labelText: 'Due Date',
                          prefixIcon: Icon(
                            Icons
                                .calendar_month_outlined,
                          ),
                          suffixIcon: Icon(
                            Icons
                                .arrow_drop_down_rounded,
                          ),
                          border:
                              OutlineInputBorder(),
                        ),
                        child: Text(
                          dueDateText,
                          style: TextStyle(
                            color:
                                selectedDueDate == null
                                    ? AppColors.grey
                                    : AppColors.black,
                          ),
                        ),
                      ),
                    ),
                    // Due Date End

                    const SizedBox(height: 30),

                    // Create Button Start
                    SizedBox(
                      width: double.infinity,
                      height: 52,
                      child: FilledButton.icon(
                        onPressed:
                            projectViewModel.isCreating
                                ? null
                                : createProject,
                        icon:
                            projectViewModel.isCreating
                                ? const SizedBox(
                                    width: 20,
                                    height: 20,
                                    child:
                                        CircularProgressIndicator(
                                      strokeWidth: 2,
                                    ),
                                  )
                                : const Icon(
                                    Icons.add_rounded,
                                  ),
                        label: Text(
                          projectViewModel.isCreating
                              ? 'Creating...'
                              : 'Create Project',
                        ),
                      ),
                    ),
                    // Create Button End
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
      // Body End
    );
  }
}