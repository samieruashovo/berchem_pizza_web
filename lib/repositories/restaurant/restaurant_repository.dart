// import 'package:cloud_firestore/cloud_firestore.dart';

// import '/models/models.dart';
// import 'base_restaurant_repository.dart';

// class RestaurantRepository extends BaseRestaurantRepository {
//   final FirebaseFirestore _firebaseFirestore;

//   RestaurantRepository({FirebaseFirestore? firebaseFirestore})
//       : _firebaseFirestore = firebaseFirestore ?? FirebaseFirestore.instance;

//   @override
//   Stream<List<Restaurant>> getRestaurants() {
//     return _firebaseFirestore
//         .collection('restaurants')
//         .snapshots()
//         .map((snapshot) {
//       return snapshot.docs.map((doc) => Restaurant.fromSnapshot(doc)).toList();
//     });
//   }
// }
