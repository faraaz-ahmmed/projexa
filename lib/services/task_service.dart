import 'package:cloud_firestore/cloud_firestore.dart';

import '../models/task_model.dart';

class TaskService {
  // Collection section start
  final CollectionReference<Map<String, dynamic>> _tasks;

  TaskService(String projectId)
      : _tasks = FirebaseFirestore.instance
            .collection('projects')
            .doc(projectId)
            .collection('tasks');
  // Collection section end

  // Tasks read section start
  Stream<List<TaskModel>> watchTasks() {
    return _tasks.orderBy('createdAt').snapshots().map(
          (snapshot) =>
              snapshot.docs.map((doc) => TaskModel.fromDoc(doc)).toList(),
        );
  }
  // Tasks read section end

  // Task add section start
  Future<void> addTask(String title) async {
    await _tasks.add({
      'title': title.trim(),
      'isCompleted': false,
      'createdAt': FieldValue.serverTimestamp(),
    });
  }
  // Task add section end

  // Task complete section start
  Future<void> setCompleted(String id, bool value) async {
    await _tasks.doc(id).update({
      'isCompleted': value,
    });
  }
  // Task complete section end

  // Task delete section start
  Future<void> deleteTask(String id) async {
    await _tasks.doc(id).delete();
  }
  // Task delete section end
}