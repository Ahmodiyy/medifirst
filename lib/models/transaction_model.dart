import 'package:cloud_firestore/cloud_firestore.dart';

class TransactionModel{
  final String transactionId;
  final double amount;
  final String? accountNumber;
  final String bank;
  final int type;
  final String uid;
  final Timestamp date;
  final String recipientId;
  final bool isCompleted;
  final bool isDebit;

//<editor-fold desc="Data Methods">
  const TransactionModel({
    required this.transactionId,
    required this.amount,
    this.accountNumber,
    required this.bank,
    required this.type,
    required this.uid,
    required this.date,
    required this.recipientId,
    required this.isCompleted,
    required this.isDebit,
  });


  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
          (other is TransactionModel &&
              runtimeType == other.runtimeType &&
              transactionId == other.transactionId &&
              amount == other.amount &&
              accountNumber == other.accountNumber &&
              bank == other.bank &&
              type == other.type &&
              uid == other.uid &&
              date == other.date &&
              recipientId == other.recipientId &&
              isCompleted == other.isCompleted &&
              isDebit == other.isDebit
          );


  @override
  int get hashCode =>
      transactionId.hashCode ^
      amount.hashCode ^
      accountNumber.hashCode ^
      bank.hashCode ^
      type.hashCode ^
      uid.hashCode ^
      date.hashCode ^
      recipientId.hashCode ^
      isCompleted.hashCode ^
      isDebit.hashCode;


  @override
  String toString() {
    return 'TransactionModel{' +
        ' transactionId: $transactionId,' +
        ' amount: $amount,' +
        ' accountNumber: $accountNumber,' +
        ' bank: $bank,' +
        ' type: $type,' +
        ' uid: $uid,' +
        ' date: $date,' +
        ' recipientId: $recipientId,' +
        ' isCompleted: $isCompleted,' +
        ' isDebit: $isDebit,' +
        '}';
  }


  TransactionModel copyWith({
    String? transactionId,
    double? amount,
    String? accountNumber,
    String? bank,
    int? type,
    String? uid,
    Timestamp? date,
    String? recipientId,
    bool? isCompleted,
    bool? isDebit,
  }) {
    return TransactionModel(
      transactionId: transactionId ?? this.transactionId,
      amount: amount ?? this.amount,
      accountNumber: accountNumber ?? this.accountNumber,
      bank: bank ?? this.bank,
      type: type ?? this.type,
      uid: uid ?? this.uid,
      date: date ?? this.date,
      recipientId: recipientId ?? this.recipientId,
      isCompleted: isCompleted ?? this.isCompleted,
      isDebit: isDebit ?? this.isDebit,
    );
  }


  Map<String, dynamic> toMap() {
    return {
      'transactionId': this.transactionId,
      'amount': this.amount,
      'accountNumber': this.accountNumber,
      'bank': this.bank,
      'type': this.type,
      'uid': this.uid,
      'date': this.date,
      'recipientId': this.recipientId,
      'isCompleted': this.isCompleted,
      'isDebit': this.isDebit,
    };
  }

  factory TransactionModel.fromMap(Map<String, dynamic> map) {
    return TransactionModel(
      transactionId: map['transactionId'] as String? ?? '',
      amount: (map['amount'] as num?)?.toDouble() ?? 0.0,
      accountNumber: map['accountNumber'] as String? ?? '',
      bank: map['bank'] as String? ?? '',
      type: map['type'] as int? ?? 0,
      uid: map['uid'] as String? ?? '',
      date: map['date'] as Timestamp,
      recipientId: map['recipientId'] as String? ?? '',
      isCompleted: map['isCompleted'] as bool? ?? false,
      isDebit: map['isDebit'] as bool? ?? false,
    );
  }


//</editor-fold>
}
