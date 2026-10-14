import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../utils/app_colors.dart';
import '../../viewmodels/team_viewmodel.dart';

class AddMemberScreen extends StatefulWidget {
  final String projectId;

  const AddMemberScreen({
    super.key,
    required this.projectId,
  });

  @override
  State<AddMemberScreen> createState() =>
      _AddMemberScreenState();
}

class _AddMemberScreenState
    extends State<AddMemberScreen> {
  final formKey = GlobalKey<FormState>();

  final emailController = TextEditingController();

  // Email Validation Start
  String? validateEmail(String? value) {
    if (value == null || value.trim().isEmpty) {
      return 'Please enter member email';
    }

    final email = value.trim();

    if (!email.contains('@') ||
        !email.contains('.')) {
      return 'Please enter a valid email';
    }

    return null;
  }
  // Email Validation End

  // Add Member Start
  Future<void> addMember() async {
    if (!formKey.currentState!.validate()) {
      return;
    }

    final teamViewModel =
        context.read<TeamViewModel>();

    final success = await teamViewModel.addMember(
      projectId: widget.projectId,
      email: emailController.text.trim(),
    );

    if (!mounted) return;

    if (success) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text(
            'Team member added successfully.',
          ),
        ),
      );

      Navigator.pop(context);
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(
            teamViewModel.errorMessage ??
                'Unable to add team member.',
          ),
        ),
      );
    }
  }
  // Add Member End

  @override
  void dispose() {
    emailController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final teamViewModel =
        context.watch<TeamViewModel>();

    return Scaffold(
      // AppBar Start
      appBar: AppBar(
        title: const Text(
          'Add Team Member',
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
                maxWidth: 550,
              ),
              child: Form(
                key: formKey,
                child: Column(
                  crossAxisAlignment:
                      CrossAxisAlignment.start,
                  children: [
                    // Icon Start
                    Center(
                      child: Container(
                        width: 85,
                        height: 85,
                        decoration: BoxDecoration(
                          color: AppColors.primary
                              .withValues(
                            alpha: 0.10,
                          ),
                          borderRadius:
                              BorderRadius.circular(22),
                        ),
                        child: const Icon(
                          Icons
                              .person_add_alt_1_rounded,
                          size: 42,
                          color: AppColors.primary,
                        ),
                      ),
                    ),
                    // Icon End

                    const SizedBox(height: 25),

                    // Header Start
                    const Center(
                      child: Text(
                        'Add Team Member',
                        style: TextStyle(
                          fontSize: 26,
                          fontWeight: FontWeight.bold,
                          color: AppColors.black,
                        ),
                      ),
                    ),

                    const SizedBox(height: 8),

                    const Center(
                      child: Text(
                        'Enter the email address of a registered Projexa user.',
                        textAlign: TextAlign.center,
                        style: TextStyle(
                          color: AppColors.grey,
                          height: 1.5,
                        ),
                      ),
                    ),
                    // Header End

                    const SizedBox(height: 35),

                    // Email Start
                    TextFormField(
                      controller: emailController,
                      keyboardType:
                          TextInputType.emailAddress,
                      textInputAction:
                          TextInputAction.done,
                      enabled:
                          !teamViewModel.isAdding,
                      validator: validateEmail,
                      onFieldSubmitted: (_) {
                        if (!teamViewModel.isAdding) {
                          addMember();
                        }
                      },
                      decoration: const InputDecoration(
                        labelText: 'Member Email',
                        hintText:
                            'example@gmail.com',
                        prefixIcon: Icon(
                          Icons.email_outlined,
                        ),
                        border:
                            OutlineInputBorder(),
                      ),
                    ),
                    // Email End

                    const SizedBox(height: 15),

                    // Information Start
                    Container(
                      width: double.infinity,
                      padding: const EdgeInsets.all(15),
                      decoration: BoxDecoration(
                        color: AppColors.primary
                            .withValues(
                          alpha: 0.06,
                        ),
                        borderRadius:
                            BorderRadius.circular(12),
                      ),
                      child: const Row(
                        crossAxisAlignment:
                            CrossAxisAlignment.start,
                        children: [
                          Icon(
                            Icons.info_outline_rounded,
                            color: AppColors.primary,
                            size: 21,
                          ),
                          SizedBox(width: 10),
                          Expanded(
                            child: Text(
                              'The user must already have a Projexa account. You never need their password.',
                              style: TextStyle(
                                color: AppColors.grey,
                                height: 1.4,
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                    // Information End

                    const SizedBox(height: 30),

                    // Add Button Start
                    SizedBox(
                      width: double.infinity,
                      height: 52,
                      child: FilledButton.icon(
                        onPressed:
                            teamViewModel.isAdding
                                ? null
                                : addMember,
                        icon: teamViewModel.isAdding
                            ? const SizedBox(
                                width: 20,
                                height: 20,
                                child:
                                    CircularProgressIndicator(
                                  strokeWidth: 2,
                                ),
                              )
                            : const Icon(
                                Icons
                                    .person_add_alt_1_rounded,
                              ),
                        label: Text(
                          teamViewModel.isAdding
                              ? 'Adding Member...'
                              : 'Add Member',
                        ),
                      ),
                    ),
                    // Add Button End
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