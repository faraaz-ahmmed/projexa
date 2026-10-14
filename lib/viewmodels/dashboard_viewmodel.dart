import 'package:flutter/material.dart';

class DashboardViewModel extends ChangeNotifier {
  bool _isLoading = false;

  String _userName = 'User';

  int _totalProjects = 0;
  int _completedProjects = 0;
  int _inProgressProjects = 0;
  int _remainingProjects = 0;

  double _overallProgress = 0.0;

  // Getters Start
  bool get isLoading => _isLoading;

  String get userName => _userName;

  int get totalProjects => _totalProjects;
  int get completedProjects => _completedProjects;
  int get inProgressProjects => _inProgressProjects;
  int get remainingProjects => _remainingProjects;

  double get overallProgress => _overallProgress;

  int get overallProgressPercentage {
    return (_overallProgress * 100).round();
  }
  // Getters End

  // Loading Start
  void setLoading(bool value) {
    _isLoading = value;
    notifyListeners();
  }
  // Loading End

  // User Name Start
  void setUserName(String name) {
    _userName = name;
    notifyListeners();
  }
  // User Name End

  // Project Summary Start
  void setProjectSummary({
    required int total,
    required int completed,
    required int inProgress,
    required int remaining,
  }) {
    _totalProjects = total;
    _completedProjects = completed;
    _inProgressProjects = inProgress;
    _remainingProjects = remaining;

    _calculateProgress();

    notifyListeners();
  }
  // Project Summary End

  // Progress Start
  void _calculateProgress() {
    if (_totalProjects == 0) {
      _overallProgress = 0.0;
      return;
    }

    _overallProgress = _completedProjects / _totalProjects;
  }
  // Progress End
}