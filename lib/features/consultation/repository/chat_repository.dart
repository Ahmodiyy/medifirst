import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:fpdart/fpdart.dart';
import 'package:medifirst/core/constants/firebase_constants.dart';
import 'package:medifirst/core/providers/firebase_providers.dart';
import 'package:medifirst/core/utils/failure.dart';
import 'package:medifirst/core/utils/type_defs.dart';
import 'package:medifirst/models/message_info.dart';

final chatRepoProvider = Provider<ChatRepository>((ref) {
  final firestore = ref.read(firestoreProvider);
  return ChatRepository(firestore: firestore);
});

class ChatRepository {
  final FirebaseFirestore _firestore;

  const ChatRepository({
    required FirebaseFirestore firestore,
  }) : _firestore = firestore;

  CollectionReference get _appointments =>
      _firestore.collection(FirebaseConstants.appointmentsCollection);

  Stream<List<MessageInfo>> getMessages(String appointmentId) {
    return _appointments
        .doc(appointmentId)
        .collection(FirebaseConstants.messagesCollection)
        .orderBy('timeSent', descending: true)
        .snapshots()
        .map((event) {
      return event.docs.map((e) => MessageInfo.fromMap(e.data())).toList();
    });
  }
  
  FutureVoid sendMessage(MessageInfo message, String appointmentId)async{
    try{
      await _appointments.doc(appointmentId).collection(FirebaseConstants.messagesCollection).doc(message.messageId).set(message.toMap());
      return right(null);
    }on FirebaseException catch(e){
      throw e.message!;
    } catch(e){
      return left(Failure(e.toString()));
    }
  }

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
