import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:medifirst/core/constants/firebase_constants.dart';
import 'package:medifirst/core/providers/firebase_providers.dart';
import 'package:medifirst/models/order_info.dart';
import 'package:medifirst/models/prescription_info.dart';

import '../../../models/medication_info.dart';


final myOrdersRepoProvider = Provider<MyOrdersRepository>((ref) {
  final firestore = ref.read(firestoreProvider);
  return MyOrdersRepository(firestore: firestore);
});

class MyOrdersRepository{
  final FirebaseFirestore _firestore;
  const MyOrdersRepository({required FirebaseFirestore firestore}): _firestore = firestore;

  CollectionReference get _users => _firestore.collection(FirebaseConstants.usersCollection);
  
  CollectionReference get _prescriptions => _firestore.collection(FirebaseConstants.prescriptionCollection);

  Stream<List<OrderInfo>> getUsersOrder(String uid){
    return _users.doc(uid).collection(FirebaseConstants.ordersCollection).snapshots().map((event){
      return event.docs.map((e) => OrderInfo.fromMap(e.data())).toList();
    });
  }

  Stream<List<PrescriptionInfo>> getUsersPrescriptions(String uid){
    return _prescriptions.where('patientId', isEqualTo: uid).orderBy('pickupDate', descending: true).snapshots().map((event){
      return event.docs.map((e) => PrescriptionInfo.fromMap(e.data() as Map<String, dynamic>)).toList();
    });
  }
}