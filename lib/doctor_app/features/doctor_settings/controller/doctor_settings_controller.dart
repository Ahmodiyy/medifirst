import 'dart:typed_data';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';

import '../../../../core/providers/firebase_providers.dart';
import '../../../../models/doctor_info.dart';
import '../../../../models/wallet_info.dart';
import '../repository/doctor_settings_repository.dart';

final doctorSettingsControllerProvider =
    Provider<DoctorSettingsController>((ref) {
  final repo = ref.read(doctorSettingsRepoProvider);
  final storageRepo = ref.read(storageRepositoryProvider);
  return DoctorSettingsController(repo: repo, storageRepo: storageRepo);
});

final doctorSettingsInfoProvider = StreamProvider.family((ref, String id) {
  final controller = ref.read(doctorSettingsRepoProvider);
  return controller.getDoctorInfo(id);
});

final doctorWalletProvider = StreamProvider.family((ref, String id) {
  final controller = ref.read(doctorSettingsRepoProvider);
  return controller.getDoctorWallet(id);
});

class DoctorSettingsController {
  final DoctorSettingsRepository _repo;
  final FirebaseStorageRepository _storageRepo;

  const DoctorSettingsController({
    required DoctorSettingsRepository repo,
    required FirebaseStorageRepository storageRepo,
  })  : _repo = repo,
        _storageRepo = storageRepo;

  Stream<DoctorInfo> getDoctorInfo(String id) {
    return _repo.getDoctorInfo(id);
  }

  Stream<WalletInfo> getDoctorWallet(String doctorId){
    return _repo.getDoctorWallet(doctorId);
  }

  Future<void> saveFirstPage({
    required DoctorInfo doc,
    Uint8List? image,
    required String imageFallback,
     String? firstName,
     String? surname,
     String? age,
     String? number,
     String? address,
     String? state,
     String? lga,
     String? profession,
     String? bio,
     LatLng? latLng,
  }) async {
    debugPrint('------doctor saving continue');
    String? profilePic;
    if (image != null) {
      debugPrint('------image is not null');
      final res = await _storageRepo.storeImage(
          path: 'profile-pictures', id: doc.doctorId, file: image);
      res.fold((l) {
        print('doctor profile image is :  $profilePic');
        throw l.error;
      }, (r) {
        print('doctor profile image is  not :  $profilePic');
        profilePic = r;
      });
    }
    final result = await _repo.saveFirstPage(
        doc: doc,
        image: profilePic ?? imageFallback,
        firstName: firstName,
        surname: surname,
        age: age,
        number: number,
        address: address,
        state: state,
        lga: lga,
        profession: profession,
        bio: bio,
        latLng: latLng);
    result.fold((l) {
      throw l.error;
    }, (r) => null);
  }

  Future<void> saveSecondPage({
    required DoctorInfo doc,
     String? yearsOfExp,
     String? licenseNo,
     String? qualifications,
     String? consultationFee,
     TimeOfDay? openTime,
     TimeOfDay? closeTime,
     List<Uint8List>? certificateImage,
  }) async {
    List<String> urls = [];
    if(certificateImage!.length > 0 ) {
      print("--------------certificate is  not null----------");
      //if (certificateImage.isNotEmpty) {
        for (Uint8List image in certificateImage!) {
          print("--------------uploading doctor certificate----------");
          final res = await _storageRepo.storeImage(
              path: 'doctors-certificates', id: '${doc.doctorId}${image.toString()}', file: image);
          print('----------uploaded certificate url  ${res.toString()}');
          res.fold((l) {
            throw l.error;
          }, (r) {
            urls.add(r);
          });
        }
     // }
    }
    else{
      print("--------------certificate null-------------");
    }
    final res = await _repo.saveSecondPage(
        doc: doc,
        yearsOfExp: int.tryParse(yearsOfExp ?? doc.yearsOfExperience.toString()),
        licenseNo: licenseNo,
        qualifications: qualifications,
        openingHours: openTime,
        closingHours: closeTime,
        consultationFee: int.tryParse(consultationFee??doc.consultationFee.toString()),
        certificateImage: urls);
    res.fold((l) {
      throw l.error;
    }, (r) => null);
  }

  Future<void> withdrawFunds({required String doctorId, required double amount, required String accountNumber})async{
    try{
      final res = await _repo.withdrawFunds(doctorId: doctorId, amount: amount, accountNumber: accountNumber);
      res.fold((l){
        throw Exception(l.error);
      }, (r) => null);
    }catch(e){
      rethrow;
    }
  }
}
