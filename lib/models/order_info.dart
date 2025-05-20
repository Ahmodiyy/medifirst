import 'package:cloud_firestore/cloud_firestore.dart';

class OrderInfo{
  final String orderId;
  final String drugId;
  final String customerId;
  final String deliveryAddress;
  final String pharmacyId;
  final String pharmacyName;
  final double latitude;
  final double longitude;
  final String brand;
  final String orderUnit;
  final int quantity;
  final String drugName;
  final String customerName;
  final int price;
  final String orderStatus;
  final Timestamp orderDate;
  final String dosage;
  final String drugImageURL;
  final String customerImageURL;

//<editor-fold desc="Data Methods">
  const OrderInfo({
    required this.orderId,
    required this.drugId,
    required this.customerId,
    required this.deliveryAddress,
    required this.pharmacyId,
    required this.pharmacyName,
    required this.latitude,
    required this.longitude,
    required this.brand,
    required this.orderUnit,
    required this.quantity,
    required this.drugName,
    required this.customerName,
    required this.price,
    required this.orderStatus,
    required this.orderDate,
    required this.dosage,
    required this.drugImageURL,
    required this.customerImageURL,
  });

  OrderInfo copyWith({
    String? orderId,
    String? drugId,
    String? customerId,
    String? deliveryAddress,
    String? pharmacyId,
    String? pharmacyName,
    double? latitude,
    double? longitude,
    String? brand,
    String? orderUnit,
    int? quantity,
    String? drugName,
    String? customerName,
    int? price,
    String? orderStatus,
    Timestamp? orderDate,
    String? dosage,
    String? drugImageURL,
    String? customerImageURL,
  }) {
    return OrderInfo(
      orderId: orderId ?? this.orderId,
      drugId: drugId ?? this.drugId,
      customerId: customerId ?? this.customerId,
      deliveryAddress: deliveryAddress ?? this.deliveryAddress,
      pharmacyId: pharmacyId ?? this.pharmacyId,
      pharmacyName: pharmacyName ?? this.pharmacyName,
      latitude: latitude ?? this.latitude,
      longitude: longitude ?? this.longitude,
      brand: brand ?? this.brand,
      orderUnit: orderUnit ?? this.orderUnit,
      quantity: quantity ?? this.quantity,
      drugName: drugName ?? this.drugName,
      customerName: customerName ?? this.customerName,
      price: price ?? this.price,
      orderStatus: orderStatus ?? this.orderStatus,
      orderDate: orderDate ?? this.orderDate,
      dosage: dosage ?? this.dosage,
      drugImageURL: drugImageURL ?? this.drugImageURL,
      customerImageURL: customerImageURL ?? this.customerImageURL,
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'orderId': orderId,
      'drugId': drugId,
      'customerId': customerId,
      'deliveryAddress': deliveryAddress,
      'pharmacyId': pharmacyId,
      'pharmacyName': pharmacyName,
      'latitude': latitude,
      'longitude': longitude,
      'brand': brand,
      'orderUnit': orderUnit,
      'quantity': quantity,
      'drugName': drugName,
      'customerName': customerName,
      'price': price,
      'orderStatus': orderStatus,
      'orderDate': orderDate,
      'dosage': dosage,
      'drugImageURL': drugImageURL,
      'customerImageURL': customerImageURL,
    };
  }

  factory OrderInfo.fromMap(Map<String, dynamic> map) {
    return OrderInfo(
      orderId: map['orderId'] as String,
      drugId: map['drugId'] as String,
      customerId: map['customerId'] as String,
      deliveryAddress: map['deliveryAddress'] as String,
      pharmacyId: map['pharmacyId'] as String,
      pharmacyName: map['pharmacyName'] as String,
      latitude: map['latitude'] as double,
      longitude: map['longitude'] as double,
      brand: map['brand'] as String,
      orderUnit: map['orderUnit'] as String,
      quantity: map['quantity'] as int,
      drugName: map['drugName'] as String,
      customerName: map['customerName'] as String,
      price: map['price'] as int,
      orderStatus: map['orderStatus'] as String,
      orderDate: map['orderDate'] as Timestamp,
      dosage: map['dosage'] as String,
      drugImageURL: map['drugImageURL'] as String,
      customerImageURL: map['customerImageURL'] as String,
    );
  }

//</editor-fold>
}