import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:http/http.dart' as http;
import 'package:intl/intl.dart';
import 'package:medifirst/core/theming/spaces.dart';
import 'package:medifirst/core/widgets/elements/action_button_container.dart';
import 'package:medifirst/core/widgets/molecules/action_success_modal.dart';
import 'package:medifirst/core/widgets/molecules/error_modal.dart';
import 'package:medifirst/features/auth/controller/auth_controller.dart';
import 'package:medifirst/features/book_doctors/controller/book_doctors_controller.dart';
import 'package:medifirst/features/book_doctors/presentation/widgets/communication_type_button.dart';
import 'package:medifirst/features/book_doctors/presentation/widgets/set_time_section.dart';
import 'package:medifirst/models/doctor_info.dart';
import 'package:medifirst/models/user_info.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:timezone/data/latest.dart' as tz;
import 'package:timezone/timezone.dart' as tz;

import '../../../../core/theming/palette.dart';
import '../../../../core/widgets/elements/section_heading_text.dart';
import '../../../../main.dart';

class BookDoctorPage extends ConsumerStatefulWidget {
  final DoctorInfo doctorInfo;

  const BookDoctorPage({super.key, required this.doctorInfo});

  @override
  ConsumerState createState() => _BookDoctorPageState();
}

class _BookDoctorPageState extends ConsumerState<BookDoctorPage> {
  int selectedIcon = 1;
  bool isRepeated = false;
  DateTime? selectedDate = DateTime.now();
  int _selectedTime = 30;
  bool loading = false;

  final List<int> _timeOptions = [
    5,
    10,
    15,
    30,
    45,
    60,
  ];

  Future<void> initializeNotifications() async {
    const AndroidInitializationSettings androidInitializationSettings =
        AndroidInitializationSettings("@mipmap/ic_launcher");
    const DarwinInitializationSettings iOSInitializationSettings =
        DarwinInitializationSettings();

    const InitializationSettings initializationSettings =
        InitializationSettings(
      android: androidInitializationSettings,
      iOS: iOSInitializationSettings,
    );
    await flutterLocalNotificationsPlugin.initialize(
      initializationSettings,
      onDidReceiveNotificationResponse: onDidReceiveNotification,
      onDidReceiveBackgroundNotificationResponse: onDidReceiveNotification,
    );

    final granted = await flutterLocalNotificationsPlugin
            .resolvePlatformSpecificImplementation<
                AndroidFlutterLocalNotificationsPlugin>()
            ?.requestNotificationsPermission() ??
        false;
    if (!granted) {
      openAppSettings();
    }
    tz.initializeTimeZones(); // Initialize timezone database
  }

  static Future<void> onDidReceiveNotification(
      NotificationResponse notificationResponse) async {
    print("Notification receive");
  }

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

  Future<void> sendNotificationToDoctor({
    required String fcmToken,
    required String title,
    required String body,
  }) async {
    final Uri url =
        Uri.parse('https://sendnotification-eroshkcipq-uc.a.run.app');
    try {
      final response = await http.post(
        url,
        headers: {'Content-Type': 'application/json'},
        body: jsonEncode({
          'token': fcmToken,
          'title': title,
          'body': body,
        }),
      );

      if (response.statusCode == 200) {
        print("✅ Notification sent successfully!");
      } else {
        print("❌ Failed to send notification: ${response.body}");
      }
    } catch (e) {
      print("⚠️ Error sending notification: $e");
    }
  }

  Future<void> setAppointment(
      WidgetRef ref, BuildContext context, UserInfoModel user) async {
    try {
      setState(() {
        loading = true;
      });
      final controller = ref.read(bookDoctorsControllerProvider);
      final balance = await controller.getWallet(user.uid);
      if (balance >= widget.doctorInfo.consultationFee) {
        await controller.removeFeeFromBalance(
            ref.read(userProvider)!.uid, widget.doctorInfo.consultationFee);
        await controller.setAppointment(
            doctor: widget.doctorInfo,
            patient: user,
            type: selectedIcon,
            startTime: selectedDate!,
            reminder: Duration(minutes: _selectedTime),
            isScheduled: isRepeated);
        DateTime? remindTime =
            selectedDate?.subtract(Duration(minutes: _selectedTime));
        await sendNotificationToDoctor(
            fcmToken: widget.doctorInfo.fcmToken,
            title: 'Appointment Booked',
            body: 'You have a new appointment');
        await scheduleNotification(
            DateTime.now().millisecondsSinceEpoch % 2147483647,
            'Session Time',
            "It is almost time for your session",
            remindTime!);

        setState(() {
          loading = false;
        });
        // await controller.removeFeeFromBalance(user.uid, widget.doctorInfo.consultationFee);
        showModalBottomSheet(
            context: context, builder: (context) => const ActionSuccessModal());
      } else {
        setState(() {
          loading = false;
        });
        throw 'Top up your balance';
      }
    } catch (e) {
      setState(() {
        loading = false;
      });
      showModalBottomSheet(
          context: context,
          builder: (context) => ErrorModal(message: e.toString()));
    }
  }

