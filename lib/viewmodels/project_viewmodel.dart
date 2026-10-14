import 'dart:async';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

import '../models/project_model.dart';
import '../services/project_service.dart';

class ProjectViewModel extends ChangeNotifier {
  final ProjectService _projectService =
      ProjectService();

  StreamSubscription<List<ProjectModel>>?
      _projectSubscription;

  List<ProjectModel> _projects = [];

  bool _isLoading = false;

  String _selectedFilter = 'All';

  String? _errorMessage;

  // Getters Start
  List<ProjectModel> get projects => _projects;

  bool get isLoading => _isLoading;

  String get selectedFilter => _selectedFilter;

  String? get errorMessage => _errorMessage;

  int get totalProjects => _projects.length;

  int get completedProjects {
    return _projects
        .where(
          (project) =>
              project.status == 'completed',
        )
        .length;
  }

  int get inProgressProjects {
    return _projects
        .where(
          (project) =>
              project.status == 'in_progress',
        )
        .length;
  }

  int get remainingProjects {
    return _projects
        .where(
          (project) =>
              project.status == 'remaining',
        )
        .length;
  }
  // Getters End

  // Filtered Projects Start
  List<ProjectModel> get filteredProjects {
    switch (_selectedFilter) {
      case 'Completed':
        return _projects
            .where(
              (project) =>
                  project.status == 'completed',
            )
            .toList();

      case 'In Progress':
        return _projects
            .where(
              (project) =>
                  project.status == 'in_progress',
            )
            .toList();

      case 'Remaining':
        return _projects
            .where(
              (project) =>
                  project.status == 'remaining',
            )
            .toList();

      default:
        return _projects;
    }
  }
  // Filtered Projects End

  // Load Projects Start
  void loadProjects() {
    final currentUser =
        FirebaseAuth.instance.currentUser;

    if (currentUser == null) {
      _projects = [];
      _errorMessage =
          'Please login to view your projects.';
      notifyListeners();
      return;
    }

    _isLoading = true;
    _errorMessage = null;
    notifyListeners();

    _projectSubscription?.cancel();

    _projectSubscription = _projectService
        .getUserProjects(currentUser.uid)
        .listen(
      (projects) {
        _projects = projects;
        _isLoading = false;
        _errorMessage = null;

        notifyListeners();
      },
      onError: (_) {
        _isLoading = false;
        _errorMessage =
            'Unable to load projects.';

        notifyListeners();
      },
    );
  }
  // Load Projects End

  // Change Filter Start
  void changeFilter(String filter) {
    _selectedFilter = filter;
    notifyListeners();
  }
  // Change Filter End

  // Delete Project Start
  Future<bool> deleteProject(
    String projectId,
  ) async {
    try {
      await _projectService.deleteProject(
        projectId,
      );

      _errorMessage = null;

      return true;
    } catch (_) {
      _errorMessage =
          'Unable to delete project.';

      notifyListeners();

      return false;
    }
  }
  // Delete Project End

  // Dispose Start
  @override
  void dispose() {
    _projectSubscription?.cancel();
    super.dispose();
  }
  // Dispose End
}