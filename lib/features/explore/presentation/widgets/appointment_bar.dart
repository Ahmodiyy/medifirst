import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_svg/svg.dart';
import 'package:intl/intl.dart';
import 'package:medifirst/core/theming/palette.dart';
import 'package:medifirst/core/theming/spaces.dart';
import 'package:medifirst/core/widgets/elements/card_53_image.dart';
import 'package:medifirst/features/auth/controller/auth_controller.dart';
import 'package:medifirst/models/appointment_info.dart';

import '../../../book_doctors/controller/book_doctors_controller.dart';
import '../../../consultation/presentation/screens/chat_page.dart';
import '../../../consultation/presentation/screens/video_call_screen.dart';
import '../../../consultation/presentation/screens/voice_call_screen.dart';
import '../../repository/explore_repository.dart';

final loadingProvider = StateProvider<bool>((ref) => false);

class AppointmentBar extends ConsumerStatefulWidget {
  final AppointmentInfo appointment;

  const AppointmentBar({super.key, required this.appointment});

  @override
  ConsumerState<AppointmentBar> createState() => _AppointmentBarState();
}

class _AppointmentBarState extends ConsumerState<AppointmentBar> {
  late AppointmentInfo appointment;

  @override
  Widget build(BuildContext context) {
    final isLoading = ref.watch(loadingProvider);
    appointment = widget.appointment;
    final user = ref.watch(userProvider);
    return InkWell(
      onTap: () {
        bool isNowWithinRange = _isCurrentTimeWithinRange(
            appointment.startTime.toDate(), appointment.endTime.toDate());
        if (isNowWithinRange) {
          if (appointment.type == 3) {
            Navigator.push(
                context,
                MaterialPageRoute(
                    builder: (context) => ChatPage(
                          appt: appointment,
                        )));
          }
          if (appointment.type == 2) {
            Navigator.push(
                context,
                MaterialPageRoute(
                    builder: (context) => VoiceCallScreen(
                          appt: appointment,
                        )));
          }
          if (appointment.type == 1) {
            Navigator.push(
                context,
                MaterialPageRoute(
                    builder: (context) => VideoCallScreen(
                          appt: appointment,
                        )));
          }
        }
      },
      child: Container(
        width: double.infinity,
        height: 100,
        padding: const EdgeInsets.only(left: 10, right: 10),
        decoration: BoxDecoration(
          color: checkTime() ? Palette.mainGreen : Palette.whiteColor,
        ),
        child: Row(
          children: [
            Card53Image(
              imgUrl: appointment.doctorImageURL,
              height: 50,
              width: 50,
            ),
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
                      style: Palette.lightModeAppTheme.textTheme.titleSmall
                          ?.copyWith(
                        color: checkTime()
                            ? Palette.whiteColor
                            : Palette.blackColor,
                        letterSpacing: 1,
                      ),
                    ),
                  ),
                  Flexible(
                    child: Text(
                      appointment.doctorType,
                      style: Palette.lightModeAppTheme.textTheme.bodySmall
                          ?.copyWith(
                        color: checkTime()
                            ? Palette.whiteColor
                            : Palette.blackColor,
                        letterSpacing: 1,
                      ),
                    ),
                  ),
                  Flexible(
                    child: Row(
                      children: [
                        Text(
                          DateFormat('dd/MM/yyyy')
                              .format(appointment.startTime.toDate()),
                          style: Palette.lightModeAppTheme.textTheme.bodySmall
                              ?.copyWith(
                            color: checkTime()
                                ? Palette.whiteColor
                                : Palette.blackColor,
                            fontSize: 12,
                            letterSpacing: 1,
                          ),
                        ),
                        2.ph,
                        Text(
                          DateFormat.jm()
                              .format(appointment.startTime.toDate()),
                          style: Palette.lightModeAppTheme.textTheme.bodySmall
                              ?.copyWith(
                            color: checkTime()
                                ? Palette.whiteColor
                                : Palette.blackColor,
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
            appointment.appointmentHeld == false &&
                    appointment.refundHeld == false &&
                    DateTime.now().isAfter(appointment.endTime.toDate())
                ? InkWell(
                    onTap: isLoading
                        ? null
                        : () async {
                            ref
                                .read(loadingProvider.notifier)
                                .update((state) => true);
                            final controller =
                                ref.read(bookDoctorsControllerProvider);
                            await controller.removeFeeFromBalance(
                                appointment.patientId, -1 * appointment.price);
                            await ref
                                .read(exploreRepoProvider)
                                .updateRefundHeld(
                                  appt: appointment,
                                  refundHeld: true,
                                );
                            ref
                                .read(loadingProvider.notifier)
                                .update((state) => false);
                            showSuccessSnackbar(context, 'successful');
                          },
                    child: isLoading
                        ? const Center(
                            child: CircularProgressIndicator(
                              color: Palette.consultationDarkGreen,
                            ),
                          )
                        : const Chip(
                            label: Text(
                              "Get Refund",
                              style: TextStyle(
                                color: Palette.consultationDarkGreen,
                              ),
                            ),
                            color: WidgetStatePropertyAll(Palette.whiteColor),
                          ),
                  )
                : SvgPicture.asset(
                    _getIcon(),
                    colorFilter: const ColorFilter.mode(
                        Palette.whiteColor, BlendMode.srcIn),
                    fit: BoxFit.scaleDown,
                    height: 24,
                    width: 24,
                  ),
          ],
        ),
      ),
    );
  }

  String _getIcon() {
    switch (appointment.type) {
      case 1:
        if (checkTime()) {
          return 'assets/icons/svgs/white_video_call.svg';
        }
        return 'assets/icons/svgs/green_video_call.svg';
      case 2:
        if (checkTime()) {
          return 'assets/icons/svgs/white_call.svg';
        }
        return 'assets/icons/svgs/green_call.svg';
      default:
        if (checkTime()) {
          return 'assets/icons/svgs/white_chat.svg';
        }
        return 'assets/icons/svgs/green_chat.svg';
    }
  }

  bool _isCurrentTimeWithinRange(DateTime startTime, DateTime endTime) {
    DateTime now = DateTime.now();
    return (now.isAfter(startTime) || now.isAtSameMomentAs(startTime)) &&
        (now.isBefore(endTime) || now.isAtSameMomentAs(endTime));
  }

  bool checkTime() {
    return DateTime.now().isAfter(appointment.startTime.toDate()) &&
        DateTime.now().isBefore(appointment.endTime.toDate());
  }

  void showSuccessSnackbar(BuildContext context, String message) {
    final snackBar = SnackBar(
      content: Text(message),
      backgroundColor: Palette.mainGreen,
      behavior: SnackBarBehavior.floating,
      duration: const Duration(seconds: 3),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
    );

    ScaffoldMessenger.of(context).showSnackBar(snackBar);
  }
}
