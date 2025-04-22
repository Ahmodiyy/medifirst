import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:medifirst/models/healthcare_centre_info.dart';

import '../../../models/doctor_info.dart';
import '../../../models/prescription_info.dart';
import '../../../models/user_info.dart';
import '../repository/location_repository.dart';

final locationControllerProvider = Provider<LocationController>((ref) {
  final repo = ref.watch(locationRepoProvider);
  return LocationController(repo: repo);
});

final getPracticesProvider = StreamProvider((ref){
  return ref.watch(locationControllerProvider).getPractices();
});

final getDoctorsProvider = StreamProvider((ref){
  return ref.watch(locationControllerProvider).getDoctors();
});

final getFavDoctorsProvider = StreamProvider.family((ref, UserInfoModel user){
  return ref.watch(locationControllerProvider).getFavoriteDoctors(user);
});

final getFavPracticesProvider = StreamProvider.family((ref, UserInfoModel user){
  return ref.watch(locationControllerProvider).getFavoritePractices(user);
});

class LocationController {
  final LocationRepository _repo;
  LocationController({required LocationRepository repo})
      : _repo = repo;

  Stream<List<HealthcareCentreInfo>> getPractices(){
    return _repo.getPractices();
  }

  Stream<List<DoctorInfo>> getDoctors(){
    return _repo.getDoctors();
  }

  Stream<List<DoctorInfo>> getFavoriteDoctors(UserInfoModel user){
    return _repo.getFavoriteDoctors(user);
  }

  Stream<List<HealthcareCentreInfo>> getFavoritePractices(UserInfoModel user){
    return _repo.getFavoritePractices(user);
  }

  Future<String> uploadPrescriptionsToPharmacy(HealthcareCentreInfo pharmacy, List<PrescriptionInfo> prescriptions) async{
    for(PrescriptionInfo prescription in prescriptions){
      prescription = prescription.copyWith(pharmacyId: pharmacy.pId, pharmacyName: pharmacy.name,);
    }
    final res = await _repo.uploadPrescriptionsToPharmacy(pharmacy, prescriptions);
    res.fold((l){
      throw Exception('An error occurred');
    }, (r) => null);
    return 'Success';
  }
}
