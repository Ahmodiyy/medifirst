import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:medifirst/core/constants/firebase_constants.dart';
import 'package:medifirst/core/providers/firebase_providers.dart';
import 'package:medifirst/models/prescription_info.dart';

final prescriptionRepoProvider = Provider<PrescriptionRepository>((ref) {
  final firestore = ref.read(firestoreProvider);
  return PrescriptionRepository(firestore: firestore);
});

class PrescriptionRepository {
  final FirebaseFirestore _firestore;

  const PrescriptionRepository({
    required FirebaseFirestore firestore,
  }) : _firestore = firestore;

  CollectionReference get _prescriptions =>
      _firestore.collection(FirebaseConstants.prescriptionCollection);

  Stream<List<PrescriptionInfo>> getTodayPrescriptions(String uid) {
    return _prescriptions
        .where('patientId', isEqualTo: uid)
        .orderBy('nextPickupDate', descending: true)
        .snapshots().map((event){
          List<PrescriptionInfo> list = [];
          for(var doc in event.docs){
            PrescriptionInfo prescription = PrescriptionInfo.fromMap(doc.data() as Map<String, dynamic>);
            if(prescription.date.toDate().month == DateTime.now().month && prescription.date.toDate().day == DateTime.now().day && prescription.date.toDate().year == DateTime.now().year){
              list.add(prescription);
            }else{
              break;
            }
          }
          return list;
    });
  }

  Stream<List<PrescriptionInfo>> getScheduledPrescriptions(String uid) {
    return _prescriptions
        .where('patientId', isEqualTo: uid)
        .orderBy('nextPickupDate', descending: true)
        .snapshots()
        .map((event){
      List<PrescriptionInfo> list = [];
      for(var doc in event.docs){
        PrescriptionInfo prescription = PrescriptionInfo.fromMap(doc.data() as Map<String, dynamic>);
        if(prescription.date.toDate().month == DateTime.now().month && prescription.date.toDate().day == DateTime.now().day && prescription.date.toDate().year == DateTime.now().year){
          continue;
        }else{
          list.add(prescription);
        }
      }
      return list;
    });
  }

  Stream<List<PrescriptionInfo>> getUserPrescriptions(String uid) {
    return _prescriptions
        .where('patientId', isEqualTo: uid)
        .orderBy('nextPickupDate', descending: true)
        .snapshots().map((event) => event.docs.map((e) => PrescriptionInfo.fromMap(e.data() as Map<String, dynamic>)).toList());
  }
}
