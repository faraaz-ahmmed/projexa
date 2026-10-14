import 'package:cloud_firestore/cloud_firestore.dart';

class ProjectModel {
  final String id;
  final String name;
  final String description;
  final String ownerId;
  final String status;
  final DateTime createdAt;
  final DateTime dueDate;

  ProjectModel({
    required this.id,
    required this.name,
    required this.description,
    required this.ownerId,
    required this.status,
    required this.createdAt,
    required this.dueDate,
  });

  // Firestore Map Start
  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'name': name,
      'description': description,
      'ownerId': ownerId,
      'status': status,
      'createdAt': Timestamp.fromDate(createdAt),
      'dueDate': Timestamp.fromDate(dueDate),
    };
  }
  // Firestore Map End

  // Firestore Data Start
  factory ProjectModel.fromMap(
    Map<String, dynamic> map,
    String documentId,
  ) {
    final createdAtData = map['createdAt'];
    final dueDateData = map['dueDate'];

    return ProjectModel(
      id: documentId,
      name: map['name']?.toString() ?? '',
      description: map['description']?.toString() ?? '',
      ownerId: map['ownerId']?.toString() ?? '',
      status: map['status']?.toString() ?? 'remaining',
      createdAt: createdAtData is Timestamp
          ? createdAtData.toDate()
          : DateTime.now(),
      dueDate: dueDateData is Timestamp
          ? dueDateData.toDate()
          : DateTime.now(),
    );
  }
  // Firestore Data End
}