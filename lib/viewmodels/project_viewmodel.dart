import 'package:flutter/material.dart';

import '../models/project_model.dart';
import '../services/project_service.dart';

class ProjectViewModel extends ChangeNotifier {
  // State section start
  final _service = ProjectService();
  late final Stream<List<ProjectModel>> projects;

  bool isSaving = false;
  String? error;

  ProjectViewModel() {
    projects = _service.watchProjects();
  }
  // State section end

  // Project save section start
  Future<bool> addProject({
    required String name,
    required String description,
    required DateTime dueDate,
  }) async {
    if (isSaving) return false;

    isSaving = true;
    error = null;
    notifyListeners();

    try {
      await _service.addProject(
        name: name,
        description: description,
        dueDate: dueDate,
      );
      return true;
    } catch (_) {
      error = 'Project save nahi hua. Internet aur Firestore rules check karein.';
      return false;
    } finally {
      isSaving = false;
      notifyListeners();
    }
  }
  // Project save section end
}