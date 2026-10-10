import 'package:cloud_firestore/cloud_firestore.dart';

import '../models/task_model.dart';

class TaskService {
  // Firebase references section start
  final DocumentReference<Map<String, dynamic>> _project;
  final FirebaseFirestore _db = FirebaseFirestore.instance;

  TaskService(String projectId)
      : _project = FirebaseFirestore.instance
            .collection('projects')
            .doc(projectId);

  CollectionReference<Map<String, dynamic>> get _tasks =>
      _project.collection('tasks');
  // Firebase references section end

  // Tasks read section start
  Stream<List<TaskModel>> watchTasks() {
    return _tasks.orderBy('createdAt').snapshots().map(
          (snapshot) =>
              snapshot.docs.map((doc) => TaskModel.fromDoc(doc)).toList(),
        );
  }
  // Tasks read section end

  // Task actions section start
  Future<void> addTask(String title) {
    return _saveChange(
      taskId: _tasks.doc().id,
      title: title.trim(),
    );
  }

  Future<void> editTask(String id, String title) async {
    await _tasks.doc(id).update({'title': title.trim()});
  }

  Future<void> setCompleted(String id, bool value) {
    return _saveChange(taskId: id, completed: value);
  }

  Future<void> deleteTask(String id) {
    return _saveChange(taskId: id, delete: true);
  }
  // Task actions section end

  // Task aur progress save section start
  Future<void> _saveChange({
    required String taskId,
    String? title,
    bool? completed,
    bool delete = false,
  }) async {
    for (var attempt = 0; attempt < 5; attempt++) {
      final projectSnapshot = await _project.get(
        const GetOptions(source: Source.server),
      );

      if (!projectSnapshot.exists) {
        throw StateError('Project no longer exists.');
      }

      final revision =
          (projectSnapshot.data()!['taskRevision'] as num?)?.toInt() ?? 0;

      final taskSnapshot = await _tasks.get(
        const GetOptions(source: Source.server),
      );

      final taskStates = {
        for (final doc in taskSnapshot.docs)
          doc.id: doc.data()['isCompleted'] as bool,
      };

      if (title != null) {
        taskStates[taskId] = false;
      } else {
        if (!taskStates.containsKey(taskId)) {
          throw StateError('Task no longer exists.');
        }

        if (delete) {
          taskStates.remove(taskId);
        } else {
          taskStates[taskId] = completed!;
        }
      }

      final total = taskStates.length;
      final done = taskStates.values.where((value) => value).length;
      final progress = total == 0 ? 0.0 : done / total;

      final status = progress == 1.0
          ? 'Completed'
          : progress == 0.0
              ? 'Remaining'
              : 'In Progress';

      final saved = await _db.runTransaction<bool>((transaction) async {
        final current = await transaction.get(_project);

        if (!current.exists) {
          throw StateError('Project no longer exists.');
        }

        final currentRevision =
            (current.data()!['taskRevision'] as num?)?.toInt() ?? 0;

        if (currentRevision != revision) return false;

        final taskRef = _tasks.doc(taskId);

        if (title != null) {
          transaction.set(taskRef, {
            'title': title,
            'isCompleted': false,
            'createdAt': FieldValue.serverTimestamp(),
          });
        } else if (delete) {
          transaction.delete(taskRef);
        } else {
          transaction.update(taskRef, {
            'isCompleted': completed,
          });
        }

        transaction.update(_project, {
          'totalTasks': total,
          'completedTasks': done,
          'progress': progress,
          'status': status,
          'taskRevision': revision + 1,
        });

        return true;
      });

      if (saved) return;
    }

    throw StateError('Tasks changed. Please try again.');
  }
  // Task aur progress save section end
}