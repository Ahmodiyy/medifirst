import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:zego_uikit_prebuilt_call/zego_uikit_prebuilt_call.dart';

import '../../../../models/appointment_info.dart';

class VideoCallScreen extends ConsumerWidget {
  final AppointmentInfo appt;
  const VideoCallScreen({required this.appt, super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Scaffold(
      body: Center(
        child: ZegoUIKitPrebuiltCall(
          appID:
              1633062655, // Fill in the appID that you get from ZEGOCLOUD Admin Console.
          appSign:
              'ef466d1fc4dced798e77349307ac7071966e6dde8ec60ad2fcade947786001a4', // Fill in the appSign that you get from ZEGOCLOUD Admin Console.
          userID: appt.patientId,
          userName: appt.patientName,
          callID: appt.aID,
          // You can also use groupVideo/groupVoice/oneOnOneVoice to make more types of calls.
          config: ZegoUIKitPrebuiltCallConfig.oneOnOneVideoCall(),
        ),
      ),
    );
  }
}
