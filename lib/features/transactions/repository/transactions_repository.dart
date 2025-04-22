import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:fpdart/fpdart.dart';
import 'package:medifirst/core/constants/firebase_constants.dart';
import 'package:medifirst/core/providers/firebase_providers.dart';
import 'package:medifirst/core/utils/failure.dart';
import 'package:medifirst/core/utils/type_defs.dart';
import 'package:medifirst/models/transaction_model.dart';

import '../../../models/wallet_info.dart';

final transactionsRepoProvider = Provider<TransactionsRepository>((ref) {
  final firestore = ref.read(firestoreProvider);
  return TransactionsRepository(firestore: firestore);
});

class TransactionsRepository{
  final FirebaseFirestore _firestore;

  const TransactionsRepository({
    required FirebaseFirestore firestore,
  }) : _firestore = firestore;

  CollectionReference get _transactions => _firestore.collection(FirebaseConstants.transactionsCollection);
  CollectionReference get _wallets => _firestore.collection(FirebaseConstants.walletsCollection);

  CollectionReference get _wallet => _firestore.collection(FirebaseConstants.walletsCollection);

  FutureEither<WalletInfo> getWalletDetails(String uid)async{
    try{
      final DocumentSnapshot doc = await _wallet.doc(uid).get();
      final wallet = WalletInfo.fromMap(doc.data() as Map<String, dynamic>);
      return right(wallet);
    }on FirebaseException catch(e){
      throw e.message!;
    } catch(e){
      return left(Failure(e.toString()));
    }
  }

  FutureEither<String> logDeposit(TransactionModel transactionModel)async{
    try{
      await FirebaseFirestore.instance.runTransaction((transaction) async {
        await _transactions.doc(transactionModel.transactionId).set(transactionModel.toMap());
        DocumentReference userDocRef = _wallets.doc(transactionModel.recipientId);
        DocumentSnapshot snapshot = await transaction.get(userDocRef);
          double currentBalance = snapshot['balance'] ?? 0;
          double newBalance = currentBalance + transactionModel.amount;
          transaction.update(userDocRef, {'balance': newBalance});
      });
      return right('Successful');
    }on FirebaseException catch(e){
      throw e.message!;
    }catch(e){
      return left(Failure('An error occurred'));
    }
  }

  FutureEither<String> logWithdrawal(TransactionModel transaction)async{
    try{
      await _transactions.doc(transaction.transactionId).set(transaction.toMap());
      return right('Successful');
    }on FirebaseException catch(e){
      throw e.message!;
    }catch(e){
      return left(Failure('An error occurred'));
    }
  }

  Stream<List<TransactionModel>> getTransactions(String uid) async* {
    try {
      List<TransactionModel> appointments = [];
      final snapshots = _transactions
          .where('uid', isEqualTo: uid)
          .orderBy('date', descending: true)
          .snapshots();

      await for (var snapshot in snapshots) {
        appointments = snapshot.docs.map((e) {
          return TransactionModel.fromMap(e.data() as Map<String, dynamic>);
        }).toList();

        yield appointments;
      }
    } catch (e) {
      print('Error in repo getTransactions : $e');
      rethrow;

    }
  }




}
