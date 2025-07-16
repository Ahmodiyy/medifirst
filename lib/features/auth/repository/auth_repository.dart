import 'dart:async';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:fpdart/fpdart.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:medifirst/core/constants/constants.dart';
import 'package:medifirst/models/doctor_info.dart';
import 'package:medifirst/models/healthcare_centre_info.dart';
import 'package:medifirst/models/user_info.dart' as model;
import 'package:medifirst/models/wallet_info.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../../../core/constants/firebase_constants.dart';
import '../../../core/providers/firebase_providers.dart';
import '../../../core/utils/failure.dart';
import '../../../core/utils/type_defs.dart';

final authRepoProvider = Provider((ref) {
  final auth = ref.read(firebaseAuthProvider);
  final firestore = ref.read(firestoreProvider);
  final storageRepo = ref.read(storageRepositoryProvider);
  final google = ref.read(googleProvider);
  return AuthRepository(
      auth: auth,
      firestore: firestore,
      googleSignIn: google,
      ref: ref,
      storageRepo: storageRepo);
});

final smsCodeProvider = StateProvider<String?>((ref) => null);
int? _forceResendingToken;
String? _verificationId;

class AuthRepository {
  final FirebaseAuth _auth;
  final FirebaseFirestore _firestore;
  final GoogleSignIn _googleSignIn;
  final FirebaseStorageRepository _storageRepo;
  final Ref _ref;

  AuthRepository(
      {required FirebaseAuth auth,
      required FirebaseFirestore firestore,
      required GoogleSignIn googleSignIn,
      required Ref ref,
      required FirebaseStorageRepository storageRepo})
      : _auth = auth,
        _firestore = firestore,
        _googleSignIn = googleSignIn,
        _ref = ref,
        _storageRepo = storageRepo;

  CollectionReference get _users =>
      _firestore.collection(FirebaseConstants.usersCollection);

  CollectionReference get _doctors =>
      _firestore.collection(FirebaseConstants.doctorsCollection);

  CollectionReference get _practices =>
      _firestore.collection(FirebaseConstants.healthcarePracticesCollection);

  CollectionReference get _wallets =>
      _firestore.collection(FirebaseConstants.walletsCollection);

  CollectionReference get _numbers => _firestore.collection('numbers');

  Stream<User?> get authStateChange => _auth.authStateChanges();

  Future<model.UserInfoModel> getUserDetails() async {
    User currentUser = _auth.currentUser!;
    DocumentSnapshot snapshot = await _users.doc(currentUser.uid).get();
    if (!snapshot.exists) {
      throw "Unable to get data, are you logging in on the correct app?";
    }
    return model.UserInfoModel.fromMap(snapshot.data() as Map<String, dynamic>);
  }

  Future<DoctorInfo> getDoctorDetails() async {
    User currentUser = _auth.currentUser!;
    DocumentSnapshot snapshot = await _doctors.doc(currentUser.uid).get();
    if (!snapshot.exists) {
      throw "Unable to get data, are you logging in on the correct app?";
    }
    return DoctorInfo.fromMap(snapshot.data() as Map<String, dynamic>);
  }

  Future<HealthcareCentreInfo> getPharmacyDetails() async {
    User currentUser = _auth.currentUser!;
    DocumentSnapshot snapshot = await _practices.doc(currentUser.uid).get();
    if (!snapshot.exists) {
      throw "Unable to get data, are you logging in on the correct app?";
    }
    return HealthcareCentreInfo.fromMap(
        snapshot.data() as Map<String, dynamic>);
  }

  Future<model.UserInfoModel> getUserInfo(String uid) async {
    DocumentSnapshot snapshot = await _users.doc(uid).get();
    return model.UserInfoModel.fromMap(snapshot.data() as Map<String, dynamic>);
  }

  Future<DoctorInfo> getDoctorInfo(String uid) async {
    DocumentSnapshot snapshot = await _doctors.doc(uid).get();
    return DoctorInfo.fromMap(snapshot.data() as Map<String, dynamic>);
  }

  Future<HealthcareCentreInfo> getPharmacyInfo(String uid) async {
    DocumentSnapshot snapshot = await _practices.doc(uid).get();
    return HealthcareCentreInfo.fromMap(
        snapshot.data() as Map<String, dynamic>);
  }

