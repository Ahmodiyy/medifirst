import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:medifirst/features/prescriptions/repository/prescription_repository.dart';

import '../../../models/prescription_info.dart';

final prescriptionControllerProvider = Provider<PrescriptionController>((ref) {
  final repo = ref.read(prescriptionRepoProvider);
  return PrescriptionController(repo: repo);
});

final getTodayPrescriptionProvider = StreamProvider.family((ref, String uid) {
  return ref.read(prescriptionControllerProvider).getTodayPrescriptions(uid);
});

final getScheduledPrescriptionProvider = StreamProvider.family((ref, String uid) {
  return ref.read(prescriptionControllerProvider).getScheduledPrescriptions(uid);
});

final getUserPrescriptionProvider = StreamProvider.family((ref, String uid) {
  return ref.read(prescriptionControllerProvider).getUserPrescriptions(uid);
});

class PrescriptionController{
  final PrescriptionRepository _repo;

  const PrescriptionController({
    required PrescriptionRepository repo,
  }) : _repo = repo;

  Stream<List<PrescriptionInfo>> getTodayPrescriptions(String uid){
    return _repo.getTodayPrescriptions(uid);
  }

  Stream<List<PrescriptionInfo>> getScheduledPrescriptions(String uid){
    return _repo.getScheduledPrescriptions(uid);
  }

  Stream<List<PrescriptionInfo>> getUserPrescriptions(String uid){
    return _repo.getUserPrescriptions(uid);
  }
}