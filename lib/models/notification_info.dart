import 'package:cloud_firestore/cloud_firestore.dart';

class NotificationInfo{
  final String message;
  final String notificationId;
  final String ownerId;
  final String category;
  final Timestamp time;
  final bool isUnread;
  final String imageOneUrl;
  final String imageTwoUrl;

//<editor-fold desc="Data Methods">
  const NotificationInfo({
    required this.message,
    required this.notificationId,
    required this.ownerId,
    required this.category,
    required this.time,
    required this.isUnread,
    required this.imageOneUrl,
    required this.imageTwoUrl,
  });

  NotificationInfo copyWith({
    String? message,
    String? notificationId,
    String? ownerId,
    String? category,
    Timestamp? time,
    bool? isUnread,
    String? imageOneUrl,
    String? imageTwoUrl,
  }) {
    return NotificationInfo(
      message: message ?? this.message,
      notificationId: notificationId ?? this.notificationId,
      ownerId: ownerId ?? this.ownerId,
      category: category ?? this.category,
      time: time ?? this.time,
      isUnread: isUnread ?? this.isUnread,
      imageOneUrl: imageOneUrl ?? this.imageOneUrl,
      imageTwoUrl: imageTwoUrl ?? this.imageTwoUrl,
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'message': message,
      'notificationId': notificationId,
      'ownerId': ownerId,
      'category': category,
      'time': time,
      'isUnread': isUnread,
      'imageOneUrl': imageOneUrl,
      'imageTwoUrl': imageTwoUrl,
    };
  }

  factory NotificationInfo.fromMap(Map<String, dynamic> map) {
    return NotificationInfo(
      message: map['message'] as String,
      notificationId: map['notificationId'] as String,
      ownerId: map['ownerId'] as String,
      category: map['category'] as String,
      time: map['time'] as Timestamp,
      isUnread: map['isUnread'] as bool,
      imageOneUrl: map['imageOneUrl'] as String,
      imageTwoUrl: map['imageTwoUrl'] as String,
    );
  }

//</editor-fold>
}