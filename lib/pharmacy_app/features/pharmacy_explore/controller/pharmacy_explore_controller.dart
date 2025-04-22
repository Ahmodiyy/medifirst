import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:medifirst/pharmacy_app/features/pharmacy_explore/repository/pharmacy_explore_repository.dart';

import '../../../../models/order_info.dart';
import '../../../../models/prescription_info.dart';


final pharmaExploreControllerProvider = Provider<PharmacyExploreController>((ref) {
  final repo = ref.read(pharmaExploreRepoProvider);
  return PharmacyExploreController(repo: repo);
});

final getPharmaOrdersTotalProvider = StreamProvider.family((ref, String pId) {
  final controller = ref.read(pharmaExploreControllerProvider);
  return controller.getPharmacyOrdersTotal(pId: pId);
});

final getPharmaPrescriptionsProvider = StreamProvider.family((ref, String pId) {
  final controller = ref.read(pharmaExploreControllerProvider);
  return controller.getPharmacyPrescriptions(pId);
});

final getPharmaOrdersProvider = StreamProvider.family((ref, String pId) {
  final controller = ref.read(pharmaExploreControllerProvider);
  return controller.getPharmacyOrders(pId);
});

class PharmacyExploreController{
  final PharmacyExploreRepository _repo;

  const PharmacyExploreController({
    required PharmacyExploreRepository repo,
  }) : _repo = repo;

  Stream<int> getPharmacyOrdersTotal({required String pId}){
    return _repo.getPharmacyOrdersTotal(pId: pId);
  }

  Stream<List<PrescriptionInfo>> getPharmacyPrescriptions(String pId){
    return _repo.getPharmacyPrescriptions(pId);
  }

  Stream<List<OrderInfo>> getPharmacyOrders(String pId) {
    return _repo.getPharmacyOrders(pId);
  }
}