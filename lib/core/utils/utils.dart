import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:image_picker/image_picker.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:medifirst/core/constants/firebase_constants.dart';
import 'dart:typed_data';
import 'dart:math' show cos, sqrt, asin;

import '../constants/constants.dart';

Future<Uint8List> pickOneImage() async {
  final picker = ImagePicker();
  final imageFile = await picker.pickImage(source: ImageSource.gallery);
  return imageFile!.readAsBytes();
}

double calculateDistance({required double lat1, required double lon1, required double lat2, required double lon2}){
  var p = 0.017453292519943295;
  var c = cos;
  var a = 0.5 - c((lat2 - lat1) * p)/2 +
      c(lat1 * p) * c(lat2 * p) *
          (1 - c((lon2 - lon1) * p))/2;
  return 12742 * asin(sqrt(a));
}

final accountNumberProvider = StateProvider<String?>((ref)=>null);
final bankProvider = StateProvider<String?>((ref)=>null);

Future<void> setupFirebaseMessaging(String category, String uid) async {
  FirebaseMessaging messaging = FirebaseMessaging.instance;

  NotificationSettings settings = await messaging.requestPermission(
    alert: true,
    badge: true,
    sound: true,
  );

  if (settings.authorizationStatus == AuthorizationStatus.authorized) {
    String? token = await messaging.getToken();
    if (token != null) {
      // Store this token in Firestore, associated with the user
      print(uid);
      await FirebaseFirestore.instance
          .collection((category==Constants.patientCategory)?FirebaseConstants.usersCollection:FirebaseConstants.doctorsCollection)
          .doc(uid)
          .update({'fcmToken': token});
    }
  }
}
