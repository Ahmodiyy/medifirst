import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:medifirst/core/constants/firebase_constants.dart';
import 'package:medifirst/core/providers/firebase_providers.dart';
import 'package:medifirst/models/prescription_info.dart';

final doctorPrescriptionRepoProvider = Provider<DoctorPrescriptionRepository>((ref) {
  final firestore = ref.read(firestoreProvider);
  return DoctorPrescriptionRepository(firestore: firestore);
});

class DoctorPrescriptionRepository {
  final FirebaseFirestore _firestore;

  const DoctorPrescriptionRepository({
    required FirebaseFirestore firestore,
  }) : _firestore = firestore;

  CollectionReference get _prescriptions =>
      _firestore.collection(FirebaseConstants.prescriptionCollection);

  Stream<List<PrescriptionInfo>> getCurrentPrescriptions(String prescGroupId) {
    return _prescriptions
        .doc(prescGroupId)
        .collection(FirebaseConstants.prescriptionCollection)
        .snapshots()
        .map((event) =>
            event.docs.map((e) => PrescriptionInfo.fromMap(e.data())).toList());
  }
}
