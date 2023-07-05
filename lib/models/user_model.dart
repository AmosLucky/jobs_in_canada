import 'package:cloud_firestore/cloud_firestore.dart';

class UserModel {
  String? username, email, user_id;
  UserModel(
      {required this.username, required this.email, required this.user_id});
  factory UserModel.fromDocs(DocumentSnapshot doc) {
    return UserModel(
        username: doc['username'],
        email: doc['email'],
        user_id: doc['user_id']);
  }
}
