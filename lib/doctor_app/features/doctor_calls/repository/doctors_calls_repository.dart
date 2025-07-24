import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:medifirst/core/constants/firebase_constants.dart';
import 'package:medifirst/core/providers/firebase_providers.dart';

import '../../../../models/appointment_info.dart';

final doctorChatRepoProvider = Provider<ChatRepository>((ref) {
  final firestore = ref.read(firestoreProvider);
  return ChatRepository(firestore: firestore);
});

class ChatRepository {
  final FirebaseFirestore _firestore;

  const ChatRepository({
    required FirebaseFirestore firestore,
  }) : _firestore = firestore;

  CollectionReference get _appointments =>
      _firestore.collection(FirebaseConstants.appointmentsCollection);

  CollectionReference get _doctors =>
      _firestore.collection(FirebaseConstants.doctorsCollection);

  Future<void> updateAppointmentHeld({
    required AppointmentInfo appt,
    required bool appointmentHeld,
  }) async {
    try {
      await _appointments.doc(appt.aID).update({
        'appointmentHeld': appointmentHeld,
      });
      await _doctors
          .doc(appt.doctorId)
          .collection(FirebaseConstants.appointmentsCollection)
          .doc(appt.aID)
          .update({
        'appointmentHeld': appointmentHeld,
      });
      print('appointmentHeld field updated successfully');
    } catch (e) {
      print('Error updating appointmentHeld: $e');
    }
  }

  Future<void> updatePaymentHeld({
    required AppointmentInfo appt,
    required bool paymentHeld,
  }) async {
    try {
      await _appointments.doc(appt.aID).update({
        'paymentHeld': paymentHeld,
      });
      await _doctors
          .doc(appt.doctorId)
          .collection(FirebaseConstants.appointmentsCollection)
          .doc(appt.aID)
          .update({
        'paymentHeld': paymentHeld,
      });
      print('paymentHeld field updated successfully');
    } catch (e) {
      print('Error updating paymentHeld: $e');
    }
  }
}
