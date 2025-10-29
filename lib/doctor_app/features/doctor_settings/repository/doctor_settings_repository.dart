import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:fpdart/fpdart.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:medifirst/core/constants/firebase_constants.dart';
import 'package:medifirst/models/doctor_info.dart';
import 'package:uuid/uuid.dart';

import '../../../../core/providers/firebase_providers.dart';
import '../../../../core/utils/failure.dart';
import '../../../../core/utils/type_defs.dart';
import '../../../../models/transaction_model.dart';
import '../../../../models/wallet_info.dart';

final doctorSettingsRepoProvider = Provider<DoctorSettingsRepository>((ref) {
  final firestore = ref.read(firestoreProvider);
  return DoctorSettingsRepository(firestore: firestore);
});

class DoctorSettingsRepository {
  final FirebaseFirestore _firestore;

  const DoctorSettingsRepository({
    required FirebaseFirestore firestore,
  }) : _firestore = firestore;

  CollectionReference get _doctors =>
      _firestore.collection(FirebaseConstants.doctorsCollection);

  CollectionReference get _wallets =>
      _firestore.collection(FirebaseConstants.walletsCollection);

  CollectionReference get _transactions =>
      _firestore.collection(FirebaseConstants.transactionsCollection);

  Stream<DoctorInfo> getDoctorInfo(String id) {
    return _doctors.doc(id).snapshots().map(
        (event) => DoctorInfo.fromMap(event.data() as Map<String, dynamic>));
  }

  Stream<WalletInfo> getDoctorWallet(String doctorId) {
    return _wallets.doc(doctorId).snapshots().map(
        (event) => WalletInfo.fromMap(event.data() as Map<String, dynamic>));
  }

  FutureVoid saveFirstPage({
    required DoctorInfo doc,
    String? image,
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
    try {
      final newDoc = doc.copyWith(
        doctorImage: image,
        name: firstName,
        surname: surname,
        age: int.tryParse(age ?? doc.age.toString()),
        number: number,
        address: address,
        state: state,
        lga: lga,
        profession: profession,
        bio: bio,
        latitude: latLng?.latitude,
        longitude: latLng?.longitude,
      );
      await _doctors.doc(doc.doctorId).update(newDoc.toMap());
      return right(null);
    } on FirebaseException catch (e) {
      throw e.message!;
    } catch (e) {
      return left(Failure(e.toString()));
    }
  }

  FutureVoid saveSecondPage({
    required DoctorInfo doc,
    int? yearsOfExp,
    String? licenseNo,
    String? qualifications,
    int? consultationFee,
    TimeOfDay? openingHours,
    TimeOfDay? closingHours,
    List<String>? certificateImage,
  }) async {
    try {
      final newDoc = doc.copyWith(
        yearsOfExperience: yearsOfExp,
        licenseNumber: licenseNo,
        qualifications: qualifications,
        consultationFee: consultationFee,
        openingHours: openingHours,
        closingHours: closingHours,
        certificateImages: certificateImage,
      );
      await _doctors.doc(doc.doctorId).update(newDoc.toMap());
      return right(null);
    } on FirebaseException catch (e) {
      throw e.message!;
    } catch (e) {
      return left(Failure(e.toString()));
    }
  }

  FutureVoid withdrawFunds(
      {required String doctorId,
      required double amount,
      required String accountNumber}) async {
    try {
      final String transactionId = const Uuid().v4();
      final TransactionModel transaction = TransactionModel(
          transactionId: transactionId,
          amount: amount,
          type: 1,
          uid: doctorId,
          date: Timestamp.fromDate(DateTime.now()),
          recipientId: doctorId,
          isCompleted: false,
          isDebit: true,
          accountNumber: accountNumber,
          bank: '');
      await _transactions.doc(transactionId).set(transaction.toMap());
      await _wallets.doc(doctorId).update({
        'balance': FieldValue.increment(amount * -1),
      });
      return right(null);
    } on FirebaseException catch (e) {
      throw e.message!;
    } catch (e) {
      return left(Failure(e.toString()));
    }
  }

  Future<void> requestAccountDeletion(String email, String uid) async {
    try {
      await _firestore
          .collection('doctorAccountDeletionRequests')
          .doc(uid) // one doc per user
          .set({
        'uid': uid,
        'email': email,
        'requestedAt': FieldValue.serverTimestamp(),
      });
    } catch (e) {
      rethrow;
    }
  }
}
