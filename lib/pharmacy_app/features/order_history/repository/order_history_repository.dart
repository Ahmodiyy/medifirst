import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:medifirst/core/constants/firebase_constants.dart';
import 'package:medifirst/core/providers/firebase_providers.dart';
import 'package:medifirst/models/order_info.dart';

final orderHistoryRepoProvider = Provider<OrderHistoryRepository>((ref) {
  final firestore = ref.read(firestoreProvider);
  return OrderHistoryRepository(firestore: firestore);
});

class OrderHistoryRepository {
  final FirebaseFirestore _firestore;

  const OrderHistoryRepository({
    required FirebaseFirestore firestore,
  }) : _firestore = firestore;

  CollectionReference get _practices =>
      _firestore.collection(FirebaseConstants.healthcarePracticesCollection);

  Stream<List<OrderInfo>> getPharmacyOrderHistory(String pId) {
    return _practices
        .doc(pId)
        .collection(FirebaseConstants.ordersCollection)
        .snapshots()
        .map((event) =>
            event.docs.map((e) => OrderInfo.fromMap(e.data())).toList());
  }
}
