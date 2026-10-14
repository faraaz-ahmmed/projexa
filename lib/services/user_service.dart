import 'package:cloud_firestore/cloud_firestore.dart';

import '../models/user_model.dart';

class UserService {
  final FirebaseFirestore _firestore =
      FirebaseFirestore.instance;

  // Users Collection Start
  CollectionReference<Map<String, dynamic>>
      get _usersCollection {
    return _firestore.collection('users');
  }
  // Users Collection End

  // Create User Start
  Future<void> createUser(
    UserModel user,
  ) async {
    await _usersCollection
        .doc(user.uid)
        .set(user.toMap());
  }
  // Create User End

  // Get User Start
  Future<UserModel?> getUser(
    String uid,
  ) async {
    final document =
        await _usersCollection.doc(uid).get();

    if (!document.exists) {
      return null;
    }

    final data = document.data();

    if (data == null) {
      return null;
    }

    return UserModel.fromMap(data);
  }
  // Get User End

  // Find User By Email Start
  Future<UserModel?> getUserByEmail(
    String email,
  ) async {
    final result = await _usersCollection
        .where(
          'email',
          isEqualTo: email.trim().toLowerCase(),
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
  // Find User By Email End

  // Update Account Status Start
  Future<void> updateAccountStatus({
    required String uid,
    required String status,
  }) async {
    await _usersCollection.doc(uid).update({
      'accountStatus': status,
    });
  }
  // Update Account Status End
}