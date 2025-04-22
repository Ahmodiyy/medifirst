import 'package:cloud_firestore/cloud_firestore.dart';

class RatingModel{
  final String raterId;
  final String reviewId;
  final String raterImgUrl;
  final String drugId;
  final String storeId;
  final String review;
  final int rating;
  final Timestamp postedAt;
  final String raterName;

//<editor-fold desc="Data Methods">
  const RatingModel({
    required this.raterId,
    required this.reviewId,
    required this.raterImgUrl,
    required this.drugId,
    required this.storeId,
    required this.review,
    required this.rating,
    required this.postedAt,
    required this.raterName,
  });

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is RatingModel &&
          runtimeType == other.runtimeType &&
          raterId == other.raterId &&
          reviewId == other.reviewId &&
          raterImgUrl == other.raterImgUrl &&
          drugId == other.drugId &&
          storeId == other.storeId &&
          review == other.review &&
          rating == other.rating &&
          postedAt == other.postedAt &&
          raterName == other.raterName);

  @override
  int get hashCode =>
      raterId.hashCode ^
      reviewId.hashCode ^
      raterImgUrl.hashCode ^
      drugId.hashCode ^
      storeId.hashCode ^
      review.hashCode ^
      rating.hashCode ^
      postedAt.hashCode ^
      raterName.hashCode;

  @override
  String toString() {
    return 'RatingModel{ raterId: $raterId, reviewId: $reviewId, raterImgUrl: $raterImgUrl, drugId: $drugId, storeId: $storeId, review: $review, rating: $rating, postedAt: $postedAt, raterName: $raterName,}';
  }

  RatingModel copyWith({
    String? raterId,
    String? reviewId,
    String? raterImgUrl,
    String? drugId,
    String? storeId,
    String? review,
    int? rating,
    Timestamp? postedAt,
    String? raterName,
  }) {
    return RatingModel(
      raterId: raterId ?? this.raterId,
      reviewId: reviewId ?? this.reviewId,
      raterImgUrl: raterImgUrl ?? this.raterImgUrl,
      drugId: drugId ?? this.drugId,
      storeId: storeId ?? this.storeId,
      review: review ?? this.review,
      rating: rating ?? this.rating,
      postedAt: postedAt ?? this.postedAt,
      raterName: raterName ?? this.raterName,
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'raterId': raterId,
      'reviewId': reviewId,
      'raterImgUrl': raterImgUrl,
      'drugId': drugId,
      'storeId': storeId,
      'review': review,
      'rating': rating,
      'postedAt': postedAt,
      'raterName': raterName,
    };
  }

  factory RatingModel.fromMap(Map<String, dynamic> map) {
    return RatingModel(
      raterId: map['raterId'] as String,
      reviewId: map['reviewId'] as String,
      raterImgUrl: map['raterImgUrl'] as String,
      drugId: map['drugId'] as String,
      storeId: map['storeId'] as String,
      review: map['review'] as String,
      rating: map['rating'] as int,
      postedAt: map['postedAt'] as Timestamp,
      raterName: map['raterName'] as String,
    );
  }

//</editor-fold>
}