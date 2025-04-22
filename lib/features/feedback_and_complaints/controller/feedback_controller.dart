import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:medifirst/features/feedback_and_complaints/repository/feedback_repository.dart';
import 'package:medifirst/models/feedback_info.dart';
import 'package:uuid/uuid.dart';

final feedbackControllerProvider = Provider<FeedbackController>((ref) {
  final repo = ref.read(feedbackRepoProvider);
  return FeedbackController(repo: repo);
});

class FeedbackController{
  final FeedbackRepository _repo;
  const FeedbackController({required FeedbackRepository repo}):_repo=repo;

  Future<void> sendFeedback({required String firstName, required String surname, required String email, required String message}) async{
    final String fId = const Uuid().v1();
    final FeedbackInfo feedback = FeedbackInfo(firstName: firstName, surname: surname, fId: fId, email: email, message: message);
    final res = await _repo.sendFeedback(feedback);
    res.fold((l){
      throw Exception(l.error);
    }, (r){
      return;
    });
  }
}