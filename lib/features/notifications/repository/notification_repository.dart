import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:medifirst/core/constants/firebase_constants.dart';
import 'package:medifirst/core/providers/firebase_providers.dart';
import 'package:medifirst/models/notification_info.dart';

final notificationRepoProvider = Provider<NotificationRepository>((ref) {
  final FirebaseFirestore firestore = ref.read(firestoreProvider);
  return NotificationRepository(firestore: firestore);
});

class NotificationRepository {
  final FirebaseFirestore _firestore;
  const NotificationRepository({required FirebaseFirestore firestore})
      : _firestore = firestore;

  CollectionReference get _notifications =>
      _firestore.collection(FirebaseConstants.notificationsCollection);

  Future<void> changeNotificationReadStatus(String notificationId)async{
    try{
      await _notifications.doc(notificationId).update({
        'isUnread': false,
      });
      return;
    }on FirebaseException catch(e){
      throw e.message!;
    } catch(e){
      //space for exception checking
      return;
    }
  }

  Stream<List<NotificationInfo>> getNotifications(String uid) {
    return _notifications
        .where('ownerId', isEqualTo: uid)
        .orderBy('time', descending: true)
        .snapshots()
        .map((event) {
      return event.docs
          .map(
              (e) => NotificationInfo.fromMap(e.data() as Map<String, dynamic>))
          .toList();
    });
  }
}
