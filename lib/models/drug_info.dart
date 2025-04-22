class DrugInfo{
  final String drugId;
  final String pharmacyId;
  final String drugName;
  final int price;
  final String dosage;
  final String drugImageURL;
  final List<String> sideEffects;
  final List<String> curableSymptoms;
  final int totalRating;
  final int numberOfReviews;
  final String aboutDrug;
  final String brandName;
  final String pharmacyName;

//<editor-fold desc="Data Methods">
  const DrugInfo({
    required this.drugId,
    required this.pharmacyId,
    required this.drugName,
    required this.price,
    required this.dosage,
    required this.drugImageURL,
    required this.sideEffects,
    required this.curableSymptoms,
    required this.totalRating,
    required this.numberOfReviews,
    required this.aboutDrug,
    required this.brandName,
    required this.pharmacyName,
  });

  DrugInfo copyWith({
    String? drugId,
    String? pharmacyId,
    String? drugName,
    int? price,
    String? dosage,
    String? drugImageURL,
    List<String>? sideEffects,
    List<String>? curableSymptoms,
    int? totalRating,
    int? numberOfReviews,
    String? aboutDrug,
    String? brandName,
    String? pharmacyName,
  }) {
    return DrugInfo(
      drugId: drugId ?? this.drugId,
      pharmacyId: pharmacyId ?? this.pharmacyId,
      drugName: drugName ?? this.drugName,
      price: price ?? this.price,
      dosage: dosage ?? this.dosage,
      drugImageURL: drugImageURL ?? this.drugImageURL,
      sideEffects: sideEffects ?? this.sideEffects,
      curableSymptoms: curableSymptoms ?? this.curableSymptoms,
      totalRating: totalRating ?? this.totalRating,
      numberOfReviews: numberOfReviews ?? this.numberOfReviews,
      aboutDrug: aboutDrug ?? this.aboutDrug,
      brandName: brandName ?? this.brandName,
      pharmacyName: pharmacyName ?? this.pharmacyName,
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'drugId': drugId,
      'pharmacyId': pharmacyId,
      'drugName': drugName,
      'price': price,
      'dosage': dosage,
      'drugImageURL': drugImageURL,
      'sideEffects': sideEffects,
      'curableSymptoms': curableSymptoms,
      'totalRating': totalRating,
      'numberOfReviews': numberOfReviews,
      'aboutDrug': aboutDrug,
      'brandName': brandName,
      'pharmacyName': pharmacyName,
    };
  }

  factory DrugInfo.fromMap(Map<String, dynamic> map) {
    return DrugInfo(
      drugId: map['drugId'] as String,
      pharmacyId: map['pharmacyId'] as String,
      drugName: map['drugName'] as String,
      price: map['price'] as int,
      dosage: map['dosage'] as String,
      drugImageURL: map['drugImageURL'] as String,
      sideEffects: map['sideEffects'] as List<String>,
      curableSymptoms: map['curableSymptoms'] as List<String>,
      totalRating: map['totalRating'] as int,
      numberOfReviews: map['numberOfReviews'] as int,
      aboutDrug: map['aboutDrug'] as String,
      brandName: map['brandName'] as String,
      pharmacyName: map['pharmacyName'] as String,
    );
  }

//</editor-fold>
}