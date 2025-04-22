import 'package:cloud_firestore/cloud_firestore.dart';

class PrescriptionInfo{
  final String prescId;
  final String prescGroupId;
  final String dosage;
  final Timestamp date;
  final Timestamp nextPickupDate;
  final String patientImgUrl;
  final String pharmacyId;
  final String patientId;
  final String doctorId;
  final String drugName;
  final String drugImgUrl;
  final String patientName;
  final String doctorName;
  final String pharmacyName;
  final bool beforeMeal;
  final bool isRepeating;
  final int noOfTimes;
  final int qty;
  final List<String> images;

//<editor-fold desc="Data Methods">
  const PrescriptionInfo({
    required this.prescId,
    required this.prescGroupId,
    required this.dosage,
    required this.date,
    required this.nextPickupDate,
    required this.patientImgUrl,
    required this.pharmacyId,
    required this.patientId,
    required this.doctorId,
    required this.drugName,
    required this.drugImgUrl,
    required this.patientName,
    required this.doctorName,
    required this.pharmacyName,
    required this.beforeMeal,
    required this.isRepeating,
    required this.noOfTimes,
    required this.qty,
    required this.images,
  });

  PrescriptionInfo copyWith({
    String? prescId,
    String? prescGroupId,
    String? dosage,
    Timestamp? date,
    Timestamp? nextPickupDate,
    String? patientImgUrl,
    String? pharmacyId,
    String? patientId,
    String? doctorId,
    String? drugName,
    String? drugImgUrl,
    String? patientName,
    String? doctorName,
    String? pharmacyName,
    bool? beforeMeal,
    bool? isRepeating,
    int? noOfTimes,
    int? qty,
    List<String>? images,
  }) {
    return PrescriptionInfo(
      prescId: prescId ?? this.prescId,
      prescGroupId: prescGroupId ?? this.prescGroupId,
      dosage: dosage ?? this.dosage,
      date: date ?? this.date,
      nextPickupDate: nextPickupDate ?? this.nextPickupDate,
      patientImgUrl: patientImgUrl ?? this.patientImgUrl,
      pharmacyId: pharmacyId ?? this.pharmacyId,
      patientId: patientId ?? this.patientId,
      doctorId: doctorId ?? this.doctorId,
      drugName: drugName ?? this.drugName,
      drugImgUrl: drugImgUrl ?? this.drugImgUrl,
      patientName: patientName ?? this.patientName,
      doctorName: doctorName ?? this.doctorName,
      pharmacyName: pharmacyName ?? this.pharmacyName,
      beforeMeal: beforeMeal ?? this.beforeMeal,
      isRepeating: isRepeating ?? this.isRepeating,
      noOfTimes: noOfTimes ?? this.noOfTimes,
      qty: qty ?? this.qty,
      images: images ?? this.images,
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'prescId': this.prescId,
      'prescGroupId': this.prescGroupId,
      'dosage': this.dosage,
      'date': this.date,
      'nextPickupDate': this.nextPickupDate,
      'patientImgUrl': this.patientImgUrl,
      'pharmacyId': this.pharmacyId,
      'patientId': this.patientId,
      'doctorId': this.doctorId,
      'drugName': this.drugName,
      'drugImgUrl': this.drugImgUrl,
      'patientName': this.patientName,
      'doctorName': this.doctorName,
      'pharmacyName': this.pharmacyName,
      'beforeMeal': this.beforeMeal,
      'isRepeating': this.isRepeating,
      'noOfTimes': this.noOfTimes,
      'qty': this.qty,
      'images': this.images,
    };
  }

  factory PrescriptionInfo.fromMap(Map<String, dynamic> map) {
    return PrescriptionInfo(
      prescId: map['prescId'] as String,
      prescGroupId: map['prescGroupId'] as String,
      dosage: map['dosage'] as String,
      date: map['date'] as Timestamp,
      nextPickupDate: map['nextPickupDate'] as Timestamp,
      patientImgUrl: map['patientImgUrl'] as String,
      pharmacyId: map['pharmacyId'] as String,
      patientId: map['patientId'] as String,
      doctorId: map['doctorId'] as String,
      drugName: map['drugName'] as String,
      drugImgUrl: map['drugImgUrl'] as String,
      patientName: map['patientName'] as String,
      doctorName: map['doctorName'] as String,
      pharmacyName: map['pharmacyName'] as String,
      beforeMeal: map['beforeMeal'] as bool,
      isRepeating: map['isRepeating'] as bool,
      noOfTimes: map['noOfTimes'] as int,
      qty: map['qty'] as int,
      images: map['images'] as List<String>,
    );
  }

//</editor-fold>
}