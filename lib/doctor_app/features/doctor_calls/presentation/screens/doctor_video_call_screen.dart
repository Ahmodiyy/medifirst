import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:medifirst/core/theming/palette.dart';
import 'package:medifirst/models/appointment_info.dart';
import 'package:zego_uikit/zego_uikit.dart';
import 'package:zego_uikit_prebuilt_call/zego_uikit_prebuilt_call.dart';


import '../../../../../features/auth/controller/auth_controller.dart';
import '../../../../../features/consultation/controller/video_call_controller.dart';

class DoctorVideoCallScreen extends ConsumerStatefulWidget {
  final AppointmentInfo appt;

  @override
  ConsumerState<DoctorVideoCallScreen> createState() =>
      _DoctorVideoCallScreenState();

  const DoctorVideoCallScreen({required this.appt, super.key});
}

class _DoctorVideoCallScreenState extends ConsumerState<DoctorVideoCallScreen> {
  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      //appBar: AppBar(title: const Text('Video Appointment')),
      body: Center(
        // child: ZegoSendCallInvitationButton(
        // isVideoCall: true,
        // resourceID: 'medifirst',
        // invitees: [
        //   ZegoUIKitUser(
        //     id: widget.appt.patientId,
        //     name: widget.appt.patientName,
        //   ),
        // ],
        // onPressed: (code, message, p2) {
        //   debugPrint('-------------$code------------');
        //   debugPrint('-------------$message------------');
        //   debugPrint('-------------$p2------------');
        // },
        //       ),
        child:  ZegoUIKitPrebuiltCall(
          appID: 1633062655, // Fill in the appID that you get from ZEGOCLOUD Admin Console.
          appSign: 'ef466d1fc4dced798e77349307ac7071966e6dde8ec60ad2fcade947786001a4', // Fill in the appSign that you get from ZEGOCLOUD Admin Console.
          userID: widget.appt.doctorId,
          userName: widget.appt.doctorName,
          callID:widget.appt.aID,
          // You can also use groupVideo/groupVoice/oneOnOneVoice to make more types of calls.
          config: ZegoUIKitPrebuiltCallConfig.oneOnOneVideoCall(),
        ),
      ),
    );
  }
}
