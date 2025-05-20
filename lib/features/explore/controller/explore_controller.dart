import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:medifirst/features/explore/repository/explore_repository.dart';
import 'package:medifirst/models/medication_info.dart';
import 'package:medifirst/models/order_info.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../models/appointment_info.dart';
import '../../../models/doctor_info.dart';

final exploreControllerProvider = Provider<ExploreController>((ref) {
  final repo =  ref.read(exploreRepoProvider);
  return ExploreController(repo: repo);
});

final nextAppointmentsProvider = StreamProvider.family.autoDispose((ref, String uid) {
  return ref.read(exploreControllerProvider).getNextAppointments(uid);

});


final nextMedicationProvider = FutureProvider.family((ref, String uid) async {
  return ref.read(exploreControllerProvider).getNextMedication(uid);
});

final nextOrderProvider = FutureProvider.family((ref, String uid) async {
  return ref.read(exploreControllerProvider).getNextOrder(uid);
});

final topRatedDoctorsProvider = StreamProvider((ref){
  return ref.watch(exploreControllerProvider).getTopRatedDoctors();
});

final doctorSearchResultsProvider = StreamProvider.family.autoDispose((ref, String query) {
  final stream = ref.read(exploreControllerProvider).getDoctorSearchResults(query);
  return stream.map((event) {
    print('Stream event received: ${event.length} doctors');
    return event;
  }).handleError((error) {
    print('Error in doctorSearchResultsProvider: $error');
    return [];
  });
});

class ExploreController{
  final ExploreRepository _repo;
  ExploreController({required ExploreRepository repo}): _repo = repo;

  Stream<List<AppointmentInfo>> getNextAppointments(String uid){
    return _repo.getUserAppointments(uid);
  }

  Future<MedicationInfo> getNextMedication(String uid)async{
    List<MedicationInfo> list =  await _repo.getUserMedication(uid).first;
    return list[0];
  }

  Future<OrderInfo> getNextOrder(String uid)async{
    List<OrderInfo> list =  await _repo.getUserOrders(uid).first;
    return list[0];
  }

  Stream<List<DoctorInfo>> getTopRatedDoctors(){
    return _repo.getTopRatedDoctors();
  }

  Stream<List<DoctorInfo>> getDoctorSearchResults(String query){
    return _repo.getDoctorSearchResults(query);
  }
}
