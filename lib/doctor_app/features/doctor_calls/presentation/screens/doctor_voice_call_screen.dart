import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:medifirst/models/appointment_info.dart';
import 'package:zego_uikit_prebuilt_call/zego_uikit_prebuilt_call.dart';

import '../../../../../features/consultation/controller/voice_call_controller.dart';

class DoctorVoiceCallScreen extends ConsumerStatefulWidget {
  final AppointmentInfo appt;

  @override
  ConsumerState<DoctorVoiceCallScreen> createState() => _DoctorVoiceCallScreenState();

  const DoctorVoiceCallScreen({
    required this.appt,
    super.key
  });
}

class _DoctorVoiceCallScreenState extends ConsumerState<DoctorVoiceCallScreen> {

  @override
  void initState() {
    super.initState();
    /**
    WidgetsBinding.instance.addPostFrameCallback((_) {
      ref.read(callProvider.notifier).createCall(widget.appt.patientId, widget.appt.doctorId, widget.appt.aID);
    });
        **/
  }

  @override
  Widget build(BuildContext context) {


    return Scaffold(
      body: Center(
        // child: ZegoSendCallInvitationButton(
        //   isVideoCall:false,
        //   resourceID: 'medifirst',
        //   invitees: [
        //     ZegoUIKitUser(
        //       id: widget.appt.patientId,
        //       name: widget.appt.patientName,
        //     ),
        //   ],
        //   onPressed: (code, message, p2) {
        //     debugPrint('-------------$code------------');
        //     debugPrint('-------------$message------------');
        //     debugPrint('-------------$p2------------');
        //   },
        // ),
        child:  ZegoUIKitPrebuiltCall(
          appID: 1633062655, // Fill in the appID that you get from ZEGOCLOUD Admin Console.
          appSign: 'ef466d1fc4dced798e77349307ac7071966e6dde8ec60ad2fcade947786001a4', // Fill in the appSign that you get from ZEGOCLOUD Admin Console.
          userID: widget.appt.doctorId,
          userName: widget.appt.doctorName,
          callID:widget.appt.aID,
          // You can also use groupVideo/groupVoice/oneOnOneVoice to make more types of calls.
          config: ZegoUIKitPrebuiltCallConfig.oneOnOneVoiceCall(),
        ),
      ),
    );
  }
}
