import 'package:flutter/material.dart';
import 'package:medifirst/core/theming/palette.dart';
import 'package:medifirst/core/theming/spaces.dart';
import 'package:medifirst/models/healthcare_centre_info.dart';

class AddressBar extends StatelessWidget {
  final HealthcareCentreInfo practice;
  const AddressBar({super.key, required this.practice});

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        Text(
          practice.type,
          style: Palette.lightModeAppTheme.textTheme.bodySmall
              ?.copyWith(fontSize: 14, color: Palette.highlightTextGray),
        ),
        9.ph,
        Text(
          '•',
          style: Palette.lightModeAppTheme.textTheme.bodySmall
              ?.copyWith(fontSize: 14, color: Palette.highlightTextGray),
        ),
        9.ph,
        SizedBox(
          width: 144,
          child: Text(
            practice.address,
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
            style: Palette.lightModeAppTheme.textTheme.bodySmall
                ?.copyWith(fontSize: 14, color: Palette.highlightTextGray),
          ),
        )
      ],
    );
  }
}
