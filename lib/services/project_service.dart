import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

import '../models/project_model.dart';

class ProjectService {
  // Firebase references section start
  final _projects = FirebaseFirestore.instance.collection('projects');
  final _auth = FirebaseAuth.instance;
  // Firebase references section end

  // Projects read section start
  Stream<List<ProjectModel>> watchProjects() {
    final user = _auth.currentUser;

    if (user == null) {
      return Stream.value(<ProjectModel>[]);
    }

    return _projects
        .where('memberIds', arrayContains: user.uid)
        .snapshots()
        .map((snapshot) {
      final projects = snapshot.docs
          .map((doc) => ProjectModel.fromDoc(doc))
          .toList();

      projects.sort((a, b) => a.dueDate.compareTo(b.dueDate));
      return projects;
    });
  }
  // Projects read section end

  // Project create section start
  Future<void> addProject({
    required String name,
    required String description,
    required DateTime dueDate,
  }) async {
    final user = _auth.currentUser;

    if (user == null) {
      throw StateError('Please log in first.');
    }

    await _projects.add({
      'name': name.trim(),
      'description': description.trim(),
      'ownerId': user.uid,
      'memberIds': [user.uid],
      'status': 'Remaining',
      'progress': 0.0,
      'totalTasks': 0,
      'completedTasks': 0,
      'taskRevision': 0,
      'dueDate': Timestamp.fromDate(dueDate),
      'createdAt': FieldValue.serverTimestamp(),
    });
  }
  // Project create section end

  // Project edit section start
  Future<void> editProject({
    required String id,
    required String name,
    required String description,
    required DateTime dueDate,
  }) async {
    await _projects.doc(id).update({
      'name': name.trim(),
      'description': description.trim(),
      'dueDate': Timestamp.fromDate(dueDate),
    });
  }
  // Project edit section end

  // Project delete section start
  Future<void> deleteProject(String id) async {
    final tasks = await _projects
        .doc(id)
        .collection('tasks')
        .limit(1)
        .get(const GetOptions(source: Source.server));

    if (tasks.docs.isNotEmpty) {
      throw StateError('Please delete the project tasks first.');
    }

    await _projects.doc(id).delete();
  }
  // Project delete section end
}