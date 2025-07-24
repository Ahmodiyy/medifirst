import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:zego_uikit_prebuilt_call/zego_uikit_prebuilt_call.dart';

import '../../../../models/appointment_info.dart';
import '../../repository/chat_repository.dart';

class VoiceCallScreen extends ConsumerWidget {
  final AppointmentInfo appt;

  const VoiceCallScreen({required this.appt, super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Scaffold(
      body: Center(
        child: ZegoUIKitPrebuiltCall(
          appID: int.parse(
              const String.fromEnvironment(
                  'zegoCloudAppId', defaultValue: '1')),
          appSign:
          const String.fromEnvironment('zegoCloudAppSign', defaultValue: ''),
          userID: appt.patientId,
          userName: appt.patientName,
          callID: appt.aID,
          config: ZegoUIKitPrebuiltCallConfig.oneOnOneVoiceCall(),
          events: ZegoUIKitPrebuiltCallEvents(
            user: ZegoCallUserEvents(
              onEnter: (ZegoUIKitUser remoteUser) {
                ref
                    .read(chatRepoProvider)
                    .updateAppointmentHeld(appt: appt, appointmentHeld: true);
              },
            ),
          ),
        ),
      ),
    );
  }
}
