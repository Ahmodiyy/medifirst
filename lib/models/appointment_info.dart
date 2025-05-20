import 'package:cloud_firestore/cloud_firestore.dart';

class AppointmentInfo{
  final String aID;
  final String doctorName;
  final String patientName;
  final int price;
  final String doctorId;
  final String patientId;
  final String doctorType;
  final String doctorImageURL;
  final String patientImageURL;
  final int type;
  final int status;
  final Timestamp startTime;
  final Timestamp endTime;
  final Timestamp reminder;
  final bool isScheduled;

//<editor-fold desc="Data Methods">
  const AppointmentInfo({
    required this.aID,
    required this.doctorName,
    required this.patientName,
    required this.price,
    required this.doctorId,
    required this.patientId,
    required this.doctorType,
    required this.doctorImageURL,
    required this.patientImageURL,
    required this.type,
    required this.status,
    required this.startTime,
    required this.endTime,
    required this.reminder,
    required this.isScheduled,
  });


  AppointmentInfo copyWith({
    String? aID,
    String? doctorName,
    String? patientName,
    int? price,
    String? doctorId,
    String? patientId,
    String? doctorType,
    String? doctorImageURL,
    String? patientImageURL,
    int? type,
    int? status,
    Timestamp? startTime,
    Timestamp? endTime,
    Timestamp? reminder,
    bool? isScheduled,
  }) {
    return AppointmentInfo(
      aID: aID ?? this.aID,
      doctorName: doctorName ?? this.doctorName,
      patientName: patientName ?? this.patientName,
      price: price ?? this.price,
      doctorId: doctorId ?? this.doctorId,
      patientId: patientId ?? this.patientId,
      doctorType: doctorType ?? this.doctorType,
      doctorImageURL: doctorImageURL ?? this.doctorImageURL,
      patientImageURL: patientImageURL ?? this.patientImageURL,
      type: type ?? this.type,
      status: status ?? this.status,
      startTime: startTime ?? this.startTime,
      endTime: endTime ?? this.endTime,
      reminder: reminder ?? this.reminder,
      isScheduled: isScheduled ?? this.isScheduled,
    );
  }


  Map<String, dynamic> toMap() {
    return {
      'aID': this.aID,
      'doctorName': this.doctorName,
      'patientName': this.patientName,
      'price': this.price,
      'doctorId': this.doctorId,
      'patientId': this.patientId,
      'doctorType': this.doctorType,
      'doctorImageURL': this.doctorImageURL,
      'patientImageURL': this.patientImageURL,
      'type': this.type,
      'status': this.status,
      'startTime': this.startTime,
      'endTime': this.endTime,
      'reminder': this.reminder,
      'isScheduled': this.isScheduled,
    };
  }

  factory AppointmentInfo.fromMap(Map<String, dynamic> map) {
    return AppointmentInfo(
      aID: map['aID'] as String,
      doctorName: map['doctorName'] as String,
      patientName: map['patientName'] as String,
      price: map['price'] as int,
      doctorId: map['doctorId'] as String,
      patientId: map['patientId'] as String,
      doctorType: map['doctorType'] as String,
      doctorImageURL: map['doctorImageURL'] as String,
      patientImageURL: map['patientImageURL'] as String,
      type: map['type'] as int,
      status: map['status'] as int,
      startTime: map['startTime'] as Timestamp,
      endTime: map['endTime'] as Timestamp,
      reminder: map['reminder'] as Timestamp,
      isScheduled: map['isScheduled'] as bool,
    );
  }


//</editor-fold>
}