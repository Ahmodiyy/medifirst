import 'package:flutter/material.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:medifirst/core/theming/spaces.dart';
import 'package:medifirst/core/widgets/molecules/appoint_request_bar.dart';
import 'package:medifirst/doctor_app/features/appointment_list/controller/appointment_list_controller.dart';
import 'package:medifirst/doctor_app/features/appointment_list/presentation/widgets/appointment_short_info_bar.dart';
import 'package:medifirst/doctor_app/features/doctor_calls/presentation/screens/doctor_chat_page.dart';
import 'package:medifirst/doctor_app/features/doctor_calls/presentation/screens/doctor_video_call_screen.dart';
import 'package:medifirst/doctor_app/features/doctor_calls/presentation/screens/doctor_voice_call_screen.dart';
import 'package:medifirst/features/auth/controller/auth_controller.dart';

import '../../../../../core/theming/palette.dart';
import '../../../../../core/widgets/elements/error_text.dart';
import '../../../../../core/widgets/elements/loader.dart';import 'package:timezone/data/latest.dart' as tz;
import 'package:timezone/timezone.dart' as tz;

class AppointmentListScreen extends ConsumerStatefulWidget {
  const AppointmentListScreen({super.key});

  @override
  ConsumerState createState() => _AppointmentListScreenState();
}

class _AppointmentListScreenState extends ConsumerState<AppointmentListScreen> {

