import 'package:cloud_firestore/cloud_firestore.dart';

class UserModel {
  final String uid;
  final String name;
  final String email;
  final String role;
  final DateTime createdAt;

  UserModel({
    required this.uid,
    required this.name,
    required this.email,
    required this.role,
    required this.createdAt,
  });

  // Firestore Map Start
  Map<String, dynamic> toMap() {
    return {
      'uid': uid,
      'name': name,
      'email': email,
      'role': role,
      'createdAt': Timestamp.fromDate(createdAt),
    };
  }
  // Firestore Map End

  // Firestore Data Start
  factory UserModel.fromMap(Map<String, dynamic> map) {
    final createdAtData = map['createdAt'];

    return UserModel(
      uid: map['uid']?.toString() ?? '',
      name: map['name']?.toString() ?? '',
      email: map['email']?.toString() ?? '',
      role: map['role']?.toString() ?? 'member',
      createdAt: createdAtData is Timestamp
          ? createdAtData.toDate()
          : DateTime.now(),
    );
  }
  // Firestore Data End
}