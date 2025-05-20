import 'package:cloud_firestore/cloud_firestore.dart';

class MedicationInfo{
  final String drugId;
  final String drugName;
  final bool isRefill;
  final Timestamp pickupDate;
  final String dosage;
  final String drugImageURL;

//<editor-fold desc="Data Methods">
  const MedicationInfo({
    required this.drugId,
    required this.drugName,
    required this.isRefill,
    required this.pickupDate,
    required this.dosage,
    required this.drugImageURL,
  });

  MedicationInfo copyWith({
    String? drugId,
    String? drugName,
    bool? isRefill,
    Timestamp? pickupDate,
    String? dosage,
    String? drugImageURL,
  }) {
    return MedicationInfo(
      drugId: drugId ?? this.drugId,
      drugName: drugName ?? this.drugName,
      isRefill: isRefill ?? this.isRefill,
      pickupDate: pickupDate ?? this.pickupDate,
      dosage: dosage ?? this.dosage,
      drugImageURL: drugImageURL ?? this.drugImageURL,
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'drugId': drugId,
      'drugName': drugName,
      'isRefill': isRefill,
      'pickupDate': pickupDate,
      'dosage': dosage,
      'drugImageURL': drugImageURL,
    };
  }

  factory MedicationInfo.fromMap(Map<String, dynamic> map) {
    return MedicationInfo(
      drugId: map['drugId'] as String,
      drugName: map['drugName'] as String,
      isRefill: map['isRefill'] as bool,
      pickupDate: map['pickupDate'] as Timestamp,
      dosage: map['dosage'] as String,
      drugImageURL: map['drugImageURL'] as String,
    );
  }

//</editor-fold>
}