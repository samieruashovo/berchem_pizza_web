import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:equatable/equatable.dart';

class Product extends Equatable {
  final String id;
  //final String restaurantId;
  final String name;
  final String category;
  final String description;
  final String imageUrl;
  final String price;

  const Product({
    required this.id,
    //required this.restaurantId,
    required this.name,
    required this.category,
    required this.description,
    required this.imageUrl,
    required this.price,
  });

  static Product fromSnap(DocumentSnapshot snap) {
    var snapshot = snap.data() as Map<String, dynamic>;

    return Product(
      name: snapshot["name"] ?? "",
      id: snapshot["id"] ?? "",
      category: snapshot["category"] ?? "",
      description: snapshot["description"] ?? "",
      imageUrl: snapshot["imageUrl"] ?? "",
      price: snapshot["price"] ?? "",
    );
  }

  Map<String, dynamic> toJson() => {
        "name": name,
        "id": id,
        "category": category,
        "description": description,
        "imageUrl": imageUrl,
        "price": price,
      };

  // factory Product.fromSnapshot(Map<String, dynamic> snap) {
  //   return Product(
  //     id: snap['id'].toString(),
  //     restaurantId: snap['restaurantId'],
  //     name: snap['name'],
  //     category: snap['category'],
  //     description: snap['description'],
  //     imageUrl: snap['imageUrl'],
  //     price: snap['price'],
  //   );
  // }

  @override
  List<Object?> get props => [id, name, category, description, imageUrl, price];
}
