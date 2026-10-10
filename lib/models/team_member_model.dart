class TeamMemberModel {
  final String id;
  final String name;
  final String email;
  final String role;

  TeamMemberModel({
    required this.id,
    required this.name,
    required this.email,
    required this.role,
  });

  factory TeamMemberModel.fromMap(
    String id,
    Map<String, dynamic> data,
  ) {
    return TeamMemberModel(
      id: id,
      name: data['name'] ?? '',
      email: data['email'] ?? '',
      role: data['role'] ?? 'Member',
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'name': name,
      'email': email,
      'role': role,
    };
  }
}