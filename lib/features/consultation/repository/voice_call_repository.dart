import 'package:cloud_firestore/cloud_firestore.dart';

class VoiceCallRepository {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  Future<void> createCall(String callId, Map<String, dynamic> callData) async {
    await _firestore.collection('calls').doc(callId).set(callData);
  }

  Future<void> updateCall(String callId, Map<String, dynamic> callData) async {
    await _firestore.collection('calls').doc(callId).update(callData);
  }

  Stream<DocumentSnapshot> getCallStream(String callId) {
    return _firestore.collection('calls').doc(callId).snapshots();
  }

  Future<void> endCall(String callId) async {
    await _firestore.collection('calls').doc(callId).delete();
  }
}