import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:medifirst/core/constants/firebase_constants.dart';
import 'package:medifirst/core/providers/firebase_providers.dart';
import 'package:medifirst/models/order_info.dart';

final pharmacyOrdersRepoProvider = Provider<PharmacyOrdersRepository>((ref) {
  final firestore = ref.read(firestoreProvider);
  return PharmacyOrdersRepository(firestore: firestore);
});

class PharmacyOrdersRepository{
  final FirebaseFirestore _firestore;

  const PharmacyOrdersRepository({
    required FirebaseFirestore firestore,
  }) : _firestore = firestore;

  CollectionReference get _practices => _firestore.collection(FirebaseConstants.healthcarePracticesCollection);

  Stream<List<OrderInfo>> getPharmacyOrders(String pId){
    return _practices.doc(pId).collection(FirebaseConstants.ordersCollection).snapshots().map((event) {
      return event.docs
          .map(
              (e) => OrderInfo.fromMap(e.data()))
          .toList();
    });
  }
}