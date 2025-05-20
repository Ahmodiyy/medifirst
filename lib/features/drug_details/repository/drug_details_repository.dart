import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:fpdart/fpdart.dart';
import 'package:medifirst/core/constants/firebase_constants.dart';
import 'package:medifirst/core/providers/firebase_providers.dart';
import 'package:medifirst/core/utils/failure.dart';
import 'package:medifirst/models/cart_item.dart';

import '../../../core/utils/type_defs.dart';
import '../../../models/drug_info.dart';
import '../../../models/rating_model.dart';

final drugDetailsRepoProvider = Provider<DrugDetailsRepository>((ref) {
  final firestore = ref.read(firestoreProvider);
  return DrugDetailsRepository(firestore: firestore);
});

class DrugDetailsRepository {
  final FirebaseFirestore _firestore;
  const DrugDetailsRepository({required FirebaseFirestore firestore})
      : _firestore = firestore;

  CollectionReference get _practices =>
      _firestore.collection(FirebaseConstants.healthcarePracticesCollection);

  CollectionReference get _users => _firestore.collection(FirebaseConstants.usersCollection);

  Stream<DrugInfo> getDrugFromId(String drugId, String pharmacyId) {
    return _practices
        .doc(pharmacyId)
        .collection(FirebaseConstants.catalogCollection)
        .doc(drugId)
        .snapshots()
        .map((event) => DrugInfo.fromMap(event.data() as Map<String, dynamic>));
  }

  Stream<List<RatingModel>> getDrugReviews(String drugId, String pharmacyId) {
    return _practices
        .doc(pharmacyId)
        .collection(FirebaseConstants.catalogCollection)
        .doc(drugId)
        .collection(FirebaseConstants.reviewsCollection)
        .snapshots()
        .map((event) {
      return event.docs
          .map(
            (e) => RatingModel.fromMap(
              e.data(),
            ),
          )
          .toList();
    });
  }

  FutureVoid addDrugReview(RatingModel rating)async{
    try{
      await _practices.doc(rating.storeId).collection(FirebaseConstants.catalogCollection).doc(rating.drugId).set(rating.toMap());
      return right(null);
    }on FirebaseException catch(e){
      throw e.message!;
    } catch(e){
      return left(Failure(e.toString()));
    }
  }

  FutureVoid addToCart({required String uid, required CartItem cart})async{
    try {
      await _users
          .doc(uid)
          .collection(FirebaseConstants.cartCollection)
          .doc(cart.orderId)
          .set(cart.toMap());
      return right(null);
    }on FirebaseException catch(e){
      throw e.message!;
    } catch(e){
      return left(Failure(e.toString()));
    }
  }
}