  ValueNotifier<int> panel = ValueNotifier(0);
  @override
  Widget build(BuildContext context) {
    final doctor = ref.watch(doctorProvider);
    final Size size = MediaQuery.sizeOf(context);
    return Scaffold(
      backgroundColor: Palette.backGroundColor,
      appBar: AppBar(
        backgroundColor: Palette.whiteColor,
        centerTitle: true,
        automaticallyImplyLeading: false,
        leading: IconButton(
          onPressed: () {
            Navigator.pop(context);
          },
          icon: Icon(
            Icons.chevron_left,
            color: Palette.blackColor,
            size: size.height * 24 / 852,
          ),
          padding: EdgeInsets.symmetric(horizontal: size.width * 16 / 393),
        ),
        title: Text(
          'Appointments',
          style: Palette.lightModeAppTheme.textTheme.bodySmall?.copyWith(
            fontSize: 20,
          ),
        ),
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          child: Column(
            children: [
              (size.height * 42 / 852).pv,
              ValueListenableBuilder(
                valueListenable: panel,
                builder: (BuildContext context, int value, Widget? child) {
                  return Row(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    crossAxisAlignment: CrossAxisAlignment.baseline,
                    textBaseline: TextBaseline.alphabetic,
                    children: [
                      InkWell(
                        onTap: () {
                          panel.value = 0;
                        },
                        child: Text(
                          'Requests',
                          style: Palette.lightModeAppTheme.textTheme.titleSmall
                              ?.copyWith(
                                  fontSize: 16,
                                  color: (panel.value == 0)
                                      ? Palette.blackColor
                                      : Palette.highlightTextGray),
                        ),
                      ),
                      InkWell(
                        onTap: () {
                          panel.value = 1;
                        },
                        child: Text(
                          'Video Call',
                          style: Palette.lightModeAppTheme.textTheme.titleSmall
                              ?.copyWith(
                                  fontSize: 16,
                                  color: (panel.value == 1)
                                      ? Palette.blackColor
                                      : Palette.highlightTextGray),
                        ),
                      ),
                      InkWell(
                        onTap: () {
                          panel.value = 2;
                        },
                        child: Text(
                          'Voice Call',
                          style: Palette.lightModeAppTheme.textTheme.titleSmall
                              ?.copyWith(
                                  fontSize: 16,
                                  color: (panel.value == 2)
                                      ? Palette.blackColor
                                      : Palette.highlightTextGray),
                        ),
                      ),
                      InkWell(
                        onTap: () {
                          panel.value = 3;
                        },
                        child: Text(
                          'Chat',
                          style: Palette.lightModeAppTheme.textTheme.titleSmall
                              ?.copyWith(
                                  fontSize: 16,
                                  color: (panel.value == 3)
                                      ? Palette.blackColor
                                      : Palette.highlightTextGray),
                        ),
                      ),
                      (size.width * 27 / 393).ph,
                    ],
                  ).sidePad(size.width * 4 / 393);
                },
              ),
              (size.height * 12 / 852).pv,
              SizedBox(
                height: size.height * 582 / 852,
                child: ValueListenableBuilder(
                  valueListenable: panel,
                  builder: (BuildContext context, int value, Widget? child) {
                    switch (value) {
                      case 0:
                        return ref
                            .watch(getDoctorAppointmentRequestsProvider(
                                doctor!.doctorId))
                            .when(
                                data: (requests) {
                                  return ListView.builder(
                                    itemCount: requests.length,
                                    itemBuilder: (context, index) {
                                      final appt = requests[index];
                                      return AppointmentRequestBar(
                                          request: appt,
                                      );
                                    },
                                  );
                                },
                                error: (error, stackTrace) =>
                                    const ErrorText(error: 'An error occurred'),
                                loading: () => const Loader());
                      case 1:
                        return ref
                            .watch(getDoctorVideoAppointmentsProvider(
                                doctor!.doctorId))
                            .when(
                                data: (appts) {
                                  return ListView.builder(
                                    itemCount: appts.length,
                                    itemBuilder: (context, index) {
                                      final appt = appts[index];
                                      return InkWell(
                                          onTap: () {
                                            bool isNowWithinRange =
                                            isCurrentTimeWithinRange(appt.startTime.toDate(), appt.endTime.toDate());
                                            if (isNowWithinRange) {
                                              Navigator.push(
                                                  context,
                                                  MaterialPageRoute(
                                                      builder: (context) =>
                                                          DoctorVideoCallScreen(
                                                              appt: appt)));


                                            }
                                          },
                                          child: AppointmentShortInfoBar(
                                              appointment: appt));
                                    },
                                  );
                                },
                                error: (error, stackTrace) =>
                                    const ErrorText(error: 'An error occurred'),
                                loading: () => const Loader());
                      case 2:
                        return ref
                            .watch(getDoctorVoiceAppointmentsProvider(
                                doctor!.doctorId))
                            .when(
                                data: (appts) {
                                  return ListView.builder(
                                    itemCount: appts.length,
                                    itemBuilder: (context, index) {
                                      final appt = appts[index];
                                      return InkWell(
                                          onTap: () {
                                            bool isNowWithinRange =
                                            isCurrentTimeWithinRange(appt.startTime.toDate(), appt.endTime.toDate());
                                            if (isNowWithinRange) {
                                              Navigator.push(
                                                  context,
                                                  MaterialPageRoute(
                                                      builder: (context) =>
                                                          DoctorVoiceCallScreen(
                                                              appt: appt)));

                                            }
                                          },
                                          child: AppointmentShortInfoBar(
                                              appointment: appt));
                                    },
                                  );
                                },
                                error: (error, stackTrace) =>
                                    const ErrorText(error: 'An error occurred'),
                                loading: () => const Loader());
                      default:
                        return ref
                            .watch(getDoctorChatAppointmentsProvider(
                                doctor!.doctorId))
                            .when(
                                data: (requests) {
                                  return ListView.builder(
                                    itemCount: requests.length,
                                    itemBuilder: (context, index) {
                                      final appt = requests[index];
                                      return InkWell(
                                          onTap: () {
                                            bool isNowWithinRange =
                                            isCurrentTimeWithinRange(appt.startTime.toDate(), appt.endTime.toDate());
                                            if (isNowWithinRange) {
                                              Navigator.push(
                                                  context,
                                                  MaterialPageRoute(
                                                      builder: (context) =>
                                                          DoctorChatPage(appt: appt)));
                                            }
                                          },
                                          child: AppointmentShortInfoBar(
                                              appointment: appt));
                                    },
                                  );
                                },
                                error: (error, stackTrace) =>
                                    const ErrorText(error: 'An error occurred'),
                                loading: () => const Loader());
                    }
                  },
                ),
              )
            ],
          ),
        ),
      ),
    );
  }
  bool isCurrentTimeWithinRange(DateTime startTime, DateTime endTime) {
    DateTime now = DateTime.now();
    // Debug prints to check values and conditions
    debugPrint('now: ${now.toString()}');
    debugPrint('startTime: ${startTime.toString()}');
    debugPrint('endTime: ${endTime.toString()}');
    debugPrint('first condition: ${(now.isAfter(startTime) || now.isAtSameMomentAs(startTime))}');
    debugPrint('second condition: ${(now.isBefore(endTime) || now.isAtSameMomentAs(endTime))}');

    // Check if 'now' is within the range of startTime and endTime
    return (now.isAfter(startTime) || now.isAtSameMomentAs(startTime)) &&
        (now.isBefore(endTime) || now.isAtSameMomentAs(endTime));
  }


}
