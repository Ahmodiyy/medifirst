import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:cloud_functions/cloud_functions.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:fpdart/fpdart.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:medifirst/core/constants/firebase_constants.dart';
import 'package:medifirst/core/providers/firebase_providers.dart';
import 'package:medifirst/core/utils/failure.dart';
import 'package:medifirst/core/utils/type_defs.dart';
import 'package:medifirst/models/user_info.dart';
import 'package:uuid/uuid.dart';
import 'package:url_launcher/url_launcher.dart';

import '../../../models/transaction_model.dart';
import '../../../models/wallet_info.dart';

final settingsRepoProvider = Provider<SettingsRepository>((ref) {
  final firestore = ref.read(firestoreProvider);
  return SettingsRepository(firestore: firestore);
});

class SettingsRepository {
  final FirebaseFirestore _firestore;

  const SettingsRepository({
    required FirebaseFirestore firestore,
  }) : _firestore = firestore;

  CollectionReference get _users =>
      _firestore.collection(FirebaseConstants.usersCollection);

  CollectionReference get _wallets =>
      _firestore.collection(FirebaseConstants.walletsCollection);

  CollectionReference get _transactions =>
      _firestore.collection(FirebaseConstants.transactionsCollection);

  Stream<UserInfoModel> getUserInfo(String id) {
    return _users.doc(id).snapshots().map(
        (event) => UserInfoModel.fromMap(event.data() as Map<String, dynamic>));
  }

  Stream<WalletInfo> getPatientWallet(String uid) {
    return _wallets.doc(uid).snapshots().map(
        (event) => WalletInfo.fromMap(event.data() as Map<String, dynamic>));
  }

  FutureVoid saveFirstPage({
    required UserInfoModel user,
    String? image,
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
    try {
      final newUser = user.copyWith(
          name: firstName,
          surname: surname,
          age: int.tryParse(age ?? user.age.toString()),
          phone: number,
          address: address,
          state: state,
          city: lga,
          occupation: occupation,
          emergencyContact: emergencyContact,
          latitude: latLng?.latitude,
          longitude: latLng?.longitude);
      await _users.doc(user.uid).update({
        'name': firstName,
        'surname': surname,
        'age': int.tryParse(age ?? user.age.toString()),
        'phone': number,
        'address': address,
        'state': state,
        'city': lga,
        'occupation': occupation,
        'emergencyContact': emergencyContact,
        'latitude': latLng?.latitude,
        'longitude': latLng?.longitude,
      });

      return right(null);
    } on FirebaseException catch (e) {
      throw e.message!;
    } catch (e) {
      return left(Failure(e.toString()));
    }
  }


  FutureVoid saveFirstPageWithPicture({
    required UserInfoModel user,
    String? image,
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
    String? profilePicture,
  }) async {
    try {
      final newUser = user.copyWith(
          name: firstName,
          surname: surname,
          age: int.tryParse(age ?? user.age.toString()),
          phone: number,
          address: address,
          state: state,
          city: lga,
          occupation: occupation,
          emergencyContact: emergencyContact,
          latitude: latLng?.latitude,
          longitude: latLng?.longitude);
      await _users.doc(user.uid).update({
        'name': firstName,
        'surname': surname,
        'age': int.tryParse(age ?? user.age.toString()),
        'phone': number,
        'address': address,
        'state': state,
        'city': lga,
        'occupation': occupation,
        'emergencyContact': emergencyContact,
        'latitude': latLng?.latitude,
        'longitude': latLng?.longitude,
        'profilePicture': profilePicture
      });

      return right(null);
    } on FirebaseException catch (e) {
      throw e.message!;
    } catch (e) {
      return left(Failure(e.toString()));
    }
  }



  FutureVoid saveSecondPage({
    required UserInfoModel user,
    required String uid,
    String? bp,
    double? weight,
    int? height,
    double? bmi,
    String? surgicalHistory,
    String? genotype,
    String? bloodGroup,
    String? geneticDisorder,
    String? medicalDisorder,
  }) async {
    try {
      final newUser = user.copyWith(
          bloodPressure: bp,
          weight: weight,
          height: height,
          bmi: bmi,
          surgicalHist: surgicalHistory,
          genotype: genotype,
          geneticDisorder: geneticDisorder,
          medicalDisorder: medicalDisorder);
      print('UID => $uid');
      print('USERUID => ${user.uid}');
      print('NEWUSERUID => ${newUser.uid}');
       await _users.doc(user.uid).update({
         'bloodGroup': bloodGroup,
        'bloodPressure': bp,
        'weight': weight,
        'height': height,
        'bmi': bmi,
        'surgicalHist': surgicalHistory,
        'genotype': genotype,
        'geneticDisorder': geneticDisorder,
        'medicalDisorder': medicalDisorder,
      });
      debugPrint('-----update the rest data genotype is $genotype-------');
      return right(null);
    } on FirebaseException catch (e) {
      throw e.message!;
    } catch (e) {
      return left(Failure(e.toString()));
    }
  }

  FutureVoid depositFunds(
      {required String uid,
      required double amount,
      String accountNumber = ''}) async {
    try {
      final String transactionId = const Uuid().v4();
      final TransactionModel transaction = TransactionModel(
          transactionId: transactionId,
          amount: amount,
          type: 1,
          uid: uid,
          date: Timestamp.fromDate(DateTime.now()),
          recipientId: uid,
          isCompleted: false,
          isDebit: false,
          accountNumber: accountNumber,
          bank: '');
      await _transactions.doc(transactionId).set(transaction.toMap());
      await _wallets.doc(uid).update({
        'balance': FieldValue.increment(amount),
      });
      return right(null);
    } on FirebaseException catch (e) {
      throw e.message!;
    } catch (e) {
      return left(Failure(e.toString()));
    }
  }

  Future<void> initiatePayment(double amount, String email) async {
    try {
      final HttpsCallable callable =
          FirebaseFunctions.instance.httpsCallable('initiatePaystackPayment');
      final result = await callable.call({
        'amount': amount,
        'email': email,
      });

      if (result.data['success']) {
        // Use the authorization URL to redirect the user to Paystack's payment page
        String authorizationUrl = result.data['data']['authorization_url'];
        String reference = result.data['data']['reference'];
        await launchPaystackUrl(authorizationUrl, reference, amount);
      } else {
        print('Error initiating payment: ${result.data['error']}');
      }
    } catch (e) {
      print('Error calling Cloud Function: $e');
    }
  }

  Future<void> launchPaystackUrl(
      String url, String reference, double amount) async {
    if (await canLaunchUrl(Uri.parse(url))) {
      await launchUrl(Uri.parse(url), mode: LaunchMode.externalApplication);

      // After launching the URL, you might want to periodically check the payment status
      // or wait for the user to manually confirm that they've completed the payment
      await Future.delayed(const Duration(minutes: 5)); // Wait for 5 minutes
      await verifyPayment(reference, amount);
    } else {
      throw 'Could not launch $url';
    }
  }

  Future<void> verifyPayment(String reference, double amount) async {
    try {
      final HttpsCallable callable =
          FirebaseFunctions.instance.httpsCallable('verifyPaystackPayment');
      final result = await callable.call({
        'reference': reference,
      });

      if (result.data['success']) {
        depositFunds(
            uid: FirebaseAuth.instance.currentUser!.uid, amount: amount);
      } else {
        print('Payment verification failed: ${result.data['error']}');
      }
    } catch (e) {
      print('Error calling Cloud Function: $e');
    }
  }
}
