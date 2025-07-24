import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:medifirst/models/appointment_info.dart';
import 'package:zego_uikit_prebuilt_call/zego_uikit_prebuilt_call.dart';

import '../../repository/doctors_calls_repository.dart';

class DoctorVoiceCallScreen extends ConsumerStatefulWidget {
  final AppointmentInfo appt;

  @override
  ConsumerState<DoctorVoiceCallScreen> createState() =>
      _DoctorVoiceCallScreenState();

  const DoctorVoiceCallScreen({required this.appt, super.key});
}

class _DoctorVoiceCallScreenState extends ConsumerState<DoctorVoiceCallScreen> {
  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: ZegoUIKitPrebuiltCall(
          appID: int.parse(
              const String.fromEnvironment(
                  'zegoCloudAppId', defaultValue: '1')),
          appSign:
          const String.fromEnvironment('zegoCloudAppSign', defaultValue: ''),
          userID: widget.appt.doctorId,
          userName: widget.appt.doctorName,
          callID: widget.appt.aID,
          // You can also use groupVideo/groupVoice/oneOnOneVoice to make more types of calls.
          config: ZegoUIKitPrebuiltCallConfig.oneOnOneVoiceCall(),
          events: ZegoUIKitPrebuiltCallEvents(
            user: ZegoCallUserEvents(
              onEnter: (ZegoUIKitUser remoteUser) {
                ref.read(doctorChatRepoProvider).updateAppointmentHeld(
                    appt: widget.appt, appointmentHeld: true);
              },
            ),
          ),
        ),
      ),
    );
  }
}
