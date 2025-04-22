import 'dart:typed_data';

import 'package:flutter/cupertino.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:medifirst/core/providers/firebase_providers.dart';

import '../../../core/constants/constants.dart';
import '../../../models/user_info.dart';
import '../../../models/wallet_info.dart';
import '../repository/settings_repository.dart';

final settingsControllerProvider = Provider<SettingsController>((ref) {
  final repo = ref.read(settingsRepoProvider);
  final storageRepo = ref.read(storageRepositoryProvider);
  return SettingsController(repo: repo, storageRepo: storageRepo);
});

final userSettingsInfoProvider = StreamProvider.family((ref, String id) {
  final controller = ref.read(settingsControllerProvider);
  return controller.getUserInfo(id);
});

final patientWalletProvider = StreamProvider.family((ref, String id) {
  final controller = ref.read(settingsControllerProvider);
  return controller.getPatientWallet(id);
});

class SettingsController {
  final SettingsRepository _repo;
  final FirebaseStorageRepository _storageRepo;

  const SettingsController({
    required SettingsRepository repo,
    required FirebaseStorageRepository storageRepo,
  })  : _repo = repo,
        _storageRepo = storageRepo;

  Stream<UserInfoModel> getUserInfo(String id) {
    return _repo.getUserInfo(id);
  }

  Stream<WalletInfo> getPatientWallet(String uid){
    return _repo.getPatientWallet(uid);
  }

  Future<void> saveFirstPage({
    required UserInfoModel user,
    Uint8List? image,
     String? imageFallback,
     String? firstName,
     String? surname,
     String? age,
     String? number,
     String? address,
     String? state,
     String? lga,
     String? occupation,
     String? emergencyContact,
     LatLng? latLng,
  }) async {
    String? profilePic;
    if (image != null) {
      final res = await _storageRepo.storeImage(
          path: 'profile-pictures', id: user.uid, file: image);
      res.fold((l) {
        throw l.error;
      }, (r) {
        profilePic = r;
      });
    }
    final result;
    if(image != null){
      print('image is not null');
      result = await _repo.saveFirstPageWithPicture(
          user: user,
          image: profilePic,
          firstName: firstName,
          surname: surname,
          age: age,
          number: number,
          address: address,
          state: state,
          lga: lga,
          occupation: occupation,
          emergencyContact: emergencyContact,
          latLng: latLng,
          profilePicture: profilePic
      );
    }
    else{
      print('image is null');
      result = await _repo.saveFirstPage(
      user: user,
      image: profilePic,
      firstName: firstName,
      surname: surname,
      age: age,
      number: number,
      address: address,
      state: state,
      lga: lga,
      occupation: occupation,
      emergencyContact: emergencyContact,
      latLng: latLng,
    );}
    result.fold((l) {
      throw l.error;
    }, (r){
    return null;
    });
  }

  Future<void> saveSecondPage({
    required UserInfoModel user,
    required String uid,
     String? bp,
     String? weight,
     String? height,
     String? bmi,
     String? surgicalHistory,
     String? genotype,
     String? bloodGroup,
     String? geneticDisorder,
     String? medicalDisorder,
  }) async {
    final res = await _repo.saveSecondPage(
      user: user,
      uid: uid,
      bp: bp,
      weight: double.tryParse(weight??user.weight.toString()),
      height: int.tryParse(height??user.height.toString()),
      bmi: double.tryParse(bmi??user.bmi.toString()),
      surgicalHistory: surgicalHistory,
      genotype: genotype,
      bloodGroup: bloodGroup,
      geneticDisorder: geneticDisorder,
      medicalDisorder: medicalDisorder,
    );
    res.fold((l) {
      throw l.error;
    }, (r) => null);
  }

  Future<void> depositFunds({required String uid, required double amount, required String accountNumber})async{
    try{
      final res = await _repo.depositFunds(uid: uid, amount: amount, accountNumber: accountNumber);
      res.fold((l){
        throw Exception(l.error);
      }, (r) => null);
    }catch(e){
      rethrow;
    }
  }

  Future<void> verifyPayment(String reference, double amount) async {
    _repo.verifyPayment(reference, amount);
  }

  Future<void> initiatePayment(double amount, String email) async {
    _repo.initiatePayment(amount, email);
  }
}
