import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:intl/intl.dart';
import 'package:medifirst/core/theming/spaces.dart';
import 'package:medifirst/core/widgets/elements/card_53_image.dart';
import 'package:medifirst/core/widgets/elements/section_container.dart';
import 'package:medifirst/doctor_app/features/doctor_calls/repository/doctors_calls_repository.dart';
import 'package:medifirst/models/appointment_info.dart';

import '../../../../../core/theming/palette.dart';
import '../../../../../features/book_doctors/controller/book_doctors_controller.dart';

final loadingProvider = StateProvider<bool>((ref) => false);

class AppointmentShortInfoBar extends ConsumerWidget {
  final AppointmentInfo appointment;

  const AppointmentShortInfoBar({super.key, required this.appointment});

  String _getIcon() {
    switch (appointment.type) {
      case 1:
        if (DateTime.now().isAfter(appointment.startTime.toDate()) &&
            DateTime.now().isBefore(appointment.endTime.toDate())) {
          return 'assets/icons/svgs/white_video_call.svg';
        }
        return 'assets/icons/svgs/green_video_call.svg';
      case 2:
        if (DateTime.now().isAfter(appointment.startTime.toDate()) &&
            DateTime.now().isBefore(appointment.endTime.toDate())) {
          return 'assets/icons/svgs/white_call.svg';
        }
        return 'assets/icons/svgs/green_call.svg';
      default:
        if (DateTime.now().isAfter(appointment.startTime.toDate()) &&
            DateTime.now().isBefore(appointment.endTime.toDate())) {
          return 'assets/icons/svgs/white_chat.svg';
        }
        return 'assets/icons/svgs/green_chat.svg';
    }
  }

  bool checkTime() {
    return DateTime.now().isAfter(appointment.startTime.toDate()) &&
        DateTime.now().isBefore(appointment.endTime.toDate());
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final isLoading = ref.watch(loadingProvider);
    return SectionContainer(
      height: 93,
      backgroundColor: checkTime() ? Palette.mainGreen : Palette.whiteColor,
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Card53Image(
            imgUrl: appointment.patientImageURL,
            height: 50,
            width: 50,
          ),
          10.ph,
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisAlignment: MainAxisAlignment.start,
            children: [
              Text(
                appointment.patientName,
                style: Palette.lightModeAppTheme.textTheme.titleSmall?.copyWith(
                  letterSpacing: -0.4,
                  color: checkTime() ? Palette.whiteColor : Palette.blackColor,
                ),
              ),
              10.pv,
              (DateTime.now().isAfter(appointment.startTime.toDate()) &&
                      DateTime.now().isBefore(appointment.endTime.toDate()))
                  ? Text(
                    'Now',
                    style: Palette.lightModeAppTheme.textTheme.bodySmall
                        ?.copyWith(
                          letterSpacing: -0.4,
                          color:
                              checkTime()
                                  ? Palette.whiteColor
                                  : Palette.blackColor,
                        ),
                  )
                  : RichText(
                    text: TextSpan(
                      text: DateFormat(
                        'dd/MM/yyyy',
                      ).format(appointment.startTime.toDate()),
                      style: Palette.lightModeAppTheme.textTheme.bodySmall
                          ?.copyWith(
                            letterSpacing: -0.4,
                            color: Palette.smallBodyGray,
                          ),
                      children: [
                        const TextSpan(text: ' '),
                        TextSpan(
                          text: DateFormat.jm().format(
                            appointment.startTime.toDate(),
                          ),
                          style: Palette.lightModeAppTheme.textTheme.bodySmall
                              ?.copyWith(
                                letterSpacing: -0.4,
                                color: Palette.smallBodyGray,
                              ),
                        ),
                      ],
                    ),
                  ),
            ],
          ),
          Flexible(child: Container()),
          appointment.appointmentHeld == true &&
                  appointment.paymentHeld == false &&
                  DateTime.now().isAfter(appointment.endTime.toDate())
              ? InkWell(
                child:
                    isLoading
                        ? const Center(
                          child: CircularProgressIndicator(
                            color: Palette.consultationDarkGreen,
                          ),
                        )
                        : const Chip(
                          label: Text(
                            "Get Payment",
                            style: TextStyle(
                              color: Palette.consultationDarkGreen,
                            ),
                          ),
                          color: WidgetStatePropertyAll(Palette.whiteColor),
                        ),
                onTap:
                    isLoading
                        ? null
                        : () async {
                          ref
                              .read(loadingProvider.notifier)
                              .update((state) => true);
                          final book = ref.read(bookDoctorsControllerProvider);
                          await book.removeFeeFromBalance(
                            appointment.patientId,
                            appointment.price,
                          );
                          await book.removeFeeFromBalance(
                            appointment.doctorId,
                            -1 * appointment.price,
                          );
                          await ref
                              .read(doctorChatRepoProvider)
                              .updatePaymentHeld(
                                appt: appointment,
                                paymentHeld: true,
                              );
                          await book.logTransaction(
                            appointment.patientId,
                            appointment.price.toDouble(),
                            appointment.doctorId,
                          );
                          ref
                              .read(loadingProvider.notifier)
                              .update((state) => false);
                          showSuccessSnackbar(context, 'successful');
                        },
              )
              : SvgPicture.asset(_getIcon(), width: 24, height: 24),
        ],
      ).sidePad(16).topPad(20),
    );
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
