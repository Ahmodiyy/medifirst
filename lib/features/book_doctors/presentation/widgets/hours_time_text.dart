import 'package:flutter/material.dart';
import 'package:medifirst/core/theming/palette.dart';
import 'package:medifirst/core/theming/spaces.dart';

class HoursTimeText extends StatelessWidget {
  final String label;
  final TimeOfDay time;
  const HoursTimeText({
    super.key,
    required this.label,
    required this.time,
  });

  @override
  Widget build(BuildContext context) {
    final Size size = MediaQuery.sizeOf(context);
    return Row(
      mainAxisSize: MainAxisSize.min,
      crossAxisAlignment: CrossAxisAlignment.end,
      children: [
        Text(
          label,
          style: Palette.lightModeAppTheme.textTheme.bodySmall?.copyWith(
            fontSize: 12,
            color: Palette.smallBodyGray,
            height: 0.14,
          ),
        ),
        (size.width * 10 / 393).ph,
        Text(
          (time.period == DayPeriod.am)
              ? '${time.hourOfPeriod}:${time.minute.toString().padLeft(2, '0')}am'
              : '${time.hourOfPeriod}:${time.minute.toString().padLeft(2, '0')}pm',
          style: Palette.lightModeAppTheme.textTheme.bodyLarge?.copyWith(
            fontSize: 14,
            height: 0.14,
          ),
        ),
      ],
    );
  }
}
