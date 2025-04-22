import 'package:cloud_firestore/cloud_firestore.dart';

class CartItem{
  final String orderId;
  final String drugId;
  final String patientId;
  final String pharmacyId;
  final String pharmacyName;
  final bool isPickup;
  final String deliveryAddress;
  final double latitude;
  final double longitude;
  final String brand;
  final String orderUnit;
  final int quantity;
  final String drugName;
  final int price;
  final bool inCart;
  final bool isFulfilled;
  final Timestamp orderDate;
  final String dosage;
  final String drugImageURL;

//<editor-fold desc="Data Methods">
  const CartItem({
    required this.orderId,
    required this.drugId,
    required this.patientId,
    required this.pharmacyId,
    required this.pharmacyName,
    required this.isPickup,
    required this.deliveryAddress,
    required this.latitude,
    required this.longitude,
    required this.brand,
    required this.orderUnit,
    required this.quantity,
    required this.drugName,
    required this.price,
    required this.inCart,
    required this.isFulfilled,
    required this.orderDate,
    required this.dosage,
    required this.drugImageURL,
  });

  CartItem copyWith({
    String? orderId,
    String? drugId,
    String? patientId,
    String? pharmacyId,
    String? pharmacyName,
    bool? isPickup,
    String? deliveryAddress,
    double? latitude,
    double? longitude,
    String? brand,
    String? orderUnit,
    int? quantity,
    String? drugName,
    int? price,
    bool? inCart,
    bool? isFulfilled,
    Timestamp? orderDate,
    String? dosage,
    String? drugImageURL,
  }) {
    return CartItem(
      orderId: orderId ?? this.orderId,
      drugId: drugId ?? this.drugId,
      patientId: patientId ?? this.patientId,
      pharmacyId: pharmacyId ?? this.pharmacyId,
      pharmacyName: pharmacyName ?? this.pharmacyName,
      isPickup: isPickup ?? this.isPickup,
      deliveryAddress: deliveryAddress ?? this.deliveryAddress,
      latitude: latitude ?? this.latitude,
      longitude: longitude ?? this.longitude,
      brand: brand ?? this.brand,
      orderUnit: orderUnit ?? this.orderUnit,
      quantity: quantity ?? this.quantity,
      drugName: drugName ?? this.drugName,
      price: price ?? this.price,
      inCart: inCart ?? this.inCart,
      isFulfilled: isFulfilled ?? this.isFulfilled,
      orderDate: orderDate ?? this.orderDate,
      dosage: dosage ?? this.dosage,
      drugImageURL: drugImageURL ?? this.drugImageURL,
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'orderId': this.orderId,
      'drugId': this.drugId,
      'patientId': this.patientId,
      'pharmacyId': this.pharmacyId,
      'pharmacyName': this.pharmacyName,
      'isPickup': this.isPickup,
      'deliveryAddress': this.deliveryAddress,
      'latitude': this.latitude,
      'longitude': this.longitude,
      'brand': this.brand,
      'orderUnit': this.orderUnit,
      'quantity': this.quantity,
      'drugName': this.drugName,
      'price': this.price,
      'inCart': this.inCart,
      'isFulfilled': this.isFulfilled,
      'orderDate': this.orderDate,
      'dosage': this.dosage,
      'drugImageURL': this.drugImageURL,
    };
  }

  factory CartItem.fromMap(Map<String, dynamic> map) {
    return CartItem(
      orderId: map['orderId'] as String,
      drugId: map['drugId'] as String,
      patientId: map['patientId'] as String,
      pharmacyId: map['pharmacyId'] as String,
      pharmacyName: map['pharmacyName'] as String,
      isPickup: map['isPickup'] as bool,
      deliveryAddress: map['deliveryAddress'] as String,
      latitude: map['latitude'] as double,
      longitude: map['longitude'] as double,
      brand: map['brand'] as String,
      orderUnit: map['orderUnit'] as String,
      quantity: map['quantity'] as int,
      drugName: map['drugName'] as String,
      price: map['price'] as int,
      inCart: map['inCart'] as bool,
      isFulfilled: map['isFulfilled'] as bool,
      orderDate: map['orderDate'] as Timestamp,
      dosage: map['dosage'] as String,
      drugImageURL: map['drugImageURL'] as String,
    );
  }

//</editor-fold>
}