import 'dart:typed_data';

import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:medifirst/core/providers/firebase_providers.dart';
import 'package:medifirst/models/drug_info.dart';
import 'package:medifirst/pharmacy_app/features/edit_catalog/repository/edit_catalog_repository.dart';
import 'package:uuid/uuid.dart';

final editCatalogControllerProvider = Provider<EditCatalogController>((ref) {
  final repo = ref.read(editCatalogRepoProvider);
  final storageRepo = ref.read(storageRepositoryProvider);
  return EditCatalogController(repo: repo, storageRepo: storageRepo);
});

class EditCatalogController {
  final EditCatalogRepository _repo;
  final FirebaseStorageRepository _storageRepo;

  const EditCatalogController({
    required EditCatalogRepository repo,
    required FirebaseStorageRepository storageRepo,
  })  : _repo = repo,
        _storageRepo = storageRepo;

  Future<void> addDrugToCatalog({
    required Uint8List image,
    required String pId,
    required String drugName,
    required String price,
    required List<String> sideFx,
    required String pharmacyName,
  }) async {
    String? drugImgUrl;
    String drugId = const Uuid().v1();
    final res = await _storageRepo.storeImage(
        path: 'drug-images/$pId', id: drugId, file: image);
    res.fold((l) {
      throw l.error;
    }, (r) {
      drugImgUrl = r;
    });
    final DrugInfo drug = DrugInfo(
        drugId: drugId,
        pharmacyId: pId,
        drugName: drugName,
        price: int.parse(price),
        dosage: '',
        drugImageURL: drugImgUrl!,
        sideEffects: sideFx,
        curableSymptoms: [],
        totalRating: 0,
        numberOfReviews: 0,
        aboutDrug: '',
        brandName: '',
        pharmacyName: pharmacyName);
    final result = await _repo.addDrugToCatalog(drug: drug);
    result.fold((l) {
      throw l.error;
    }, (r) => null);
  }

  Future<void> editDrugInCatalog({required Uint8List image, required String drugId, required String pId})async{
    String? drugImgUrl;
    String drugId = const Uuid().v1();
    final res = await _storageRepo.storeImage(
        path: 'drug-images/$pId', id: drugId, file: image);
    res.fold((l) {
      throw l.error;
    }, (r) {
      drugImgUrl = r;
    });
    final result = await _repo.editDrugInCatalog(drugImgUrl: drugImgUrl!, drugId: drugId, pharmacyId: pId);
    result.fold((l) {
      throw l.error;
    }, (r) => null);
  }

  Future<void> uploadBatchDrugs({required List<List<dynamic>> data, required String pharmacyId, required String pharmacyName})async{
    final res = await _repo.uploadBatchDrugs(data: data, pharmacyId: pharmacyId, pharmacyName: pharmacyName);
    res.fold((l){
      throw Exception(l.error);
    }, (r) => null);
  }
}
