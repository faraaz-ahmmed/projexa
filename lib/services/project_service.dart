import 'package:cloud_firestore/cloud_firestore.dart';

import '../models/project_model.dart';

class ProjectService {
  final FirebaseFirestore _firestore =
      FirebaseFirestore.instance;

  // Projects Collection Start
  CollectionReference<Map<String, dynamic>>
      get _projectsCollection {
    return _firestore.collection('projects');
  }
  // Projects Collection End

  // Create Project Start
  Future<void> createProject(
    ProjectModel project,
  ) async {
    await _projectsCollection
        .doc(project.id)
        .set(project.toMap());
  }
  // Create Project End

  // Get User Projects Start
  Stream<List<ProjectModel>> getUserProjects(
    String userId,
  ) {
    return _projectsCollection
        .where(
          'ownerId',
          isEqualTo: userId,
        )
        .snapshots()
        .map((snapshot) {
      return snapshot.docs.map((document) {
        return ProjectModel.fromMap(
          document.data(),
          document.id,
        );
      }).toList();
    });
  }
  // Get User Projects End

  // Get Project Start
  Future<ProjectModel?> getProject(
    String projectId,
  ) async {
    final document =
        await _projectsCollection.doc(projectId).get();

    if (!document.exists) {
      return null;
    }

    final data = document.data();

    if (data == null) {
      return null;
    }

    return ProjectModel.fromMap(
      data,
      document.id,
    );
  }
  // Get Project End

  // Update Project Start
  Future<void> updateProject(
    ProjectModel project,
  ) async {
    await _projectsCollection
        .doc(project.id)
        .update(project.toMap());
  }
  // Update Project End

  // Delete Project Start
  Future<void> deleteProject(
    String projectId,
  ) async {
    await _projectsCollection
        .doc(projectId)
        .delete();
  }
  // Delete Project End
}