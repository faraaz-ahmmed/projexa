import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

import '../services/user_service.dart';

class DashboardViewModel extends ChangeNotifier {
  final UserService _userService = UserService();

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

  // Load Dashboard Start
  Future<void> loadDashboard() async {
    _setLoading(true);

    try {
      final currentUser = FirebaseAuth.instance.currentUser;

      if (currentUser == null) {
        _userName = 'User';
        return;
      }

      final user = await _userService.getUser(
        currentUser.uid,
      );

      if (user != null && user.name.trim().isNotEmpty) {
        _userName = user.name;
      } else {
        _userName = currentUser.email ?? 'User';
      }
    } catch (_) {
      _userName = 'User';
    } finally {
      _setLoading(false);
    }
  }
  // Load Dashboard End

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

    _overallProgress =
        _completedProjects / _totalProjects;
  }
  // Progress End

  // Loading Start
  void _setLoading(bool value) {
    _isLoading = value;
    notifyListeners();
  }
  // Loading End
}