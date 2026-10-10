import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

import '../models/team_member_model.dart';

class TeamViewModel extends ChangeNotifier {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  bool isLoading = false;
  String? error;

  Stream<List<TeamMemberModel>> get members {
    return _firestore.collection('team_members').snapshots().map(
      (snapshot) {
        return snapshot.docs.map((doc) {
          return TeamMemberModel.fromMap(
            doc.id,
            doc.data(),
          );
        }).toList();
      },
    );
  }

  Future<bool> addMember({
    required String name,
    required String email,
    required String role,
  }) async {
    try {
      isLoading = true;
      error = null;
      notifyListeners();

      await _firestore.collection('team_members').add({
        'name': name.trim(),
        'email': email.trim(),
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

  Future<void> deleteMember(String id) async {
    await _firestore.collection('team_members').doc(id).delete();
  }
}