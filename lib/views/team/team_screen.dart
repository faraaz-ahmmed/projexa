import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../models/team_member_model.dart';
import '../../viewmodels/team_viewmodel.dart';

class TeamScreen extends StatelessWidget {
  const TeamScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (_) => TeamViewModel(),
      child: const _TeamContent(),
    );
  }
}

class _TeamContent extends StatelessWidget {
  const _TeamContent();

  @override
  Widget build(BuildContext context) {
    final vm = context.watch<TeamViewModel>();

    return Scaffold(
      appBar: AppBar(
        title: const Text('Team'),
      ),
      body: StreamBuilder<List<TeamMemberModel>>(
        stream: vm.members,
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
                    onPressed: () => vm.deleteMember(member.id),
                  ),
                ),
              );
            },
          );
        },
      ),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: () => _showAddMember(context),
        icon: const Icon(Icons.person_add_alt_1),
        label: const Text('Add Member'),
      ),
    );
  }

  void _showAddMember(BuildContext context) {
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
                          setState(() => role = value);
                        }
                      },
                    ),
                  ],
                ),
              ),
              actions: [
                TextButton(
                  onPressed: () => Navigator.pop(dialogContext),
                  child: const Text('Cancel'),
                ),
                FilledButton(
                  onPressed: () async {
                    if (nameController.text.trim().isEmpty ||
                        emailController.text.trim().isEmpty) {
                      return;
                    }

                    final success = await vm.addMember(
                      name: nameController.text,
                      email: emailController.text,
                      role: role,
                    );

                    if (!dialogContext.mounted) return;

                    if (success) {
                      Navigator.pop(dialogContext);
                    }
                  },
                  child: const Text('Add'),
                ),
              ],
            );
          },
        );
      },
    );
  }
}