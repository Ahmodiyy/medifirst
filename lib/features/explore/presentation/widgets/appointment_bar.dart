import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter_svg/svg.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:intl/intl.dart';
import 'package:medifirst/core/constants/data.dart';
import 'package:medifirst/core/theming/palette.dart';
import 'package:medifirst/core/theming/spaces.dart';
import 'package:medifirst/core/widgets/elements/card_53_image.dart';
import 'package:medifirst/features/auth/controller/auth_controller.dart';
import 'package:medifirst/models/appointment_info.dart';

import 'package:flutter_chat_types/flutter_chat_types.dart' as types;
import 'package:zego_uikit_prebuilt_call/zego_uikit_prebuilt_call.dart';

import '../../../../doctor_app/features/doctor_calls/presentation/screens/doctor_chat_page.dart';
import '../../../consultation/presentation/screens/chat_page.dart';
import '../../../consultation/presentation/screens/video_call_screen.dart';
import '../../../consultation/presentation/screens/voice_call_screen.dart';

class AppointmentBar extends ConsumerStatefulWidget {
  final AppointmentInfo appointment;
  const AppointmentBar({super.key, required this.appointment});

  @override
  ConsumerState<AppointmentBar> createState() => _AppointmentBarState();
}

class _AppointmentBarState extends ConsumerState<AppointmentBar> {
  @override
  Widget build(BuildContext context) {
    debugPaintSizeEnabled=false;
    final AppointmentInfo appointment = widget.appointment;
    final user = ref.watch(userProvider);
    return InkWell(
      onTap: () {
        if(appointment.type == 3){
          Navigator.push(
              context,
              MaterialPageRoute(
                  builder: (context) =>
                      ChatPage(
                        appt: appointment,
                      )));
        }
        if(appointment.type == 2){
          Navigator.push(
              context,
              MaterialPageRoute(
                  builder: (context) =>
                      VoiceCallScreen(
                        appt: appointment,
                      )));
        }
        if(appointment.type == 1){
          Navigator.push(
              context,
              MaterialPageRoute(
                  builder: (context) =>
                      VideoCallScreen(
                        appt: appointment,
                      )));

        }
      },
      child: Container(
        width: double.infinity,
        height: 100,
        padding: const EdgeInsets.only(left: 10, right: 10),
        decoration: const BoxDecoration(
          color: Palette.mainGreen,
          // borderRadius: BorderRadius.circular(10),
        ),
        child: Row(
          children: [
            Card53Image(imgUrl: appointment.doctorImageURL,height: 50, width: 50,),
            12.ph,
            Padding(
              padding: const EdgeInsets.symmetric(vertical: 20),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  Flexible(
                    child: Text(
                      appointment.doctorName,
                      style: Palette.lightModeAppTheme.textTheme.titleSmall?.copyWith(
                        color: Colors.white,
                        letterSpacing: 1,
                      ),
                    ),
                  ),

                  //TODO add doctor type
                  Flexible(
                    child: Text(
                      appointment.doctorType,
                      style: Palette.lightModeAppTheme.textTheme.bodySmall?.copyWith(
                        color: Colors.white,
                        letterSpacing: 1,
                      ),
                    ),
                  ),

                  //TODO add correct date
                  Flexible(
                    child: Row(
                      children: [
                        Text(
                          DateFormat('dd/MM/yyyy')
                              .format(appointment.startTime.toDate()),
                          style: Palette.lightModeAppTheme.textTheme.bodySmall?.copyWith(
                            color: Colors.white,
                            fontSize: 12,
                            letterSpacing: 1,
                          ),
                        ),
                        2.ph,
                        Text(
                          DateFormat.jm()
                              .format(appointment.startTime.toDate()),
                          style: Palette.lightModeAppTheme.textTheme.bodySmall?.copyWith(
                            color: Colors.white,
                            fontSize: 12,
                            letterSpacing: 1,
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
            Flexible(child: Container()),
            //TODO add correct icon
            SvgPicture.asset(
              Data.appointmentIcon[appointment.type]!,
              colorFilter: const ColorFilter.mode(
                  Palette.whiteColor,
                  BlendMode.srcIn),
              fit: BoxFit.scaleDown,
              height: 24,
              width: 24,
            ),
          ],
        ),
      ),
    );
  }
}
