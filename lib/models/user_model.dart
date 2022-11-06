import 'package:cloud_firestore/cloud_firestore.dart';

class User {
  final String uid;
  final String firstName;
  final String lastName;
  final String email;
  final String city;
  final String street;
  final String apartment;
  final String optional;

  const User({
    required this.firstName,
    required this.lastName,
    required this.uid,
    required this.email,
    required this.city,
    required this.street,
    required this.apartment,
    required this.optional,
  });

  static User fromSnap(DocumentSnapshot snap) {
    var snapshot = snap.data() as Map<String, dynamic>;

    return User(
      firstName: snapshot["firstName"] ?? "",
      lastName: snapshot["lastName"],
      uid: snapshot["uid"] ?? "",
      email: snapshot["email"] ?? "",
      city: snapshot["city"] ?? "",
      street: snapshot["street"] ?? "",
      apartment: snapshot["apartment"] ?? "",
      optional: snapshot["optional"] ?? "",
    );
  }

  Map<String, dynamic> toJson() => {
        "firstName": firstName,
        "lastName": lastName,
        "uid": uid,
        "email": email,
        "city": city,
        "street": street,
        "apartment": apartment,
        "optional": optional,
      };
}
