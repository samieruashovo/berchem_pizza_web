import '/models/user_model.dart' as model;
import 'package:cloud_firestore/cloud_firestore.dart';

class UserInfoCreateUpdate {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  Future<void> addUser(
      {required String firstName,
      required String lastName,
      required String uid,
      required String email,
      required String city,
      required String street,
      required String apartment,
      required String optional}) async {
    try {
      model.User user = model.User(
        firstName: firstName,
        lastName: lastName,
        uid: uid,
        email: email,
        city: city,
        street: street,
        apartment: apartment,
        optional: optional,
      );
      _firestore.collection('users').doc(uid).set(user.toJson());
    } catch (e) {
      print(e.toString());
    }
  }
}
