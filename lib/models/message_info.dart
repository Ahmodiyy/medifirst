import 'package:cloud_firestore/cloud_firestore.dart';

class MessageInfo{
  final String senderId;
  final String messageId;
  final Timestamp timeSent;
  final String message;

//<editor-fold desc="Data Methods">

  const MessageInfo({
    required this.senderId,
    required this.messageId,
    required this.timeSent,
    required this.message,
  });


  MessageInfo copyWith({
    String? senderId,
    String? messageId,
    Timestamp? timeSent,
    String? message,
  }) {
    return MessageInfo(
      senderId: senderId ?? this.senderId,
      messageId: messageId ?? this.messageId,
      timeSent: timeSent ?? this.timeSent,
      message: message ?? this.message,
    );
  }


  Map<String, dynamic> toMap() {
    return {
      'senderId': senderId,
      'messageId': messageId,
      'timeSent': timeSent,
      'message': message,
    };
  }

  factory MessageInfo.fromMap(Map<String, dynamic> map) {
    return MessageInfo(
      senderId: map['senderId'] as String,
      messageId: map['messageId'] as String,
      timeSent: map['timeSent'] as Timestamp,
      message: map['message'] as String,
    );
  }


  //</editor-fold>
}