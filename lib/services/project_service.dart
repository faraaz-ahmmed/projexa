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
      'dueDate': Timestamp.fromDate(dueDate),
      'createdAt': FieldValue.serverTimestamp(),
    });
  }
  // Project create section end

  // Progress update section start
  Future<void> updateProgress(String id, double progress) async {
    final value = progress.clamp(0.0, 1.0);

    final status = value == 1.0
        ? 'Completed'
        : value == 0.0
            ? 'Remaining'
            : 'In Progress';

    await _projects.doc(id).update({
      'progress': value,
      'status': status,
    });
  }
  // Progress update section end

  // Project delete section start
  Future<void> deleteProject(String id) async {
    await _projects.doc(id).delete();
  }
  // Project delete section end
}