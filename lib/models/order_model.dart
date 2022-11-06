import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:equatable/equatable.dart';

class OrderMod extends Equatable {
  final String name;
  final String orderId;
  final String paymentType;
  final String city;
  final String road;
  final String apartment;
  final String optional;
  final String customerName;
  final String mobileNumber;
  const OrderMod({
    required this.name,
    required this.orderId,
    required this.paymentType,
    required this.city,
    required this.road,
    required this.apartment,
    required this.optional,
    required this.customerName,
    required this.mobileNumber,
  });

  static OrderMod fromSnap(DocumentSnapshot snap) {
    var snapshot = snap.data() as Map<String, dynamic>;

    return OrderMod(
      name: snapshot["name"] ?? "",
      orderId: snapshot["orderId"] ?? "",
      paymentType: snapshot["paymentType"] ?? "",
      city: snapshot["city"] ?? "",
      road: snapshot["road"] ?? "",
      apartment: snapshot["apartment"] ?? "",
      optional: snapshot["optional"] ?? "",
      customerName: snapshot["customerName"] ?? "",
      mobileNumber: snapshot["mobileNumber"] ?? "",
    );
  }

  Map<String, dynamic> toJson() => {
        "name": name,
        "orderId": orderId,
        "paymentType": paymentType,
        "city": city,
        "road": road,
        "apartment": apartment,
        "optional": optional,
        "customerName": customerName,
        "mobileNumber": mobileNumber,
      };

  @override
  List<Object?> get props => [name, city, road, apartment, optional];
}
