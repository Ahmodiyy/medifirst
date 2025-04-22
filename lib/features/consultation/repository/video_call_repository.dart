import 'package:cloud_firestore/cloud_firestore.dart';

class VideoCallRepository {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  Future<void> createVideoCall(String callId, Map<String, dynamic> callData) async {
    await _firestore.collection('video_calls').doc(callId).set(callData);
  }

  Future<void> updateVideoCall(String callId, Map<String, dynamic> callData) async {
    await _firestore.collection('video_calls').doc(callId).update(callData);
  }

  Stream<DocumentSnapshot> getVideoCallStream(String callId) {
    return _firestore.collection('video_calls').doc(callId).snapshots();
  }

  Future<void> endVideoCall(String callId) async {
    await _firestore.collection('video_calls').doc(callId).delete();
  }
}