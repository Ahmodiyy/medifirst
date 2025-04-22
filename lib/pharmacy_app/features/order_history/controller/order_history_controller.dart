import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../../models/order_info.dart';
import '../repository/order_history_repository.dart';

final orderHistoryControllerProvider = Provider<OrderHistoryController>((ref) {
  final repo = ref.read(orderHistoryRepoProvider);
  return OrderHistoryController(repo: repo);
});

final getPharmacyOrderHistoryProvider = StreamProvider.family((ref, String pId) {
  final controller = ref.read(orderHistoryControllerProvider);
  return controller.getPharmacyOrderHistory(pId);
});

class OrderHistoryController{
  final OrderHistoryRepository _repo;

  const OrderHistoryController({
    required OrderHistoryRepository repo,
  }) : _repo = repo;

  Stream<List<OrderInfo>> getPharmacyOrderHistory(String pId){
    return _repo.getPharmacyOrderHistory(pId);
  }
}