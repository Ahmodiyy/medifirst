import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:medifirst/models/appointment_info.dart';
import 'package:medifirst/models/doctor_info.dart';
import 'package:medifirst/models/medication_info.dart';
import 'package:medifirst/models/order_info.dart';

import '../../../core/constants/firebase_constants.dart';
import '../../../core/providers/firebase_providers.dart';

final exploreRepoProvider = Provider((ref) {
  final firestore = ref.read(firestoreProvider);
  final storageRepo = ref.read(storageRepositoryProvider);
  return ExploreRepository(
      firestore: firestore, ref: ref, storageRepo: storageRepo);
});

class ExploreRepository {
  final FirebaseFirestore _firestore;
  final FirebaseStorageRepository _storageRepo;
  final Ref _ref;
  ExploreRepository(
      {required FirebaseFirestore firestore,
      required Ref ref,
      required FirebaseStorageRepository storageRepo})
      : _firestore = firestore,
        _ref = ref,
        _storageRepo = storageRepo;

  CollectionReference get _appointments =>
      _firestore.collection(FirebaseConstants.appointmentsCollection);

  CollectionReference get _users =>
      _firestore.collection(FirebaseConstants.usersCollection);

  CollectionReference get _doctors =>
      _firestore.collection(FirebaseConstants.doctorsCollection);

  Stream<List<AppointmentInfo>> getUserAppointments(String uid) async* {
    try {
      List<AppointmentInfo> appointments = [];
      final snapshots = _appointments
          .where('patientId', isEqualTo: uid)
          .orderBy('startTime', descending: true)
          .snapshots();
      await for (var snapshot in snapshots) {
        appointments = snapshot.docs.map((e) {
          return AppointmentInfo.fromMap(e.data() as Map<String, dynamic>);
        }).toList();

        yield appointments;
      }
    } catch (e) {
      print('Error in explore repo  : $e');
      rethrow;
    }
  }

  Stream<List<MedicationInfo>> getUserMedication(String uid) {
    return _users
        .doc(uid)
        .collection('medication')
        .orderBy('pickupDate', descending: true)
        .snapshots()
        .map((event) {
      List<MedicationInfo> medication = [];
      for (var doc in event.docs) {
        medication.add(MedicationInfo.fromMap(doc.data()));
      }
      return medication;
    });
  }

  Stream<List<OrderInfo>> getUserOrders(String uid) {
    return _users
        .doc(uid)
        .collection(FirebaseConstants.ordersCollection)
        .orderBy('orderDate', descending: true)
        .snapshots()
        .map((event) {
      List<OrderInfo> orders = [];
      for (var doc in event.docs) {
        orders.add(OrderInfo.fromMap(doc.data()));
      }
      return orders;
    });
  }

  Stream<List<DoctorInfo>> getTopRatedDoctors() {
    return _doctors
        .orderBy('avgRating', descending: true)
        .snapshots()
        .map((event) {
      List<DoctorInfo> doctors = [];
      for (var doc in event.docs) {
        doctors.add(DoctorInfo.fromMap(doc.data() as Map<String, dynamic>));
      }
      return doctors;
    });
  }

  // Repository function to fetch doctor search results based on the query
  Stream<List<DoctorInfo>> getDoctorSearchResults(String query) {
    print('-----------${query}---------');

    return _doctors.snapshots().map((snapshot) {
      List<DoctorInfo> doctors = [];

      for (var doc in snapshot.docs) {
        var doctor = DoctorInfo.fromMap(doc.data() as Map<String, dynamic>);

        // Filtering doctors based on the query match in either name or surname
        if (doctor.name.toLowerCase().contains(query.toLowerCase()) ||
            doctor.surname.toLowerCase().contains(query.toLowerCase()) ||
            doctor.profession.toLowerCase().contains(query.toLowerCase())) {
          doctors.add(doctor);
        }
      }

      print('----------${doctors.length}---------');
      return doctors;
    });
  }

  Future<void> updateRefundHeld({
    required AppointmentInfo appt,
    required bool refundHeld,
  }) async {
    try {
      await _appointments.doc(appt.aID).update({
        'refundHeld': refundHeld,
      });
      await _doctors
          .doc(appt.doctorId)
          .collection(FirebaseConstants.appointmentsCollection)
          .doc(appt.aID)
          .update({
        'refundHeld': refundHeld,
      });
      print('refundHeld field updated successfully');
    } catch (e) {
      print('Error updating refundHeld: $e');
    }
  }
}