  @override
  void initState() {
    super.initState();
    initializeNotifications();
  }

  @override
  Widget build(BuildContext context) {
    final doctor = widget.doctorInfo;
    final user = ref.watch(userProvider);
    final Size size = MediaQuery.sizeOf(context);
    return Scaffold(
      backgroundColor: Palette.backGroundColor,
      appBar: AppBar(
        backgroundColor: Palette.whiteColor,
        centerTitle: true,
        automaticallyImplyLeading: false,
        leading: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            IconButton(
              onPressed: () {
                Navigator.pop(context);
              },
              padding: const EdgeInsets.only(right: 1),
              icon: const Icon(
                Icons.chevron_left_sharp,
                color: Palette.blackColor,
              ),
            ),
          ],
        ),
        title: Text(
          'Dr. ${doctor.name}',
          style: Palette.lightModeAppTheme.textTheme.bodySmall?.copyWith(
            fontSize: 20,
          ),
        ),
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          child: Column(
            children: [
              Container(
                width: double.infinity,
                height: size.height * 315 / 852,
                padding: EdgeInsets.symmetric(
                    vertical: size.height * 20 / 852,
                    horizontal: size.width * 16 / 393),
                decoration: BoxDecoration(
                  image: DecorationImage(
                    image: NetworkImage(doctor.doctorImage),
                    fit: BoxFit.fill,
                  ),
                ),
                child: Align(
                  alignment: Alignment.topRight,
                  child: Container(
                    height: 43,
                    width: 43,
                    decoration: const ShapeDecoration(
                      shape: OvalBorder(),
                      color: Colors.transparent,
                    ),
                  ),
                ),
              ),
              (size.height * 10 / 852).pv,
              Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  InkWell(
                    onTap: () {
                      setState(() {
                        selectedIcon = 2;
                      });
                    },
                    child: CommunicationTypeButton(
                      icon: (selectedIcon == 2)
                          ? 'assets/icons/svgs/white_call.svg'
                          : 'assets/icons/svgs/green_call.svg',
                      color: (selectedIcon == 2)
                          ? Palette.mainGreen
                          : Palette.highlightGreen,
                      label: 'Voice Call',
                    ),
                  ),
                  // (size.width * 8 / 393).ph,
                  // InkWell(
                  //   onTap: () {
                  //     setState(() {
                  //       selectedIcon = 3;
                  //     });
                  //   },
                  //   child: CommunicationTypeButton(
                  //     icon: (selectedIcon == 3)
                  //         ? 'assets/icons/svgs/white_chat.svg'
                  //         : 'assets/icons/svgs/green_chat.svg',
                  //     color: (selectedIcon == 3)
                  //         ? Palette.mainGreen
                  //         : Palette.highlightGreen,
                  //     label: 'Chat',
                  //   ),
                  // ),
                  (size.width * 8 / 393).ph,
                  InkWell(
                    onTap: () {
                      setState(() {
                        selectedIcon = 1;
                      });
                    },
                    child: CommunicationTypeButton(
                      icon: (selectedIcon == 1)
                          ? 'assets/icons/svgs/white_video_call.svg'
                          : 'assets/icons/svgs/green_video_call.svg',
                      color: (selectedIcon == 1)
                          ? Palette.mainGreen
                          : Palette.highlightGreen,
                      label: 'Video Call',
                    ),
                  ),
                ],
              ),
              (size.height * 32 / 852).pv,
              const SectionHeadingText(heading: 'APPOINTMENT DATE')
                  .sidePad(16)
                  .alignLeft(),
              (size.height * 12 / 852).pv,
              SetTimeSection(
                label: 'Set date',
                child: InkWell(
                  onTap: () async {
                    DateTime? getDate = await showDatePicker(
                        context: context,
                        initialDate: DateTime.now(),
                        firstDate: DateTime.now(),
                        lastDate: DateTime(2030, 12, 31, 24));
                    if (getDate != null) {
                      selectedDate = getDate;
                      setState(() {});
                    }
                  },
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Text(
                        DateFormat.yMd().format(selectedDate!),
                        style: Palette.lightModeAppTheme.textTheme.bodySmall
                            ?.copyWith(
                          color: Palette.highlightTextGray,
                          height: 0.15,
                          fontSize: 14,
                        ),
                      ),
                      (size.width * 16 / 393).ph,
                      SvgPicture.asset(
                        'assets/icons/svgs/calendar.svg',
                        height: 24,
                        width: 24,
                      ),
                    ],
                  ),
                ),
              ),
              (size.height * 24 / 852).pv,
              const SectionHeadingText(heading: 'APPOINTMENT TIME')
                  .sidePad(size.width * 16 / 393)
                  .alignLeft(),
              (size.height * 12 / 852).pv,
              SetTimeSection(
                label: 'Set time',
                child: InkWell(
                  onTap: () async {
                    TimeOfDay? getTime = await showTimePicker(
                        context: context,
                        initialTime: TimeOfDay.fromDateTime(selectedDate!));
                    if (getTime != null) {
                      selectedDate = DateTime(
                          selectedDate!.year,
                          selectedDate!.month,
                          selectedDate!.day,
                          getTime.hour,
                          getTime.minute);
                      setState(() {});
                    }
                  },
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Text(
                        DateFormat.jm().format(selectedDate!),
                        style: Palette.lightModeAppTheme.textTheme.bodySmall
                            ?.copyWith(
                          color: Palette.highlightTextGray,
                          height: 0.15,
                          fontSize: 14,
                        ),
                      ),
                      (size.width * 16 / 393).ph,
                      SvgPicture.asset(
                        'assets/icons/svgs/clock.svg',
                        height: 24,
                        width: 24,
                      ),
                    ],
                  ),
                ),
              ),
              (size.height * 24 / 852).pv,
              const SectionHeadingText(heading: 'REMINDER')
                  .sidePad(16)
                  .alignLeft(),
              (size.height * 12 / 852).pv,
              SetTimeSection(
                label: 'Set reminder',
                child: DropdownButton<int>(
                  value: _selectedTime,
                  icon: const Icon(
                    Icons.arrow_drop_down,
                    size: 24,
                    color: Palette.iconDarkGrey,
                  ),
                  style:
                      Palette.lightModeAppTheme.textTheme.bodySmall?.copyWith(
                    color: Palette.highlightTextGray,
                    height: 0.15,
                    fontSize: 14,
                  ),
                  underline: Container(),
                  onChanged: (int? newValue) {
                    setState(() {
                      _selectedTime = newValue!;
                    });
                  },
                  items: _timeOptions.map<DropdownMenuItem<int>>((int value) {
                    return DropdownMenuItem<int>(
                      value: value,
                      child: Text('$value mins'),
                    );
                  }).toList(),
                ),
              ),
              (size.height * 24 / 852).pv,
              /**
                  const SectionHeadingText(heading: 'SCHEDULE BOOKING')
                  .sidePad(16)
                  .alignLeft(),
                  (size.height * 12 / 852).pv,

                  SetTimeSection(
                  label: 'Simplify your schedule with seamless, repeat bookings',
                  height: 64,
                  child: CupertinoSwitch(
                  value: isRepeated,
                  activeColor: Palette.mainGreen,
                  onChanged: (newValue) {
                  setState(() {
                  isRepeated = !isRepeated;
                  });
                  },
                  ),
                  ),
                  (size.height * 25/852).pv,
               **/
              InkWell(
                      onTap: () async {
                        await setAppointment(ref, context, user!);
                      },
                      child: loading
                          ? const CircularProgressIndicator(
                              color: Palette.mainGreen,
                            )
                          : const ActionButtonContainer(
                              title: 'Book an appointment'))
                  .sidePad(size.width * 16 / 393),
              (size.height * 24 / 852).pv,
            ],
          ),
        ),
      ),
    );
  }
}
