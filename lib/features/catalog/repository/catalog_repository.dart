import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:medifirst/core/constants/firebase_constants.dart';
import 'package:medifirst/core/providers/firebase_providers.dart';
import 'package:medifirst/models/drug_info.dart';

final catalogRepoProvider = Provider<CatalogRepository>((ref) {
  final firestore = ref.watch(firestoreProvider);
  return CatalogRepository(firestore: firestore);
});

class CatalogRepository {
  final FirebaseFirestore _firestore;
  const CatalogRepository({required FirebaseFirestore firestore})
      : _firestore = firestore;

  CollectionReference get _practices =>
      _firestore.collection(FirebaseConstants.healthcarePracticesCollection);

  Stream<List<DrugInfo>> getPharmacyCatalog(String pharmacyId) {
    return _practices
        .doc(pharmacyId)
        .collection(FirebaseConstants.catalogCollection)
        .snapshots()
        .map((event) {
      return event.docs
          .map(
            (e) => DrugInfo.fromMap(
              e.data(),
            ),
          )
          .toList();
    });
  }
}
