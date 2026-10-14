import 'package:cloud_firestore/cloud_firestore.dart';

import '../models/project_member_model.dart';
import '../models/user_model.dart';

class TeamService {
  final FirebaseFirestore _firestore =
      FirebaseFirestore.instance;

  // Find User Start
  Future<UserModel?> findUserByEmail(
    String email,
  ) async {
    final result = await _firestore
        .collection('users')
        .where(
          'email',
          isEqualTo: email.trim(),
        )
        .limit(1)
        .get();

    if (result.docs.isEmpty) {
      return null;
    }

    return UserModel.fromMap(
      result.docs.first.data(),
    );
  }
  // Find User End

  // Add Member Start
  Future<void> addMember({
    required String projectId,
    required ProjectMemberModel member,
  }) async {
    await _firestore
        .collection('projects')
        .doc(projectId)
        .collection('members')
        .doc(member.uid)
        .set(
          member.toMap(),
        );
  }
  // Add Member End

  // Check Member Start
  Future<bool> isMember({
    required String projectId,
    required String userId,
  }) async {
    final document = await _firestore
        .collection('projects')
        .doc(projectId)
        .collection('members')
        .doc(userId)
        .get();

    return document.exists;
  }
  // Check Member End

  // Team Stream Start
  Stream<List<ProjectMemberModel>> getMembers(
    String projectId,
  ) {
    return _firestore
        .collection('projects')
        .doc(projectId)
        .collection('members')
        .snapshots()
        .map((snapshot) {
      return snapshot.docs.map((document) {
        return ProjectMemberModel.fromMap(
          document.data(),
        );
      }).toList();
    });
  }
  // Team Stream End

  // Remove Member Start
  Future<void> removeMember({
    required String projectId,
    required String userId,
  }) async {
    await _firestore
        .collection('projects')
        .doc(projectId)
        .collection('members')
        .doc(userId)
        .delete();
  }
  // Remove Member End
}