  Stream<model.UserInfoModel> getUserData(String uid) {
    return _users.doc(uid).snapshots().map((event) =>
        model.UserInfoModel.fromMap(event.data() as Map<String, dynamic>));
  }

  Stream<DoctorInfo> getDoctorData(String uid) {
    return _doctors.doc(uid).snapshots().map(
        (event) => DoctorInfo.fromMap(event.data() as Map<String, dynamic>));
  }

  Stream<HealthcareCentreInfo> getPracticeData(String uid) {
    return _users.doc(uid).snapshots().map((event) =>
        HealthcareCentreInfo.fromMap(event.data() as Map<String, dynamic>));
  }

  void selectCategory(String category) async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    switch (category) {
      case Constants.patientCategory:
        prefs.setString(Constants.appTypeKey, 'Patient');
        break;
      case Constants.doctorCategory:
        prefs.setString(Constants.appTypeKey, 'Doctor');
        break;
      case Constants.pharmacyCategory:
        prefs.setString(Constants.appTypeKey, 'Pharmacy');
        break;
    }
  }

  Future<void> signOut() async {
    try {
      await _auth.signOut();
    } on FirebaseException catch (e) {
      throw e.message!;
    } catch (e) {
      rethrow;
    }
  }

  FutureEither<String> signInWithGoogle(
      {String? license,
      int? experience,
      String? expertise,
      DateTime? licenseExpiration}) async {
    try {
      final GoogleSignInAccount? user = await _googleSignIn.signIn();

      final googleAuth = await user?.authentication;
      final cred = GoogleAuthProvider.credential(
        accessToken: googleAuth?.accessToken,
        idToken: googleAuth?.idToken,
      );

      UserCredential userCred = await _auth.signInWithCredential(cred);

      if (userCred.additionalUserInfo!.isNewUser) {
        final SharedPreferences prefs = await SharedPreferences.getInstance();
        final String category = prefs.getString(Constants.appTypeKey)!;
        switch (category) {
          case Constants.patientCategory:
            final userModel = model.UserInfoModel(
                name: userCred.user!.displayName ?? 'No name',
                surname: '',
                uid: userCred.user!.uid,
                profilePicture:
                    userCred.user!.photoURL ?? Constants.defaultProfilePic,
                email: userCred.user!.email ?? '',
                phone: userCred.user!.phoneNumber ?? '',
                favDoctors: [],
                favPractices: []);
            await _users.doc(userModel.uid).set(userModel.toMap());
            break;
          case Constants.doctorCategory:
            final doctor = DoctorInfo(
                name: userCred.user!.displayName ?? 'No name',
                surname: '',
                doctorId: userCred.user!.uid,
                doctorImage:
                    userCred.user!.photoURL ?? Constants.defaultProfilePic,
                profession: expertise!,
                openingHours: const TimeOfDay(hour: 9, minute: 0),
                closingHours: const TimeOfDay(hour: 17, minute: 0),
                numberOfReviews: 0,
                totalRating: 0,
                avgRating: 0,
                consultationFee: 5000,
                licenseNumber: license!,
                age: 0,
                bio: '',
                state: 'Lagos',
                lga: 'Shomolu',
                yearsOfExperience: experience!,
                certificateImages: [],
                qualifications: '',
                favourites: [],
                address: '',
                number: userCred.user!.phoneNumber ?? '',
                licenseExpiration: licenseExpiration!);
            await _doctors.doc(doctor.doctorId).set(doctor.toMap());
            break;
          case Constants.pharmacyCategory:
            final pharmacy = HealthcareCentreInfo(
                latitude: 0,
                longitude: 0,
                pId: userCred.user!.uid,
                name: userCred.user!.displayName ?? 'No name',
                address: '',
                pharmacyImgUrl:
                    userCred.user!.photoURL ?? Constants.defaultProfilePic,
                number: userCred.user!.phoneNumber ?? '',
                emergencyContact: '',
                state: 'Lagos',
                lga: 'Shomolu',
                type: '',
                openingHours: const TimeOfDay(hour: 9, minute: 0),
                closingHours: const TimeOfDay(hour: 17, minute: 0),
                totalRating: 0,
                noOfReviews: 0);
            await _practices.doc(pharmacy.pId).set(pharmacy.toMap());
            break;
        }
        final WalletInfo wallet =
            WalletInfo(uid: userCred.user!.uid, balance: 0);
        await _wallets.doc(wallet.uid).set(wallet.toMap());
      }
      return right('success');
    } on FirebaseException catch (e) {
      throw e.message!;
    } catch (e) {
      return left(Failure(e.toString()));
    }
  }

  FutureEither<String> registerUserWithEmail(
      {required String email,
      required String password,
      required String name,
      required String surname,
      String? license,
      int? experience,
      String? expertise,
      DateTime? licenseExpiration}) async {
    try {
      UserCredential? cred = await _auth.createUserWithEmailAndPassword(
          email: email, password: password);
      final String uid = cred.user!.uid;
      final res = await saveUserInDatabase(
          uid: uid,
          name: name,
          surname: surname,
          email: email,
          license: license,
          expertise: expertise,
          experience: experience,
          licenseExpiration: licenseExpiration);
      res.fold((l) => throw (Exception(l.error)), (r) {});
      return right(cred.user!.email!);
    } on FirebaseException catch (e) {
      throw e.message ?? " An error occurred";
    } catch (e) {
      return left(Failure(e.toString()));
    }
  }

  FutureVoid loginUserWithEmail({
    required String email,
    required String password,
  }) async {
    try {
      await _auth.signInWithEmailAndPassword(email: email, password: password);
      return right(null);
    } on FirebaseException catch (e) {
      throw e.message ?? " An error occurred";
    } catch (e) {
      return left(Failure('An error occurred'));
    }
  }

  FutureEither<String> verifyOTPFromSignUp({
    required BuildContext context,
    required String verificationId,
    required String OTP,
    required String number,
    required String name,
    required String surname,
  }) async {
    try {
      PhoneAuthCredential credential = PhoneAuthProvider.credential(
          verificationId: verificationId, smsCode: OTP);
      UserCredential cred = await _auth.signInWithCredential(credential);
      String uid = cred.user!.uid;
      final res = await saveUserInDatabase(
          uid: uid, name: name, surname: surname, phone: number);
      await _numbers.doc(number).set({'number': number});
      res.fold((l) => throw (Exception(l.error)), (r) {
        // userInfoModel = r;
      });
      return right('Success');
    } on FirebaseException catch (e) {
      rethrow;
    } catch (e) {
      rethrow;
    }
  }

  FutureEither<String> saveUserInDatabase(
      {required String uid,
      required String name,
      required String surname,
      String phone = '',
      String email = '',
      String? license,
      int? experience,
      String? expertise,
      DateTime? licenseExpiration}) async {
    try {
      final SharedPreferences prefs = await SharedPreferences.getInstance();
      final String? type = prefs.getString(Constants.appTypeKey);
      String profilePic = Constants.defaultProfilePic;
      switch (type) {
        case Constants.patientCategory:
          model.UserInfoModel user = model.UserInfoModel(
              name: name,
              surname: surname,
              uid: uid,
              phone: phone,
              email: email,
              state: 'Lagos',
              city: 'Shomolu',
              profilePicture: profilePic,
              favDoctors: [],
              favPractices: []);
          await _users.doc(user.uid).set(user.toMap());
          break;
        case Constants.doctorCategory:
          DoctorInfo doctor = DoctorInfo(
              name: name,
              surname: surname,
              doctorId: uid,
              doctorImage: profilePic,
              profession: expertise!,
              openingHours: const TimeOfDay(hour: 9, minute: 0),
              closingHours: const TimeOfDay(hour: 17, minute: 0),
              numberOfReviews: 0,
              totalRating: 0,
              avgRating: 0,
              consultationFee: 5000,
              licenseNumber: license!,
              age: 0,
              bio: '',
              state: 'Lagos',
              lga: 'Shomolu',
              yearsOfExperience: experience!,
              certificateImages: [],
              qualifications: '',
              favourites: [],
              address: '',
              number: phone,
              licenseExpiration: licenseExpiration!);
          await _doctors.doc(doctor.doctorId).set(doctor.toMap());
          break;
      }
      final WalletInfo wallet = WalletInfo(uid: uid, balance: 0.0);
      await _wallets.doc(uid).set(wallet.toMap());
      return right('Account created');
    } on FirebaseException catch (e) {
      throw e.message!;
    } catch (e) {
      return left(Failure(e.toString()));
    }
  }
}
