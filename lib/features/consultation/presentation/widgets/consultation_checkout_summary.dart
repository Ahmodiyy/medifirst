import 'package:flutter/material.dart';
import 'package:medifirst/core/theming/palette.dart';
import 'package:medifirst/core/theming/spaces.dart';
import 'package:medifirst/core/widgets/elements/section_container.dart';
import 'package:medifirst/models/appointment_info.dart';

class ConsultationCheckoutSummary extends StatelessWidget {
  final AppointmentInfo appointment;
  const ConsultationCheckoutSummary({super.key, required this.appointment});

  @override
  Widget build(BuildContext context) {
    final Size size = MediaQuery.sizeOf(context);
    return SectionContainer(
      height: size.height * 141 / 852,
      child: Padding(
        padding: EdgeInsets.symmetric(horizontal: size.width * 16/393, vertical: size.height * 20/852),
        child: Column(
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text('Consultation fee', style: Palette.lightModeAppTheme.textTheme.bodySmall?.copyWith(
                  fontSize: 12,
                ),),
                Text('N${appointment.price}', style: Palette.lightModeAppTheme.textTheme.bodySmall?.copyWith(
                  fontSize: 12
                ),),
              ],
            ),
            (size.height * 20/852).pv,
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text('Extended time', style: Palette.lightModeAppTheme.textTheme.bodySmall?.copyWith(
                  fontSize: 12,
                ),),
                Text('00:00:00', style: Palette.lightModeAppTheme.textTheme.bodySmall?.copyWith(
                    fontSize: 12
                ),),
              ],
            ),
            (size.height * 20/852).pv,
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text('Total time spent', style: Palette.lightModeAppTheme.textTheme.bodySmall?.copyWith(
                  fontSize: 12,
                ),),
                Text('01:00:00', style: Palette.lightModeAppTheme.textTheme.bodySmall?.copyWith(
                    fontSize: 12
                ),),
              ],
            ),
            (size.height * 24/852).pv,
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text('Total amount', style: Palette.lightModeAppTheme.textTheme.bodyLarge?.copyWith(
                  fontSize: 14,
                ),),
                Text('N${appointment.price}', style: Palette.lightModeAppTheme.textTheme.bodyLarge?.copyWith(
                    fontSize: 14
                ),),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
