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

  // Project create section start
  Future<bool> addProject({
    required String name,
    required String description,
    required DateTime dueDate,
  }) {
    return _run(() => _service.addProject(
          name: name,
          description: description,
          dueDate: dueDate,
        ));
  }
  // Project create section end

  // Project edit section start
  Future<bool> editProject({
    required String id,
    required String name,
    required String description,
    required DateTime dueDate,
  }) {
    return _run(() => _service.editProject(
          id: id,
          name: name,
          description: description,
          dueDate: dueDate,
        ));
  }
  // Project edit section end

  // Project delete section start
  Future<bool> deleteProject(String id) {
    return _run(() => _service.deleteProject(id));
  }
  // Project delete section end

  // Loading aur error section start
  Future<bool> _run(Future<void> Function() action) async {
    if (isSaving) return false;

    isSaving = true;
    error = null;
    notifyListeners();

    try {
      await action();
      return true;
    } on StateError catch (e) {
      error = e.message.toString();
      return false;
    } catch (_) {
      error = 'Action failed. Internet aur permissions check karein.';
      return false;
    } finally {
      isSaving = false;
      notifyListeners();
    }
  }
  // Loading aur error section end
}