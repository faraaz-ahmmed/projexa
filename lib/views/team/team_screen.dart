import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../models/project_model.dart';
import '../../models/team_member_model.dart';
import '../../viewmodels/team_viewmodel.dart';

class TeamScreen extends StatelessWidget {
  final ProjectModel project;

  const TeamScreen({
    super.key,
    required this.project,
  });

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (_) => TeamViewModel(),
      child: _TeamContent(project: project),
    );
  }
}

class _TeamContent extends StatelessWidget {
  final ProjectModel project;

  const _TeamContent({
    required this.project,
  });

  @override
  Widget build(BuildContext context) {
    final vm = context.watch<TeamViewModel>();

    return Scaffold(
      appBar: AppBar(
        title: Text('${project.name} Team'),
      ),
      body: StreamBuilder<List<TeamMemberModel>>(
        stream: vm.members(project.id),
        builder: (context, snapshot) {
          if (snapshot.hasError) {
            return const Center(
              child: Text('Unable to load team members'),
            );
          }

          if (!snapshot.hasData) {
            return const Center(
              child: CircularProgressIndicator(),
            );
          }

          final members = snapshot.data!;

          if (members.isEmpty) {
            return const Center(
              child: Text('No team members yet'),
            );
          }

          return ListView.separated(
            padding: const EdgeInsets.all(16),
            itemCount: members.length,
            separatorBuilder: (_, _) => const SizedBox(height: 8),
            itemBuilder: (context, index) {
              final member = members[index];

              return Card(
                child: ListTile(
                  leading: CircleAvatar(
                    child: Text(
                      member.name.isEmpty
                          ? '?'
                          : member.name[0].toUpperCase(),
                    ),
                  ),
                  title: Text(member.name),
                  subtitle: Text(
                    '${member.email}\n${member.role}',
                  ),
                  isThreeLine: true,
                  trailing: IconButton(
                    icon: const Icon(Icons.delete_outline),
                    onPressed: () async {
                      final success =
                          await vm.deleteMember(member.id);

                      if (!context.mounted) return;

                      if (!success) {
                        ScaffoldMessenger.of(context).showSnackBar(
                          SnackBar(
                            content: Text(
                              vm.error ?? 'Unable to delete member',
                            ),
                          ),
                        );
                      }
                    },
                  ),
                ),
              );
            },
          );
        },
      ),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: () => _showAddMember(
          context,
          project.id,
        ),
        icon: const Icon(Icons.person_add_alt_1),
        label: const Text('Add Member'),
      ),
    );
  }

  void _showAddMember(
    BuildContext context,
    String projectId,
  ) {
    final vm = context.read<TeamViewModel>();

    final nameController = TextEditingController();
    final emailController = TextEditingController();

    String role = 'Member';

    showDialog(
      context: context,
      builder: (dialogContext) {
        return StatefulBuilder(
          builder: (context, setState) {
            return AlertDialog(
              title: const Text('Add Team Member'),
              content: SingleChildScrollView(
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    TextField(
                      controller: nameController,
                      decoration: const InputDecoration(
                        labelText: 'Name',
                      ),
                    ),
                    const SizedBox(height: 12),
                    TextField(
                      controller: emailController,
                      keyboardType: TextInputType.emailAddress,
                      decoration: const InputDecoration(
                        labelText: 'Email',
                      ),
                    ),
                    const SizedBox(height: 12),
                    DropdownButtonFormField<String>(
                      initialValue: role,
                      decoration: const InputDecoration(
                        labelText: 'Role',
                      ),
                      items: const [
                        DropdownMenuItem(
                          value: 'Member',
                          child: Text('Member'),
                        ),
                        DropdownMenuItem(
                          value: 'Developer',
                          child: Text('Developer'),
                        ),
                        DropdownMenuItem(
                          value: 'Designer',
                          child: Text('Designer'),
                        ),
                        DropdownMenuItem(
                          value: 'Manager',
                          child: Text('Manager'),
                        ),
                      ],
                      onChanged: (value) {
                        if (value != null) {
                          setState(() {
                            role = value;
                          });
                        }
                      },
                    ),
                  ],
                ),
              ),
              actions: [
                TextButton(
                  onPressed: () {
                    Navigator.pop(dialogContext);
                  },
                  child: const Text('Cancel'),
                ),
                FilledButton(
                  onPressed: vm.isLoading
                      ? null
                      : () async {
                          if (nameController.text.trim().isEmpty ||
                              emailController.text.trim().isEmpty) {
                            return;
                          }

                          final success = await vm.addMember(
                            projectId: projectId,
                            name: nameController.text,
                            email: emailController.text,
                            role: role,
                          );

                          if (!dialogContext.mounted) return;

                          if (success) {
                            Navigator.pop(dialogContext);
                          } else {
                            ScaffoldMessenger.of(context).showSnackBar(
                              SnackBar(
                                content: Text(
                                  vm.error ?? 'Unable to add member',
                                ),
                              ),
                            );
                          }
                        },
                  child: vm.isLoading
                      ? const SizedBox(
                          width: 18,
                          height: 18,
                          child: CircularProgressIndicator(
                            strokeWidth: 2,
                          ),
                        )
                      : const Text('Add'),
                ),
              ],
            );
          },
        );
      },
    );
  }
}