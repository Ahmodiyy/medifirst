// import 'package:cloud_firestore/cloud_firestore.dart';
// import 'package:flutter/material.dart';
// import 'package:medifirst/core/constants/credentials.dart';
// import 'package:zego_express_engine/zego_express_engine.dart';
// import 'package:zego_uikit_prebuilt_call/zego_uikit_prebuilt_call.dart';
// import 'package:zego_uikit_signaling_plugin/zego_uikit_signaling_plugin.dart';
//
// class DoctorsCallsRepository{
//   final FirebaseFirestore _firestore;
//
//   const DoctorsCallsRepository({
//     required FirebaseFirestore firestore,
//   }) : _firestore = firestore;
//
//   Future<void> createEngine() async {
//     await ZegoExpressEngine.createEngineWithProfile(ZegoEngineProfile(
//       Credentials.zegoAppId,
//       ZegoScenario.StandardVoiceCall,
//       appSign: Credentials.zegoAppSign,
//     ));
//   }
//
//   void startListenEvent() {
//     // Callback for updates on the status of other users in the room.
//     // Users can only receive callbacks when the isUserStatusNotify property of ZegoRoomConfig is set to `true` when logging in to the room (loginRoom).
//     ZegoExpressEngine.onRoomUserUpdate = (roomID, updateType, List<ZegoUser> userList) {
//       //this is called when a new user logs into a room or logs out
//       print(
//           'onRoomUserUpdate: roomID: $roomID, updateType: ${updateType.name}, userList: ${userList.map((e) => e.userID)}');
//     };
//     // Callback for updates on the status of the streams in the room.
//     ZegoExpressEngine.onRoomStreamUpdate = (roomID, updateType, List<ZegoStream> streamList, extendedData) {
//       //this is for when a new stream is published or an existing one ends
//       print(
//           'onRoomStreamUpdate: roomID: $roomID, updateType: $updateType, streamList: ${streamList.map((e) => e.streamID)}, extendedData: $extendedData');
//       if (updateType == ZegoUpdateType.Add) {
//         //new stream added
//         for (final stream in streamList) {
//           startPlayStream(stream.streamID);
//         }
//       } else {
//         for (final stream in streamList) {
//           //published stream ends
//           stopPlayStream(stream.streamID);
//         }
//       }
//     };
//     // Callback for updates on the current user's room connection status.
//     ZegoExpressEngine.onRoomStateUpdate = (roomID, state, errorCode, extendedData) {
//       print(
//           'onRoomStateUpdate: roomID: $roomID, state: ${state.name}, errorCode: $errorCode, extendedData: $extendedData');
//     };
//
//     // Callback for updates on the current user's stream publishing changes.
//     ZegoExpressEngine.onPublisherStateUpdate = (streamID, state, errorCode, extendedData) {
//       debugPrint(
//           'onPublisherStateUpdate: streamID: $streamID, state: ${state.name}, errorCode: $errorCode, extendedData: $extendedData');
//     };
//   }
//
//   void stopListenEvent() {
//     ZegoExpressEngine.onRoomUserUpdate = null;
//     ZegoExpressEngine.onRoomStreamUpdate = null;
//     ZegoExpressEngine.onRoomStateUpdate = null;
//     ZegoExpressEngine.onPublisherStateUpdate = null;
//   }
//
//
//   Future<ZegoRoomLoginResult> loginRoom(String doctorId, String patientId, String name, bool isDoctor) async {
//     // The value of `userID` is generated locally and must be globally unique.
//     final user = isDoctor? ZegoUser(doctorId, name) : ZegoUser(patientId, name);
//
//
//     // The value of `roomID` is generated locally and must be globally unique.
//     final roomID = '$doctorId$patientId';
//
//     // onRoomUserUpdate callback can be received when "isUserStatusNotify" parameter value is "true".
//     ZegoRoomConfig roomConfig = ZegoRoomConfig.defaultConfig()..isUserStatusNotify = true;
//
//     // log in to a room
//     // Users must log in to the same room to call each other.
//     return ZegoExpressEngine.instance.loginRoom(roomID, user, config: roomConfig).then((ZegoRoomLoginResult loginRoomResult) {
//       debugPrint('loginRoom: errorCode:${loginRoomResult.errorCode}, extendedData:${loginRoomResult.extendedData}');
//       if (loginRoomResult.errorCode == 0) {
//         // startPreview();
//         startPublish(doctorId, patientId, isDoctor);
//       } else {
//         // ScaffoldMessenger.of(context)
//         //     .showSnackBar(SnackBar(content: Text('There was an error connecting to the call.')));
//       }
//       return loginRoomResult;
//     });
//   }
//
//   Future<ZegoRoomLogoutResult> logoutRoom(String doctorId, String patientId) async {
//     // stopPreview();
//     stopPublish();
//     return ZegoExpressEngine.instance.logoutRoom('$doctorId$patientId');
//   }
//
//   Future<void> startPublish(String doctorId, String patientId, bool isDoctor) async{
//     // After calling the `loginRoom` method, call this method to publish streams.
//     // The StreamID must be unique in the room.
//     String localId = isDoctor? doctorId : patientId;
//     String streamID = '$doctorId$patientId${localId}_call';
//     ZegoExpressEngine.instance.enableCamera(false);
//     return ZegoExpressEngine.instance.startPublishingStream(streamID);
//   }
//
//   Future<void> stopPublish() async {
//     return ZegoExpressEngine.instance.stopPublishingStream();
//   }
//
//   Future<void> startPlayStream(String streamID) async {
//     // Start to play streams.
//     ZegoExpressEngine.instance.startPlayingStream(streamID);
//   }
//
//   Future<void> stopPlayStream(String streamID) async {
//     ZegoExpressEngine.instance.stopPlayingStream(streamID);
//   }
//
//   void onUserLogin({required String uid, required String name}) {
//     /// 1.2.1. initialized ZegoUIKitPrebuiltCallInvitationService
//     /// when app's user is logged in or re-logged in
//     /// We recommend calling this method as soon as the user logs in to your app.
//     ZegoUIKitPrebuiltCallInvitationService().init(
//       appID: Credentials.zegoAppId /*input your AppID*/,
//       appSign: Credentials.zegoAppSign /*input your AppSign*/,
//       userID: uid,
//       userName: name,
//       plugins: [ZegoUIKitSignalingPlugin()],
//     );
//   }
//
//   /// on App's user logout
//   void onUserLogout() {
//     /// 1.2.2. de-initialization ZegoUIKitPrebuiltCallInvitationService
//     /// when app's user is logged out
//     ZegoUIKitPrebuiltCallInvitationService().uninit();
//   }
//
// }