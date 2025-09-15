import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:fpdart/fpdart.dart';
import 'package:medifirst/core/constants/firebase_constants.dart';
import 'package:medifirst/core/providers/firebase_providers.dart';
import 'package:medifirst/core/utils/failure.dart';
import 'package:medifirst/core/utils/type_defs.dart';
import 'package:medifirst/models/appointment_info.dart';
import 'package:medifirst/models/doctor_info.dart';
import 'package:medifirst/models/rating_model.dart';
import 'package:medifirst/models/transaction_model.dart';
import 'package:medifirst/models/user_info.dart';

import '../../../models/wallet_info.dart';

final bookDoctorsRepoProvider = Provider<BookDoctorsRepository>((ref) {
  final firestore = ref.read(firestoreProvider);
  return BookDoctorsRepository(firestore: firestore);
});

class BookDoctorsRepository {
  final FirebaseFirestore _firestore;

  BookDoctorsRepository({required FirebaseFirestore firestore})
      : _firestore = firestore;

  CollectionReference get _users =>
      _firestore.collection(FirebaseConstants.usersCollection);

  CollectionReference get _doctors =>
      _firestore.collection(FirebaseConstants.doctorsCollection);

  CollectionReference get _appointments =>
      _firestore.collection(FirebaseConstants.appointmentsCollection);

  CollectionReference get _wallet =>
      _firestore.collection(FirebaseConstants.walletsCollection);

  CollectionReference get _transactions =>
      _firestore.collection(FirebaseConstants.transactionsCollection);

  Stream<List<DoctorInfo>> getDoctorList() {
    return _doctors.snapshots().map((event) {
      return event.docs
          .map((e) => DoctorInfo.fromMap(e.data() as Map<String, dynamic>))
          .toList();
    });
  }

  Stream<List<DoctorInfo>> getFavouriteDoctorsList(String uid) {
    return _doctors
        .where('favourites', arrayContains: uid)
        .snapshots()
        .map((event) {
      return event.docs
          .map((e) => DoctorInfo.fromMap(e.data() as Map<String, dynamic>))
          .toList();
    });
  }

  FutureEither<DoctorInfo> getDoctorFromId(String doctorId) async {
    try {
      final snapshot = await _doctors.doc(doctorId).get()
        ..data();
      final doctor =
          DoctorInfo.fromMap(snapshot.data() as Map<String, dynamic>);
      return right(doctor);
    } catch (e) {
      return left(Failure(e.toString()));
    }
  }

  Stream<List<RatingModel>> getDoctorReviews(String doctorId) {
    return _doctors
        .doc(doctorId)
        .collection(FirebaseConstants.reviewsCollection)
        .snapshots()
        .map((event) {
      return event.docs.map((e) => RatingModel.fromMap(e.data())).toList();
    });
  }

  FutureVoid setAppointment(AppointmentInfo appointment) async {
    try {
      await _appointments.doc(appointment.aID).set(appointment.toMap());
      return right(null);
    } on FirebaseException catch (e) {
      throw e.message!;
    } catch (e) {
      return left(Failure(e.toString()));
    }
  }

  Future<void> addDoctorToFavs(UserInfoModel user, String doctorId) async {
    if (!user.favDoctors.contains(doctorId)) {
      await _users.doc(user.uid).update({
        'favDoctors': FieldValue.arrayUnion([doctorId]),
      });
    } else {
      await _users.doc(user.uid).update({
        'favDoctors': FieldValue.arrayRemove([doctorId]),
      });
    }
  }

  Future<void> removeFeeFromBalance(String uid, int fee) async {
    await _wallet.doc(uid).update({
      'balance': FieldValue.increment(-1 * fee),
    });
    return;
  }

  Future<void> logTransaction(TransactionModel transaction) async {
    await _transactions.doc(transaction.transactionId).set(transaction.toMap());
    return;
  }

  Future<double> getWallet(String uid) async {
    DocumentSnapshot snapshot = await _wallet.doc(uid).get();
    WalletInfo map =
        WalletInfo.fromMap(snapshot.data() as Map<String, dynamic>);
    return map.balance;
  }
}
