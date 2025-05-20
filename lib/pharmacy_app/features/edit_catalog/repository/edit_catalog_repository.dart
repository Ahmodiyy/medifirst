import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:fpdart/fpdart.dart';
import 'package:medifirst/core/constants/firebase_constants.dart';
import 'package:medifirst/core/providers/firebase_providers.dart';
import 'package:medifirst/core/utils/failure.dart';
import 'package:medifirst/models/drug_info.dart';
import 'package:uuid/uuid.dart';

import '../../../../core/utils/type_defs.dart';

final editCatalogRepoProvider = Provider<EditCatalogRepository>((ref) {
  final firestore = ref.read(firestoreProvider);
  return EditCatalogRepository(firestore: firestore);
});

class EditCatalogRepository{
  final FirebaseFirestore _firestore;

  const EditCatalogRepository({
    required FirebaseFirestore firestore,
  }) : _firestore = firestore;

  CollectionReference get _practices => _firestore.collection(FirebaseConstants.healthcarePracticesCollection);

  FutureVoid addDrugToCatalog({required DrugInfo drug})async{
    try{
      await _practices.doc(drug.pharmacyId).collection(FirebaseConstants.catalogCollection).doc(drug.drugId).set(drug.toMap());
      return right(null);
    }on FirebaseException catch(e){
      throw e.message!;
    }catch(e){
      return left(Failure(e.toString()));
    }
  }

  FutureVoid editDrugInCatalog({required String drugImgUrl, required String drugId, required String pharmacyId})async{
    try{
      await _practices.doc(pharmacyId).collection(FirebaseConstants.catalogCollection).doc(drugId).update({
        'drugImageURL': drugImgUrl,
      });
      return right(null);
    }on FirebaseException catch(e){
      throw e.message!;
    }catch(e){
      return left(Failure(e.toString()));
    }
  }

  FutureVoid uploadBatchDrugs({required List<List<dynamic>> data, required String pharmacyId, required String pharmacyName})async{
    try{
      for(var row in data){
        DrugInfo drug = DrugInfo(drugId: const Uuid().v4(), pharmacyId: pharmacyId, drugName: row[0], price: row[1], dosage: row[2], drugImageURL: '', sideEffects: [], curableSymptoms: [], totalRating: 0, numberOfReviews: 0, aboutDrug: '', brandName: row[3], pharmacyName: pharmacyName);
        await _practices.doc(pharmacyId).collection(FirebaseConstants.catalogCollection).doc(drug.drugId).set(drug.toMap());
      }
      return right(null);
    }on FirebaseException catch(e){
      throw e.message!;
    }catch(e){
      return left(Failure('An error occurred'));
    }
  }
}