// ignore_for_file: avoid_print

import '/models/user_model.dart' as model;
import 'package:cloud_firestore/cloud_firestore.dart';

class UserInfoCreateUpdate {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  Future<void> addUser({
    required String firstName,
    required String lastName,
    required String uid,
    required String email,
  }) async {
    try {
      model.User user = model.User(
        firstName: firstName,
        lastName: lastName,
        uid: uid,
        email: email,
      );
      _firestore.collection('users').doc(uid).set(user.toJson());
    } catch (e) {
    //  print(e.toString());
    }
  }
}
