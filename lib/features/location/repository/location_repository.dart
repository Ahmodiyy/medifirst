import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:fpdart/fpdart.dart';
import 'package:medifirst/core/constants/firebase_constants.dart';
import 'package:medifirst/core/providers/firebase_providers.dart';
import 'package:medifirst/core/utils/failure.dart';
import 'package:medifirst/models/doctor_info.dart';
import 'package:medifirst/models/user_info.dart';

import '../../../core/utils/type_defs.dart';
import '../../../models/healthcare_centre_info.dart';
import '../../../models/prescription_info.dart';

final locationRepoProvider = Provider<LocationRepository>((ref) {
  final firestore = ref.read(firestoreProvider);
  return LocationRepository(firestore: firestore);
});

class LocationRepository {
  final FirebaseFirestore _firestore;

  LocationRepository({required FirebaseFirestore firestore})
      : _firestore = firestore;

  CollectionReference get _practices =>
      _firestore.collection(FirebaseConstants.healthcarePracticesCollection);

  CollectionReference get _doctors =>
      _firestore.collection(FirebaseConstants.doctorsCollection);

  CollectionReference get _prescriptions =>
      _firestore.collection(FirebaseConstants.prescriptionCollection);

  Stream<List<HealthcareCentreInfo>> getPractices() {
    return _practices.snapshots().map((event) {
      return event.docs
          .map(
            (e) => HealthcareCentreInfo.fromMap(
              e.data() as Map<String, dynamic>,
            ),
          )
          .toList();
    });
  }

  Stream<List<DoctorInfo>> getDoctors() {
    return _doctors.snapshots().map((event) {
      return event.docs
          .map(
            (e) => DoctorInfo.fromMap(
              e.data() as Map<String, dynamic>,
            ),
          )
          .toList();
    });
  }

  Stream<List<DoctorInfo>> getFavoriteDoctors(UserInfoModel user) {
    if (user.favDoctors.isEmpty) {
      throw 'No favourite';
    }
    return _doctors
        .where('doctorId', whereIn: user.favDoctors)
        .snapshots()
        .map((event) {
      return event.docs
          .map(
            (e) => DoctorInfo.fromMap(
              e.data() as Map<String, dynamic>,
            ),
          )
          .toList();
    });
  }

  Stream<List<HealthcareCentreInfo>> getFavoritePractices(UserInfoModel user) {
    return _practices
        .where('pId', whereIn: user.favDoctors)
        .snapshots()
        .map((event) {
      return event.docs
          .map(
            (e) => HealthcareCentreInfo.fromMap(
              e.data() as Map<String, dynamic>,
            ),
          )
          .toList();
    });
  }

  FutureVoid uploadPrescriptionsToPharmacy(HealthcareCentreInfo pharmacy,
      List<PrescriptionInfo> prescriptions) async {
    try {
      for (PrescriptionInfo prescription in prescriptions) {
        await _prescriptions.doc(pharmacy.pId).set(pharmacy.toMap());
      }
      return right(null);
    } on FirebaseException catch (e) {
      throw e.message!;
    } catch (e) {
      return left(Failure('An error occurred'));
    }
  }
}
