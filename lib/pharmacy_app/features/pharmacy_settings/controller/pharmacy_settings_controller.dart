import 'dart:typed_data';

import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:medifirst/core/providers/firebase_providers.dart';
import 'package:medifirst/core/utils/failure.dart';
import 'package:medifirst/models/doctor_info.dart';
import 'package:medifirst/pharmacy_app/features/pharmacy_settings/repository/pharmacy_settings_repository.dart';

import '../../../../models/healthcare_centre_info.dart';
import '../../../../models/wallet_info.dart';

final pharmacySettingsControllerProvider = Provider<PharmacySettingsController>((ref) {
  final storageRepo = ref.read(storageRepositoryProvider);
  final repo = ref.read(pharmacySettingsRepoProvider);
  return PharmacySettingsController(storageRepo: storageRepo, repo: repo);
});

final getPharmacyDetailsProvider = StreamProvider.family((ref, String id) {
  final controller = ref.read(pharmacySettingsControllerProvider);
  return controller.getPharmacyInfo(id);
});

final getPharmacyWalletProvider = StreamProvider.family((ref, String id) {
  final controller = ref.read(pharmacySettingsControllerProvider);
  return controller.getPharmacyWalletInfo(id);
});

class PharmacySettingsController{
  final FirebaseStorageRepository _storageRepo;
  final PharmacySettingsRepository _repo;

  const PharmacySettingsController({
    required FirebaseStorageRepository storageRepo,
    required PharmacySettingsRepository repo,
  })  : _storageRepo = storageRepo,
        _repo = repo;

  Stream<HealthcareCentreInfo> getPharmacyInfo(String id){
    return _repo.getPharmacyInfo(id);
  }

  Stream<WalletInfo> getPharmacyWalletInfo(String id) {
    return _repo.getPharmacyWalletInfo(id);
  }

  Future<void> updateProfile(String? name, String? number, String? address, String? state, String? lga, String? emergencyContact, Uint8List? image, HealthcareCentreInfo pharmacy, LatLng latLng)async{
    try{
      String? profilePic;
      if (image != null) {
        final res = await _storageRepo.storeImage(
            path: 'profile-pictures', id: pharmacy.pId, file: image);
        res.fold((l) {
          throw l.error;
        }, (r) {
          profilePic = r;
        });
      }
      final Map<String, dynamic> newValues = {
        'name': name ?? pharmacy.name,
        'address': address  ?? pharmacy.address,
        'pharmacyImgUrl': profilePic ?? pharmacy.pharmacyImgUrl,
        'number': number ?? pharmacy.number,
        'emergencyContact': emergencyContact ?? pharmacy.emergencyContact,
        'state': state ?? pharmacy.state,
        'lga': lga ?? pharmacy.lga,
        'latitude': (latLng.latitude == 0)?  pharmacy.latitude: latLng.latitude,
        'longitude': (latLng.longitude == 0)? pharmacy.longitude: latLng.longitude,
      };
      final res = await _repo.updateProfile(newValues: newValues, pId: pharmacy.pId);
      res.fold((l){
        throw Exception(l.error);
      }, (r) => null);
    }catch(e){
      rethrow;
    }
  }

  Future<void> withdrawFunds({required String pId, required double amount, required String accountNumber})async{
    try{
      final res = await _repo.withdrawFunds(pId: pId, amount: amount, accountNumber: accountNumber);
      res.fold((l){
        throw Exception(l.error);
      }, (r) => null);
    }catch(e){
      rethrow;
    }
  }
}