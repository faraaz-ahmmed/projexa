import 'package:cloud_firestore/cloud_firestore.dart';

class TaskModel {
  // Fields section start
  final String id;
  final String title;
  final bool isCompleted;

  const TaskModel({
    required this.id,
    required this.title,
    required this.isCompleted,
  });
  // Fields section end

  // Firestore conversion section start
  factory TaskModel.fromDoc(
    DocumentSnapshot<Map<String, dynamic>> doc,
  ) {
    final data = doc.data()!;

    return TaskModel(
      id: doc.id,
      title: data['title'] as String,
      isCompleted: data['isCompleted'] as bool,
    );
  }
  // Firestore conversion section end
}