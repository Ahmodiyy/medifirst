import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:medifirst/core/constants/firebase_constants.dart';
import 'package:medifirst/core/providers/firebase_providers.dart';
import 'package:medifirst/models/order_info.dart';

import '../../../../models/prescription_info.dart';

final pharmaExploreRepoProvider = Provider<PharmacyExploreRepository>((ref) {
  final firestore = ref.read(firestoreProvider);
  return PharmacyExploreRepository(firestore: firestore);
});

class PharmacyExploreRepository {
  final FirebaseFirestore _firestore;

  const PharmacyExploreRepository({
    required FirebaseFirestore firestore,
  }) : _firestore = firestore;

  CollectionReference get _practices =>
      _firestore.collection(FirebaseConstants.healthcarePracticesCollection);

  CollectionReference get _prescriptions =>
      _firestore.collection(FirebaseConstants.prescriptionCollection);

  Stream<int> getPharmacyOrdersTotal({required String pId}) {
    return _practices
        .doc(pId)
        .collection(FirebaseConstants.ordersCollection)
        .snapshots()
        .map((event) {
      int number = 0;
      event.docs.map((e) {
        final item = OrderInfo.fromMap(e.data());
        number++;
      });
      return number;
    });
  }

  Stream<List<PrescriptionInfo>> getPharmacyPrescriptions(String pId) {
    return _prescriptions.where('pharmacyId', isEqualTo: pId).orderBy('date', descending: true)
        .snapshots()
        .map((event) =>
            event.docs.map((e) => PrescriptionInfo.fromMap(e.data() as Map<String, dynamic>)).toList());
  }

  Stream<List<OrderInfo>> getPharmacyOrders(String pId) {
    return _practices
        .doc(pId)
        .collection(FirebaseConstants.ordersCollection)
        .snapshots()
        .map((event) =>
        event.docs.map((e) => OrderInfo.fromMap(e.data())).toList());
  }

}
