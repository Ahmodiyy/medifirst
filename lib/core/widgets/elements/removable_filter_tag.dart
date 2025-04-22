import 'package:flutter/material.dart';
import 'package:medifirst/core/theming/palette.dart';
import 'package:medifirst/core/theming/spaces.dart';

class RemovableFilterTag extends StatelessWidget {
  final String label;
  final Color? backgroundColor;
  final Color? labelColor;
  const RemovableFilterTag(
      {super.key,
        required this.label,
        this.backgroundColor = Palette.mainGreen,
        this.labelColor = Palette.whiteColor});

  @override
  Widget build(BuildContext context) {
    final Size size = MediaQuery.sizeOf(context);
    return Container(
      height: size.height * 30/852,
      padding:  EdgeInsets.symmetric(horizontal: size.width * 10/393, vertical: size.height * 4/852),
      decoration: BoxDecoration(
        color: backgroundColor,
        borderRadius: BorderRadius.circular(8),
      ),
      child: Wrap(
        children: [Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text(
              label,
              style: Palette.lightModeAppTheme.textTheme.bodyMedium?.copyWith(
                color: labelColor,
              ),
            ),
            (size.width * 4/393).ph,
            const Icon(Icons.close_rounded, size: 16, color: Palette.whiteColor,),
          ],
        )],
      ),
    );
  }
}
