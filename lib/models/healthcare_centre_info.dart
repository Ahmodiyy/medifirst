import 'package:flutter/material.dart';

class HealthcareCentreInfo{
  final double latitude;
  final double longitude;
  final String pId;
  final String name;
  final String address;
  final String pharmacyImgUrl;
  final String number;
  final String emergencyContact;
  final String state;
  final String lga;
  final String type;
  final TimeOfDay openingHours;
  final TimeOfDay closingHours;
  final int totalRating;
  final int noOfReviews;

//<editor-fold desc="Data Methods">
  const HealthcareCentreInfo({
    required this.latitude,
    required this.longitude,
    required this.pId,
    required this.name,
    required this.address,
    required this.pharmacyImgUrl,
    required this.number,
    required this.emergencyContact,
    required this.state,
    required this.lga,
    required this.type,
    required this.openingHours,
    required this.closingHours,
    required this.totalRating,
    required this.noOfReviews,
  });


  HealthcareCentreInfo copyWith({
    double? latitude,
    double? longitude,
    String? pId,
    String? name,
    String? address,
    String? pharmacyImgUrl,
    String? number,
    String? emergencyContact,
    String? state,
    String? lga,
    String? type,
    TimeOfDay? openingHours,
    TimeOfDay? closingHours,
    int? totalRating,
    int? noOfReviews,
  }) {
    return HealthcareCentreInfo(
      latitude: latitude ?? this.latitude,
      longitude: longitude ?? this.longitude,
      pId: pId ?? this.pId,
      name: name ?? this.name,
      address: address ?? this.address,
      pharmacyImgUrl: pharmacyImgUrl ?? this.pharmacyImgUrl,
      number: number ?? this.number,
      emergencyContact: emergencyContact ?? this.emergencyContact,
      state: state ?? this.state,
      lga: lga ?? this.lga,
      type: type ?? this.type,
      openingHours: openingHours ?? this.openingHours,
      closingHours: closingHours ?? this.closingHours,
      totalRating: totalRating ?? this.totalRating,
      noOfReviews: noOfReviews ?? this.noOfReviews,
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'latitude': latitude,
      'longitude': longitude,
      'pId': pId,
      'name': name,
      'address': address,
      'pharmacyImgUrl': pharmacyImgUrl,
      'number': number,
      'emergencyContact': emergencyContact,
      'state': state,
      'lga': lga,
      'type': type,
      'openingHours': ("${openingHours.hour}*${openingHours.minute}"),
      'closingHours': ("${closingHours.hour}*${closingHours.minute}"),
      'totalRating': totalRating,
      'noOfReviews': noOfReviews,
    };
  }

  factory HealthcareCentreInfo.fromMap(Map<String, dynamic> map) {
    final TimeOfDay openingHours = TimeOfDay(
      hour: int.parse(map['openingHours'].toString().split("*").first),
      minute: int.parse(map['openingHours'].toString().split("*").last),);
    final TimeOfDay closingHours = TimeOfDay(
      hour: int.parse(map['closingHours'].toString().split("*").first),
      minute: int.parse(map['closingHours'].toString().split("*").last),);
    return HealthcareCentreInfo(
      latitude: map['latitude'] as double,
      longitude: map['longitude'] as double,
      pId: map['pId'] as String,
      name: map['name'] as String,
      address: map['address'] as String,
      pharmacyImgUrl: map['pharmacyImgUrl'] as String,
      number: map['number'] as String,
      emergencyContact: map['emergencyContact'] as String,
      state: map['state'] as String,
      lga: map['lga'] as String,
      type: map['type'] as String,
      openingHours: openingHours,
      closingHours: closingHours,
      totalRating: map['totalRating'] as int,
      noOfReviews: map['noOfReviews'] as int,
    );
  }

//</editor-fold>
}