class WalletInfo{
  final String uid;
  final double balance;

//<editor-fold desc="Data Methods">
  const WalletInfo({
    required this.uid,
    required this.balance,
  });

  WalletInfo copyWith({
    String? uid,
    double? balance,
  }) {
    return WalletInfo(
      uid: uid ?? this.uid,
      balance: balance ?? this.balance,
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'uid': uid,
      'balance': balance,
    };
  }

  factory WalletInfo.fromMap(Map<String, dynamic> map) {
    return WalletInfo(
      uid: map['uid'] as String,
      balance: map['balance'].toDouble(),
    );
  }

//</editor-fold>
}