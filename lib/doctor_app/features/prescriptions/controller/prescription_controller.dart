import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:medifirst/doctor_app/features/prescriptions/repository/prescription_repository.dart';

import '../../../../models/prescription_info.dart';

final doctorPrescriptionControllerProvider = Provider<PrescriptionController>((ref) {
  final repo = ref.read(doctorPrescriptionRepoProvider);
  return PrescriptionController(repo: repo);
});

final getCurrentPrescriptionsProvider = StreamProvider.family((ref, String prescGroupId) {
  return ref.read(doctorPrescriptionControllerProvider).getCurrentPrescriptions(prescGroupId);
});

class PrescriptionController{
  final DoctorPrescriptionRepository _repo;

  const PrescriptionController({
    required DoctorPrescriptionRepository repo,
  }) : _repo = repo;

  Stream<List<PrescriptionInfo>> getCurrentPrescriptions(String prescGroupId){
    return _repo.getCurrentPrescriptions(prescGroupId);
  }
}