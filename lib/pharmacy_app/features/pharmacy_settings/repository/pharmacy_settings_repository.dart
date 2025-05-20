import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:fpdart/fpdart.dart';
import 'package:medifirst/core/constants/data.dart';
import 'package:medifirst/core/providers/firebase_providers.dart';
import 'package:medifirst/core/utils/failure.dart';
import 'package:medifirst/models/healthcare_centre_info.dart';
import 'package:medifirst/models/transaction_model.dart';
import 'package:medifirst/models/wallet_info.dart';
import 'package:uuid/uuid.dart';

import '../../../../core/constants/firebase_constants.dart';
import '../../../../core/utils/type_defs.dart';

final pharmacySettingsRepoProvider = Provider<PharmacySettingsRepository>((ref) {
  final firestore = ref.read(firestoreProvider);
  return PharmacySettingsRepository(firestore: firestore);
});

class PharmacySettingsRepository{
  final FirebaseFirestore _firestore;

  const PharmacySettingsRepository({
    required FirebaseFirestore firestore,
  }) : _firestore = firestore;

  CollectionReference get _pharmacies => _firestore.collection(FirebaseConstants.healthcarePracticesCollection);

  CollectionReference get _wallets => _firestore.collection(FirebaseConstants.walletsCollection);

  CollectionReference get _transactions => _firestore.collection(FirebaseConstants.transactionsCollection);

  Stream<HealthcareCentreInfo> getPharmacyInfo(String id) {
    return _pharmacies.doc(id).snapshots().map(
            (event) => HealthcareCentreInfo.fromMap(event.data() as Map<String, dynamic>));
  }

  Stream<WalletInfo> getPharmacyWalletInfo(String id) {
    return _wallets.doc(id).snapshots().map(
            (event) => WalletInfo.fromMap(event.data() as Map<String, dynamic>));
  }

  FutureVoid updateProfile({required Map<String, dynamic> newValues, required String pId})async{
    try{
      await _pharmacies.doc(pId).update(newValues);
      return right(null);
    }on FirebaseException catch(e){
      throw e.message!;
    }catch(e){
      return left(Failure(e.toString()));
    }
  }

  FutureVoid withdrawFunds({required String pId, required double amount, required String accountNumber})async{
    try{
      final String transactionId = const Uuid().v4();
      final TransactionModel transaction = TransactionModel(transactionId: transactionId, amount: amount, type: 1, uid: pId, date: Timestamp.fromDate(DateTime.now()), recipientId: pId, isCompleted: false, isDebit: true, accountNumber: accountNumber, bank: '');
      await _transactions.doc(transactionId).set(transaction.toMap());
      await _wallets.doc(pId).update({
        'balance': FieldValue.increment(amount * -1),
      });
      return right(null);
    }on FirebaseException catch(e){
      throw e.message!;
    }catch(e){
      return left(Failure(e.toString()));
    }
  }
}