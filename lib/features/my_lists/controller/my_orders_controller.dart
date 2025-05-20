import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:medifirst/models/medication_info.dart';
import 'package:medifirst/models/prescription_info.dart';

import '../../../models/order_info.dart';
import '../repository/my_orders_repository.dart';

final myOrdersControllerProvider = Provider((ref){
  final MyOrdersRepository repo = ref.read(myOrdersRepoProvider);
  return MyOrdersController(repo: repo);
});

final getUsersOrdersProvider = StreamProvider.family((ref, String uid) {
  return ref.read(myOrdersControllerProvider).getUsersOrder(uid);
});

final getUsersPrescriptionsProvider = StreamProvider.family((ref, String uid) {
  return ref.read(myOrdersControllerProvider).getUsersPrescriptions(uid);
});

class MyOrdersController{
  final MyOrdersRepository _repo;
  const MyOrdersController({required MyOrdersRepository repo}): _repo = repo;

  Stream<List<OrderInfo>> getUsersOrder(String uid){
    return _repo.getUsersOrder(uid);
  }

  Stream<List<PrescriptionInfo>> getUsersPrescriptions(String uid){
    return _repo.getUsersPrescriptions(uid);
  }
}