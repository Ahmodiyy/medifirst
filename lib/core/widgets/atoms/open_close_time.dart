import 'package:flutter/material.dart';
import 'package:medifirst/core/theming/palette.dart';

import '../../theming/spaces.dart';

class OpenCloseTime extends StatelessWidget {
  final TimeOfDay openTime;
  final TimeOfDay closeTime;
  const OpenCloseTime({super.key, required this.openTime, required this.closeTime});

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Text.rich(
          TextSpan(
            children: [
              TextSpan(
                text: 'Opens ',
                style: Palette.lightModeAppTheme.textTheme.bodySmall?.copyWith(fontSize: 14, color: Palette.validationGreen,),
              ),
              //TODO add correct time
              TextSpan(
                text: (openTime.period == DayPeriod.am)
                    ? '${openTime.hourOfPeriod}:${openTime.minute.toString().padLeft(2, '0')}am'
                    : '${openTime.hourOfPeriod}:${openTime.minute.toString().padLeft(2, '0')}pm',
                style: Palette.lightModeAppTheme.textTheme.bodySmall?.copyWith(fontSize: 14, color: Palette.highlightTextGray),
              ),
            ],
          ),
        ),
        9.ph,
        Text(
          '•',
          style: Palette.lightModeAppTheme.textTheme.bodySmall
              ?.copyWith(fontSize: 14, color: Palette.highlightTextGray),
        ),
        9.ph,
        Text.rich(
          TextSpan(
            children: [
              TextSpan(
                text: 'Closes ',
                style: Palette.lightModeAppTheme.textTheme.bodySmall?.copyWith(fontSize: 14, color: Palette.boldRedText,),
              ),
              TextSpan(
                text: (closeTime.period == DayPeriod.am)
                    ? '${closeTime.hourOfPeriod}:${closeTime.minute.toString().padLeft(2, '0')}am'
                    : '${closeTime.hourOfPeriod}:${closeTime.minute.toString().padLeft(2, '0')}pm',
                style: Palette.lightModeAppTheme.textTheme.bodySmall?.copyWith(fontSize: 14, color: Palette.highlightTextGray),
              ),
            ],
          ),
        ),
      ],
    );
  }
}
