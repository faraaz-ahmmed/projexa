import 'package:cloud_firestore/cloud_firestore.dart';

class ProjectModel {
  // Project fields section start
  final String id;
  final String name;
  final String description;
  final String ownerId;
  final List<String> memberIds;
  final String status;
  final double progress;
  final DateTime dueDate;
  // Project fields section end

  // Constructor section start
  const ProjectModel({
    required this.id,
    required this.name,
    required this.description,
    required this.ownerId,
    required this.memberIds,
    required this.status,
    required this.progress,
    required this.dueDate,
  });
  // Constructor section end

  // Firestore se model banane ka section start
  factory ProjectModel.fromDoc(
    DocumentSnapshot<Map<String, dynamic>> doc,
  ) {
    final data = doc.data()!;

    return ProjectModel(
      id: doc.id,
      name: data['name'] as String,
      description: data['description'] as String,
      ownerId: data['ownerId'] as String,
      memberIds: List<String>.from(data['memberIds'] as List),
      status: data['status'] as String,
      progress: (data['progress'] as num).toDouble(),
      dueDate: (data['dueDate'] as Timestamp).toDate(),
    );
  }
  // Firestore se model banane ka section end
}