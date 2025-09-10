import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:medifirst/features/book_doctors/repository/book_doctors_repository.dart';
import 'package:medifirst/models/appointment_info.dart';
import 'package:medifirst/models/transaction_model.dart';
import 'package:medifirst/models/user_info.dart';
import 'package:uuid/uuid.dart';

//s.dart';
import '../../../models/doctor_info.dart';
import '../../../models/rating_model.dart';

final getDoctorListProvider = StreamProvider((ref) {
  return ref.read(bookDoctorsControllerProvider).getDoctorList();
});

final getFavDoctorsListProvider = StreamProvider.family((ref, String uid) {
  return ref.read(bookDoctorsControllerProvider).getFavouriteDoctorsList(uid);
});

final getDoctorByIdProvider =
    FutureProvider.family((ref, String doctorId) async {
  return ref.read(bookDoctorsControllerProvider).getDoctorFromId(doctorId);
});

final getDoctorReviewsProvider = StreamProvider.family((ref, String doctorId) {
  return ref.read(bookDoctorsControllerProvider).getDoctorReviews(doctorId);
});

final bookDoctorsControllerProvider = Provider<BookDoctorsController>((ref) {
  final repo = ref.read(bookDoctorsRepoProvider);
  return BookDoctorsController(repo: repo);
});

class BookDoctorsController {
  final BookDoctorsRepository _repo;

  BookDoctorsController({required BookDoctorsRepository repo}) : _repo = repo;

  Stream<List<DoctorInfo>> getDoctorList() {
    return _repo.getDoctorList();
  }

  Stream<List<DoctorInfo>> getFavouriteDoctorsList(String uid) {
    return _repo.getFavouriteDoctorsList(uid);
  }

  Future<DoctorInfo?> getDoctorFromId(String doctorId) async {
    DoctorInfo? doctor;
    final req = await _repo.getDoctorFromId(doctorId);
    req.fold((l) {
      throw Exception('An error occurred');
    }, (r) {
      doctor = r;
    });
    return doctor;
  }

  Stream<List<RatingModel>> getDoctorReviews(String doctorId) {
    return _repo.getDoctorReviews(doctorId);
  }

  Future<void> setAppointment(
      {required DoctorInfo doctor,
      required UserInfoModel patient,
      required int type,
      required DateTime startTime,
      required Duration reminder,
      required bool isScheduled}) async {
    final aID = const Uuid().v4();
    DateTime endTime = startTime.add(const Duration(hours: 1));
    DateTime remindTime = startTime.subtract(reminder);
    final AppointmentInfo appointment = AppointmentInfo(
        aID: aID,
        doctorName: doctor.name,
        patientName: patient.name,
        price: doctor.consultationFee,
        doctorId: doctor.doctorId,
        patientId: patient.uid,
        doctorType: doctor.profession,
        doctorImageURL: doctor.doctorImage,
        patientImageURL: patient.profilePicture,
        type: type,
        status: 1,
        startTime: Timestamp.fromDate(startTime),
        endTime: Timestamp.fromDate(endTime),
        reminder: Timestamp.fromDate(remindTime),
        isScheduled: isScheduled,
        appointmentHeld: false,
        paymentHeld: false,
        refundHeld: false);
    final res = await _repo.setAppointment(appointment);
    res.fold((l) {
      throw Exception(l.error);
    }, (r) async {});
  }

  Future<void> logTransaction(
      String uid, double amount, String doctorId) async {
    final transId = const Uuid().v4();
    final TransactionModel userTransaction = TransactionModel(
        transactionId: transId,
        amount: amount,
        bank: '',
        type: 3,
        uid: uid,
        date: Timestamp.fromDate(DateTime.now()),
        recipientId: doctorId,
        isCompleted: true,
        isDebit: true);
    final TransactionModel docTransaction = TransactionModel(
        transactionId: transId,
        amount: amount,
        bank: '',
        type: 4,
        uid: uid,
        date: Timestamp.fromDate(DateTime.now()),
        recipientId: doctorId,
        isCompleted: true,
        isDebit: true);
    await _repo.logTransaction(userTransaction);
    await _repo.logTransaction(docTransaction);
    return;
  }

  Future<void> addDoctorToFavs(UserInfoModel user, String doctorId) async {
    await _repo.addDoctorToFavs(user, doctorId);
  }

  Future<double> getWallet(String uid) async {
    return await _repo.getWallet(uid);
  }

  Future<void> removeFeeFromBalance(String uid, int fee) async {
    await _repo.removeFeeFromBalance(uid, fee);
    return;
  }
}
