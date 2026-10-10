import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

import '../models/team_member_model.dart';

class TeamViewModel extends ChangeNotifier {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  bool isLoading = false;
  String? error;

  // Get members of a specific project
  Stream<List<TeamMemberModel>> members(String projectId) {
    return _firestore
        .collection('team_members')
        .where('projectId', isEqualTo: projectId)
        .snapshots()
        .map((snapshot) {
      return snapshot.docs.map((doc) {
        return TeamMemberModel.fromMap(
          doc.id,
          doc.data(),
        );
      }).toList();
    });
  }

  // Add member to project
  Future<bool> addMember({
    required String projectId,
    required String name,
    required String email,
    required String role,
  }) async {
    try {
      isLoading = true;
      error = null;
      notifyListeners();

      await _firestore.collection('team_members').add({
        'projectId': projectId,
        'name': name.trim(),
        'email': email.trim().toLowerCase(),
        'role': role,
        'createdAt': FieldValue.serverTimestamp(),
      });

      return true;
    } catch (e) {
      error = e.toString();
      return false;
    } finally {
      isLoading = false;
      notifyListeners();
    }
  }

  // Delete member
  Future<bool> deleteMember(String id) async {
    try {
      error = null;

      await _firestore
          .collection('team_members')
          .doc(id)
          .delete();

      return true;
    } catch (e) {
      error = e.toString();
      notifyListeners();
      return false;
    }
  }
}