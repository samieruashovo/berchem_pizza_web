import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:equatable/equatable.dart';

class OrderMod extends Equatable {
  final String name;
  final String extra;
  final String orderId;
  final String time;
  final String paymentType;
  final String city;
  final String road;
  final String apartment;
  final String optional;
  final String customerName;
  final String mobileNumber;
  const OrderMod({
    required this.name,
    required this.extra,
    required this.orderId,
    required this.time,
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
      extra: snapshot["extra"] ?? "",
      orderId: snapshot["orderId"] ?? "",
      time: snapshot["time"] ?? "",
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
        "extra": extra,
        "orderId": orderId,
        "time": time,
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
