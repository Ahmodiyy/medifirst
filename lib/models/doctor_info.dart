import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

class DoctorInfo{
  final String name;
  final String surname;
  final String doctorImage;
  final String doctorId;
  final String profession;
  final String number;
  final String address;
  final double? latitude;
  final double? longitude;
  final TimeOfDay openingHours;
  final TimeOfDay closingHours;
  final int numberOfReviews;
  final int totalRating;
  final double avgRating;
  final int consultationFee;
  final String licenseNumber;
  final int age;
  final String bio;
  final String state;
  final String lga;
  final String fcmToken;
  final int yearsOfExperience;
  final List<String> certificateImages;
  final String qualifications;
  final List<String> favourites;
  final DateTime licenseExpiration;

//<editor-fold desc="Data Methods">
  const DoctorInfo({
    required this.name,
    required this.surname,
    required this.doctorId,
    required this.doctorImage,
    required this.profession,
    required this.address,
    this.longitude = 0.0,
    this.latitude = 0.0,
    this.fcmToken = '',
    required this.number,
    required this.openingHours,
    required this.closingHours,
    required this.numberOfReviews,
    required this.totalRating,
    required this.avgRating,
    required this.consultationFee,
    required this.licenseNumber,
    required this.age,
    required this.bio,
    required this.state,
    required this.lga,
    required this.yearsOfExperience,
    required this.certificateImages,
    required this.qualifications,
    required this.favourites,
    required this.licenseExpiration,
  });

  DoctorInfo copyWith({
    String? name,
    String? surname,
    String? doctorId,
    String? doctorImage,
    String? profession,
    String? address,
    double? latitude,
    double? longitude,
    String? number,
    String? fcmToken,
    TimeOfDay? openingHours,
    TimeOfDay? closingHours,
    int? numberOfReviews,
    int? totalRatings,
    double? avgRating,
    int? consultationFee,
    String? licenseNumber,
    int? age,
    String? bio,
    String? state,
    String? lga,
    int? yearsOfExperience,
    List<String>? certificateImages,
    String? qualifications,
    List<String>? favourites,
    DateTime? licenseExpiration
  }) {
    this.certificateImages.addAll(certificateImages ?? []);
    return DoctorInfo(
      name: name ?? this.name,
      surname: surname ?? this.surname,
      doctorId: doctorId ?? this.doctorId,
      doctorImage: doctorImage ?? this.doctorImage,
      profession: profession ?? this.profession,
      number: number ?? this.number,
      address: address ?? this.address,
      latitude: latitude ?? this.latitude,
      longitude: longitude ?? this.longitude,
      openingHours: openingHours ?? this.openingHours,
      closingHours: closingHours ?? this.closingHours,
      numberOfReviews: numberOfReviews ?? this.numberOfReviews,
      totalRating: totalRatings ?? totalRating,
      avgRating: avgRating ?? this.avgRating,
      consultationFee: consultationFee ?? this.consultationFee,
      licenseNumber: licenseNumber ?? this.licenseNumber,
      age: age ?? this.age,
      bio: bio ?? this.bio,
      state: state ?? this.state,
      lga: lga ?? this.lga,
      fcmToken: fcmToken ?? this.fcmToken,
      yearsOfExperience: yearsOfExperience ?? this.yearsOfExperience,
      certificateImages: this.certificateImages,
      qualifications: qualifications ?? this.qualifications,
      favourites: favourites ?? this.favourites,
        licenseExpiration : licenseExpiration?? this.licenseExpiration
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'name': name,
      'surname': surname,
      'doctorId': doctorId,
      'doctorImage': doctorImage,
      'profession': profession,
      'number': number,
      'address': address,
      'latitude': latitude,
      'longitude': longitude,
      'openingHours': ("${openingHours.hour}*${openingHours.minute}"),
      'closingHours': ("${closingHours.hour}*${closingHours.minute}"),
      'numberOfReviews': numberOfReviews,
      'totalRating': totalRating,
      'avgRating': avgRating,
      'consultationFee': consultationFee,
      'licenseNumber': licenseNumber,
      'age': age,
      'bio': bio,
      'state': state,
      'lga': lga,
      'fcmToken': fcmToken,
      'yearsOfExperience': yearsOfExperience,
      'certificateImages': certificateImages,
      'qualifications': qualifications,
      'favourites': favourites,
      'licenseExpiration': licenseExpiration,
    };
  }

  factory DoctorInfo.fromMap(Map<String, dynamic> map) {
    final TimeOfDay openingHours = TimeOfDay(
        hour: int.parse(map['openingHours'].toString().split("*").first),
        minute: int.parse(map['openingHours'].toString().split("*").last),);
    final TimeOfDay closingHours = TimeOfDay(
      hour: int.parse(map['closingHours'].toString().split("*").first),
      minute: int.parse(map['closingHours'].toString().split("*").last),);
    return DoctorInfo(
      name: map['name'] as String,
      surname: map['surname'] as String,
      doctorId: map['doctorId'] as String,
      doctorImage: map['doctorImage'] as String,
      profession: map['profession'] as String,
      number: map['number'] as String,
      address: map['address'] as String,
      latitude: map['latitude'] != null ? map['latitude'].toDouble() : 0.0,
      longitude: map['longitude'] != null ? map['longitude'].toDouble() : 0.0,
      openingHours: openingHours,
      closingHours: closingHours,
      numberOfReviews: map['numberOfReviews'] as int,
      totalRating: map['totalRating'] as int,
      avgRating: map['avgRating'] as double,
      consultationFee: map['consultationFee'] as int,
      licenseNumber: map['licenseNumber'] as String,
      age: map['age'] as int,
      bio: map['bio'] as String,
      state: map['state'] as String,
      lga: map['lga'] as String,
      fcmToken: map['fcmToken'] as String,
      yearsOfExperience: map['yearsOfExperience'] as int,
      certificateImages: List<String>.from(map['certificateImages']),
      qualifications: map['qualifications'] as String,
      favourites: List<String>.from(map['favourites']),
      licenseExpiration: (map['licenseExpiration'] as Timestamp?)?.toDate() ?? DateTime.now(),
    );
  }

//</editor-fold>
}