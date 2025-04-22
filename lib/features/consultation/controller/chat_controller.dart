import 'dart:async';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:uuid/uuid.dart';

import '../../../models/message_info.dart';
import '../repository/chat_repository.dart';

final chatControllerProvider = Provider<ChatController>((ref) {
  final repo = ref.read(chatRepoProvider);
  return ChatController(repo: repo);
});

final getMessagesProvider = StreamProvider.family((ref, String appointmentId) {
  final controller = ref.read(chatControllerProvider);
  return controller.getMessages(appointmentId);
});

class ChatController {
  final ChatRepository _repo;

  const ChatController({
    required ChatRepository repo,
  }) : _repo = repo;

  Stream<List<MessageInfo>> getMessages(String appointmentId) {
    return _repo.getMessages(appointmentId);
  }

  void sendMessage(
      {required String senderId,
      required String message,
      required String appointmentId}) async {
    try {
      final String messageId = const Uuid().v1();
      final MessageInfo chatMessage = MessageInfo(
          senderId: senderId,
          messageId: messageId,
          timeSent: Timestamp.fromDate(DateTime.now()),
          message: message);
      final res = await _repo.sendMessage(chatMessage, appointmentId);
      res.fold((l) {
        throw Exception(l.error);
      }, (r) => null);
    } catch (e) {
      throw Exception(e.toString());
    }
  }
}
