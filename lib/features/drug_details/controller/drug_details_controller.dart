import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:medifirst/features/drug_details/repository/drug_details_repository.dart';
import 'package:medifirst/models/cart_item.dart';
import 'package:uuid/uuid.dart';

import '../../../models/drug_info.dart';
import '../../../models/rating_model.dart';

final drugDetailsControllerProvider = Provider<DrugDetailsController>((ref) {
  final repo = ref.read(drugDetailsRepoProvider);
  return DrugDetailsController(repo: repo);
});

final getDrugReviewsProvider = StreamProvider.family((ref, DrugInfo drug) {
  return ref
      .read(drugDetailsControllerProvider)
      .getDrugReviews(drug.drugId, drug.pharmacyId);
});

class DrugDetailsController {
  final DrugDetailsRepository _repo;
  DrugDetailsController({required DrugDetailsRepository repo}) : _repo = repo;

  Stream<DrugInfo> getDrugFromId(String drugId, String pharmacyId) {
    return _repo.getDrugFromId(drugId, pharmacyId);
  }

  Stream<List<RatingModel>> getDrugReviews(String drugId, String pharmacyId) {
    return _repo.getDrugReviews(drugId, pharmacyId);
  }

  Future<void> addDrugReview({
    required String raterId,
    required String raterImgUrl,
    required String drugId,
    required String storeId,
    required String review,
    required int rating,
    required String raterName,
  }) async {
    final String reviewId = const Uuid().v1();
    final Timestamp postedAt = Timestamp.fromDate(DateTime.now());
    final RatingModel reviewModel = RatingModel(
        raterId: raterId,
        reviewId: reviewId,
        raterImgUrl: raterImgUrl,
        drugId: drugId,
        storeId: storeId,
        review: review,
        rating: rating,
        postedAt: postedAt,
        raterName: raterName);
    final res = await _repo.addDrugReview(reviewModel);
    res.fold(
      (l) {
        throw l.error;
      },
      (r) {},
    );
  }

  Future<void> addToCart(
      {required String uid,
      required String drugId,
      required String pharmacyId,
      required String pharmacyName,
      required String brand,
      required String orderUnit,
      required int quantity,
      required String drugName,
      required int price,
      required String dosage,
      required String drugImageURL}) async {
    final String orderId = const Uuid().v1();
    final CartItem cart = CartItem(
        orderId: orderId,
        drugId: drugId,
        patientId: uid,
        pharmacyId: pharmacyId,
        pharmacyName: pharmacyName,
        isPickup: false,
        deliveryAddress: '',
        longitude: 0.0,
        latitude: 0.0,
        brand: brand,
        orderUnit: orderUnit,
        quantity: quantity,
        drugName: drugName,
        price: price,
        inCart: true,
        isFulfilled: false,
        orderDate: Timestamp.fromDate(DateTime.now()),
        dosage: dosage,
        drugImageURL: drugImageURL);
    try {
      final res = await _repo.addToCart(uid: uid, cart: cart);
      res.fold((l) {
        throw l.error;
      }, (r) => null);
    } catch (e) {
      rethrow;
    }
  }
}
