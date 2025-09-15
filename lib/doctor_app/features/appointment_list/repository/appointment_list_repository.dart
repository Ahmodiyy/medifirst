import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:medifirst/core/constants/firebase_constants.dart';
import 'package:medifirst/core/providers/firebase_providers.dart';
import 'package:medifirst/models/appointment_info.dart';

final appointmentListRepoProvider = Provider<AppointmentListRepository>((ref) {
  final firestore = ref.read(firestoreProvider);
  return AppointmentListRepository(firestore: firestore);
});

class AppointmentListRepository {
  final FirebaseFirestore _firestore;

  const AppointmentListRepository({required FirebaseFirestore firestore})
      : _firestore = firestore;

  CollectionReference get _doctors =>
      _firestore.collection(FirebaseConstants.doctorsCollection);

  CollectionReference get _appointments =>
      _firestore.collection(FirebaseConstants.appointmentsCollection);

  Stream<List<AppointmentInfo>> getAllDoctorAppointments(String doctorId) {
    return _appointments
        .where('doctorId', isEqualTo: doctorId)
        .snapshots()
        .map((event) {
      return event.docs
          .map((e) => AppointmentInfo.fromMap(e.data() as Map<String, dynamic>))
          .toList();
    });
  }

  Stream<List<AppointmentInfo>> getDoctorAppointmentRequests(String doctorId) {
    return _appointments
        .where('doctorId', isEqualTo: doctorId)
        .where('status', isEqualTo: 1)
        .snapshots()
        .map((event) {
      return event.docs.map((e) {
        return AppointmentInfo.fromMap(e.data() as Map<String, dynamic>);
      }).toList();
    });
  }

  Stream<List<AppointmentInfo>> getDoctorAppointment(String doctorId) {
    return _appointments
        .where('doctorId', isEqualTo: doctorId)
        .where('status', isEqualTo: 2)
        .snapshots()
        .map((event) {
      return event.docs.map((e) {
        return AppointmentInfo.fromMap(e.data() as Map<String, dynamic>);
      }).toList();
    });
  }

  Stream<List<AppointmentInfo>> getDoctorVideoAppointments(String doctorId) {
    return _appointments
        .where('doctorId', isEqualTo: doctorId)
        .where('type', isEqualTo: 1)
        .where('status', isEqualTo: 2)
        .orderBy("startTime", descending: true)
        .snapshots()
        .map((event) {
      return event.docs
          .map((e) => AppointmentInfo.fromMap(e.data() as Map<String, dynamic>))
          .toList();
    });
  }

  Stream<List<AppointmentInfo>> getDoctorVoiceAppointments(String doctorId) {
    return _appointments
        .where('doctorId', isEqualTo: doctorId)
        .where('type', isEqualTo: 2)
        .where('status', isEqualTo: 2)
        .orderBy('startTime', descending: true)
        .snapshots()
        .map((event) {
      return event.docs
          .map((e) => AppointmentInfo.fromMap(e.data() as Map<String, dynamic>))
          .toList();
    });
  }

  Stream<List<AppointmentInfo>> getDoctorChatAppointments(String doctorId) {
    return _appointments
        .where('doctorId', isEqualTo: doctorId)
        .where('type', isEqualTo: 3)
        .where('status', isEqualTo: 2)
        .orderBy("startTime", descending: true)
        .snapshots()
        .map((event) {
      return event.docs
          .map((e) => AppointmentInfo.fromMap(e.data() as Map<String, dynamic>))
          .toList();
    });
  }

  Future<void> acceptAppointmentRequest(AppointmentInfo appt) async {
    try {
      await _appointments.doc(appt.aID).set(appt.toMap());
    } on FirebaseException catch (e) {
      throw Exception(e.message!);
    } catch (e) {
      rethrow;
    }
  }

  Future<void> rejectAppointmentRequest(AppointmentInfo appt) async {
    try {
      await _appointments.doc(appt.aID).set(appt.toMap());
    } on FirebaseException catch (e) {
      throw Exception(e.message!);
    } catch (e) {
      rethrow;
    }
  }
}
