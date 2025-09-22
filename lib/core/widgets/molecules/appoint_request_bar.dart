import 'package:flutter/material.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:intl/intl.dart';
import 'package:medifirst/core/theming/palette.dart';
import 'package:medifirst/core/theming/spaces.dart';
import 'package:medifirst/core/widgets/elements/card_53_image.dart';
import 'package:medifirst/core/widgets/elements/section_container.dart';
import 'package:medifirst/doctor_app/features/appointment_list/controller/appointment_list_controller.dart';
import 'package:medifirst/models/appointment_info.dart';
import 'package:timezone/timezone.dart' as tz;

class AppointmentRequestBar extends ConsumerStatefulWidget {
  final AppointmentInfo request;

  const AppointmentRequestBar({
    super.key,
    required this.request,
  });

  @override
  ConsumerState createState() => _AppointRequestBarState();
}

class _AppointRequestBarState extends ConsumerState<AppointmentRequestBar> {
  FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin =
      FlutterLocalNotificationsPlugin();

  Future<void> scheduleNotification(
      int id, String title, String body, DateTime scheduledTime) async {
    await flutterLocalNotificationsPlugin.zonedSchedule(
      id,
      title,
      body,
      tz.TZDateTime.from(scheduledTime, tz.local),
      const NotificationDetails(
        iOS: DarwinNotificationDetails(),
        android: AndroidNotificationDetails(
          'reminder_channel',
          'Reminder Channel',
          importance: Importance.high,
          priority: Priority.high,
        ),
      ),
      uiLocalNotificationDateInterpretation:
          UILocalNotificationDateInterpretation.absoluteTime,
      matchDateTimeComponents: DateTimeComponents.dateAndTime,
      androidScheduleMode: AndroidScheduleMode.inexactAllowWhileIdle,
    );
  }

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    final request = widget.request;
    final Size size = MediaQuery.sizeOf(context);
    return SectionContainer(
      height: size.height * 110 / 852,
      child: SizedBox(
        width: double.infinity,
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisSize: MainAxisSize.max,
          children: [
            Card53Image(
              imgUrl: request.patientImageURL,
              height: 50,
              width: 50,
            ),
            (size.width * 12 / 393).ph,
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                    request.patientName,
                    style: Palette.lightModeAppTheme.textTheme.titleSmall
                        ?.copyWith(
                      letterSpacing: -0.4,
                    ),
                  ),
                  (size.height * 8 / 852).pv,
                  RichText(
                    text: TextSpan(
                        text: DateFormat('dd/MM/yyyy')
                            .format(request.startTime.toDate()),
                        style: Palette.lightModeAppTheme.textTheme.bodySmall
                            ?.copyWith(
                          letterSpacing: -0.4,
                          color: Palette.smallBodyGray,
                        ),
                        children: [
                          TextSpan(
                            text: '   ',
                            style: Palette.lightModeAppTheme.textTheme.bodySmall
                                ?.copyWith(
                              letterSpacing: -0.4,
                              color: Palette.smallBodyGray,
                            ),
                          ),
                          TextSpan(
                            text: DateFormat.jm()
                                .format(request.startTime.toDate()),
                            style: Palette.lightModeAppTheme.textTheme.bodySmall
                                ?.copyWith(
                              letterSpacing: -0.4,
                              color: Palette.smallBodyGray,
                            ),
                          )
                        ]),
                  ),
                  (size.height * 24 / 852).pv,
                  SizedBox(
                    width: double.infinity,
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        InkWell(
                          onTap: () async {
                            try {
                              await ref
                                  .read(appointmentListControllerProvider)
                                  .acceptAppointmentRequest(request);
                              DateTime? remindTime = request.startTime
                                  .toDate()
                                  .subtract(const Duration(minutes: 5));
                              await scheduleNotification(
                                  DateTime.now().millisecondsSinceEpoch %
                                      2147483647,
                                  'Session Time',
                                  "It is almost time for your session",
                                  remindTime);
                            } catch (e) {
                              ScaffoldMessenger.of(context).showSnackBar(
                                  SnackBar(content: Text(e.toString())));
                            }
                          },
                          child: Text(
                            'Accept',
                            style: Palette
                                .lightModeAppTheme.textTheme.bodyMedium
                                ?.copyWith(
                              color: Palette.validationGreen,
                              fontSize: 14,
                            ),
                          ),
                        ),
                        InkWell(
                          onTap: () async {
                            try {
                              await ref
                                  .read(appointmentListControllerProvider)
                                  .rejectAppointmentRequest(request);
                            } catch (e) {
                              ScaffoldMessenger.of(context).showSnackBar(
                                  const SnackBar(
                                      content: Text('An error occurred')));
                            }
                          },
                          child: Text(
                            'Reject',
                            style: Palette
                                .lightModeAppTheme.textTheme.bodyMedium
                                ?.copyWith(
                              color: Palette.redTextColor,
                              fontSize: 14,
                            ),
                          ),
                        ),
                      ],
                    ),
                  )
                ],
              ),
            ),
          ],
        ).sidePad(size.width * 20 / 393).topPad(8),
      ),
    );
  }
}
