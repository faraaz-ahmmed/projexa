import 'package:flutter/material.dart';

import '../models/task_model.dart';
import '../services/task_service.dart';

class TaskViewModel extends ChangeNotifier {
  // State section start
  final TaskService _service;
  late final Stream<List<TaskModel>> tasks;

  bool isBusy = false;
  String? error;

  TaskViewModel(String projectId) : _service = TaskService(projectId) {
    tasks = _service.watchTasks();
  }
  // State section end

  // Task actions section start
  Future<bool> addTask(String title) {
    return _run(() => _service.addTask(title));
  }

  Future<bool> editTask(String id, String title) {
    return _run(() => _service.editTask(id, title));
  }

  Future<bool> setCompleted(String id, bool value) {
    return _run(() => _service.setCompleted(id, value));
  }

  Future<bool> deleteTask(String id) {
    return _run(() => _service.deleteTask(id));
  }
  // Task actions section end

  // Loading aur error section start
  Future<bool> _run(Future<void> Function() action) async {
    if (isBusy) return false;

    isBusy = true;
    error = null;
    notifyListeners();

    try {
      await action();
      return true;
    } catch (_) {
      error = 'Task action failed. Internet aur permissions check karein.';
      return false;
    } finally {
      isBusy = false;
      notifyListeners();
    }
  }
  // Loading aur error section end
}