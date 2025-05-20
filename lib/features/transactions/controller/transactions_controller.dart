import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:medifirst/core/widgets/molecules/action_success_modal.dart';
import 'package:medifirst/core/widgets/molecules/error_modal.dart';

import '../../../models/transaction_model.dart';
import '../../../models/wallet_info.dart';
import '../repository/transactions_repository.dart';

final transactionsControllerProvider = Provider<TransactionsController>((ref) {
  final repo = ref.read(transactionsRepoProvider);
  return TransactionsController(repo: repo);
});

final getTransactionsProvider =
    StreamProvider.family.autoDispose((ref, String uid) {
  return ref.read(transactionsControllerProvider).getTransactions(uid);
});

class TransactionsController {
  final TransactionsRepository _repo;

  const TransactionsController({
    required TransactionsRepository repo,
  }) : _repo = repo;

  Future<WalletInfo> getWalletInfo(String uid) async {
    final res = await _repo.getWalletDetails(uid);
    WalletInfo? wallet;
    res.fold((l) {
      throw l.error;
    }, (r) {
      wallet = r;
    });
    return wallet!;
  }

  Future<void> logDeposit(
      BuildContext context, double amount, String uid, String reference) async {
    final transaction = TransactionModel(
        transactionId: reference,
        amount: amount,
        type: 2,
        uid: uid,
        date: Timestamp.fromDate(DateTime.now()),
        recipientId: uid,
        isCompleted: true,
        isDebit: false,
        bank: '');
    final res = await _repo.logDeposit(transaction);
    FocusScope.of(context).unfocus();
    await Future.delayed(const Duration(milliseconds: 500));
    res.fold((l) {
      showModalBottomSheet(
          context: context,
          builder: (context) =>
              const ErrorModal(message: 'An error occurred.'));
    }, (r) {
      showModalBottomSheet(
          context: context, builder: (context) => const ActionSuccessModal());
    });
  }

  Future<void> logWithdrawal(BuildContext context, double accountNumber,
      String uid, String bank) async {
    final res = await _repo.logWithdrawal(accountNumber, uid, bank);
    FocusScope.of(context).unfocus();
    await Future.delayed(const Duration(milliseconds: 500));
    res.fold((l) {
      showModalBottomSheet(
          context: context,
          builder: (context) =>
              const ErrorModal(message: 'An error occurred.'));
    }, (r) {
      showModalBottomSheet(
          context: context, builder: (context) => const ActionSuccessModal());
    });
  }

  Stream<List<TransactionModel>> getTransactions(String uid) {
    return _repo.getTransactions(uid);
  }
}
