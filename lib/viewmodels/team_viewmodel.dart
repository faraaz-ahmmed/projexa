import 'dart:async';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

import '../models/project_member_model.dart';
import '../models/user_model.dart';
import '../services/team_service.dart';

class TeamViewModel extends ChangeNotifier {
  final TeamService _teamService = TeamService();

  StreamSubscription<List<ProjectMemberModel>>?
      _memberSubscription;

  List<ProjectMemberModel> _members = [];

  bool _isLoading = false;
  bool _isAdding = false;

  String? _errorMessage;

  // Getters Start
  List<ProjectMemberModel> get members => _members;

  bool get isLoading => _isLoading;

  bool get isAdding => _isAdding;

  String? get errorMessage => _errorMessage;

  int get totalMembers => _members.length;
  // Getters End

  // Load Members Start
  void loadMembers(
    String projectId,
  ) {
    _isLoading = true;
    _errorMessage = null;

    notifyListeners();

    _memberSubscription?.cancel();

    _memberSubscription =
        _teamService.getMembers(projectId).listen(
      (members) {
        _members = members;
        _isLoading = false;
        _errorMessage = null;

        notifyListeners();
      },
      onError: (error) {
        _isLoading = false;

        if (error is FirebaseException) {
          _errorMessage =
              'Firebase error: ${error.code} - ${error.message}';
        } else {
          _errorMessage =
              'Unable to load team members.';
        }

        notifyListeners();
      },
    );
  }
  // Load Members End

  // Add Member Start
  Future<bool> addMember({
    required String projectId,
    required String email,
  }) async {
    final currentUser =
        FirebaseAuth.instance.currentUser;

    if (currentUser == null) {
      _errorMessage =
          'Please login to add a member.';
      notifyListeners();
      return false;
    }

    final cleanEmail =
        email.trim().toLowerCase();

    if (cleanEmail.isEmpty) {
      _errorMessage =
          'Please enter member email.';
      notifyListeners();
      return false;
    }

    _isAdding = true;
    _errorMessage = null;

    notifyListeners();

    try {
      // Find User Start
      final UserModel? user =
          await _teamService.findUserByEmail(
        cleanEmail,
      );
      // Find User End

      if (user == null) {
        _errorMessage =
            'No registered user found with this email.';
        return false;
      }

      // Owner Check Start
      if (user.uid == currentUser.uid) {
        _errorMessage =
            'You cannot add yourself as a team member.';
        return false;
      }
      // Owner Check End

      // Existing Member Check Start
      final alreadyMember =
          await _teamService.isMember(
        projectId: projectId,
        userId: user.uid,
      );

      if (alreadyMember) {
        _errorMessage =
            'This user is already a team member.';
        return false;
      }
      // Existing Member Check End

      // Member Model Start
      final member = ProjectMemberModel(
        uid: user.uid,
        name: user.name,
        email: user.email,
        role: 'member',
        joinedAt: DateTime.now(),
      );
      // Member Model End

      // Save Member Start
      await _teamService.addMember(
        projectId: projectId,
        member: member,
      );
      // Save Member End

      _errorMessage = null;

      return true;
    } on FirebaseException catch (e) {
      _errorMessage =
          'Firebase error: ${e.code} - ${e.message}';

      return false;
    } catch (e) {
      _errorMessage =
          'Error: ${e.toString()}';

      return false;
    } finally {
      _isAdding = false;
      notifyListeners();
    }
  }
  // Add Member End

  // Remove Member Start
  Future<bool> removeMember({
    required String projectId,
    required String userId,
  }) async {
    try {
      await _teamService.removeMember(
        projectId: projectId,
        userId: userId,
      );

      _errorMessage = null;

      return true;
    } on FirebaseException catch (e) {
      _errorMessage =
          'Firebase error: ${e.code} - ${e.message}';

      notifyListeners();

      return false;
    } catch (e) {
      _errorMessage =
          'Error: ${e.toString()}';

      notifyListeners();

      return false;
    }
  }
  // Remove Member End

  // Clear Error Start
  void clearError() {
    _errorMessage = null;
    notifyListeners();
  }
  // Clear Error End

  // Dispose Start
  @override
  void dispose() {
    _memberSubscription?.cancel();
    super.dispose();
  }
  // Dispose End
}