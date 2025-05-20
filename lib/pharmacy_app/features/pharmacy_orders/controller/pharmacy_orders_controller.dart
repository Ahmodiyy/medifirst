import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:medifirst/pharmacy_app/features/pharmacy_orders/repository/pharmacy_orders_repository.dart';

import '../../../../models/order_info.dart';

final pharmacyOrdersControllerProvider = Provider<PharmacyOrdersController>((ref) {
  final repo = ref.read(pharmacyOrdersRepoProvider);
  return PharmacyOrdersController(repo: repo);
});

final pharmacyOrdersProvider = StreamProvider.family((ref, String pId) {
  final controller = ref.read(pharmacyOrdersControllerProvider);
  return controller.getPharmacyOrders(pId);
});

class PharmacyOrdersController{
  final PharmacyOrdersRepository _repo;

  const PharmacyOrdersController({
    required PharmacyOrdersRepository repo,
  }) : _repo = repo;

  Stream<List<OrderInfo>> getPharmacyOrders(String pId){
    return _repo.getPharmacyOrders(pId);
  }
}