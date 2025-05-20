import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:medifirst/features/catalog/repository/catalog_repository.dart';

import '../../../models/drug_info.dart';

final catalogControllerProvider = Provider<CatalogController>((ref) {
  final repo = ref.read(catalogRepoProvider);
  return CatalogController(repo: repo);
});

final getCatalogProvider = StreamProvider.family((ref, String pharmacyId) {
  return ref.read(catalogControllerProvider).getPharmacyCatalog(pharmacyId);
});

class CatalogController {
  final CatalogRepository _repo;
  CatalogController({required CatalogRepository repo}) : _repo = repo;

  Stream<List<DrugInfo>> getPharmacyCatalog(String pharmacyId){
    return _repo.getPharmacyCatalog(pharmacyId);
  }
}
