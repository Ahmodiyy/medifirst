import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:fpdart/fpdart.dart';
import 'package:medifirst/core/constants/firebase_constants.dart';
import 'package:medifirst/core/providers/firebase_providers.dart';
import 'package:medifirst/core/utils/failure.dart';
import 'package:medifirst/core/utils/type_defs.dart';
import 'package:medifirst/models/feedback_info.dart';

final feedbackRepoProvider = Provider<FeedbackRepository>((ref) {
  final firestore = ref.read(firestoreProvider);
  return FeedbackRepository(firestore: firestore);
});

class FeedbackRepository {
  final FirebaseFirestore _firestore;
  const FeedbackRepository({required FirebaseFirestore firestore})
      : _firestore = firestore;

  CollectionReference get _reports =>
      _firestore.collection(FirebaseConstants.feedbackCollection);

  FutureEither<void> sendFeedback(FeedbackInfo feedback) async {
    try {
      return right(
        await _reports.doc(feedback.fId).set(
              feedback.toMap(),
            ),
      );
    } on FirebaseException catch (e) {
      throw e.message!;
    } catch (e) {
      return left(Failure(e.toString()));
    }
  }
}
