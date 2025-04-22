import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:medifirst/features/notifications/repository/notification_repository.dart';

import '../../../models/notification_info.dart';

final notificationControllerProvider = Provider<NotificationController>((ref) {
  final NotificationRepository repo = ref.read(notificationRepoProvider);
  return NotificationController(repo: repo);
});

final getNotificationsProvider = StreamProvider.family((ref, String uid) {
  return ref.read(notificationControllerProvider).getNotifications(uid);
});

class NotificationController{
  final NotificationRepository _repo;
  const NotificationController({required NotificationRepository repo}): _repo = repo;

  Future<void> changeNotificationReadStatus(String notificationId)async{
    final res = await _repo.changeNotificationReadStatus(notificationId);
  }

  Stream<List<NotificationInfo>> getNotifications(String uid){
    return _repo.getNotifications(uid);
  }
}