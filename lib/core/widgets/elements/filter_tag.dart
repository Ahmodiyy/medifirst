import 'package:flutter/material.dart';
import 'package:medifirst/core/theming/palette.dart';

class FilterTag extends StatelessWidget {
  final String label;
  final Color? backgroundColor;
  final Color? labelColor;
  const FilterTag(
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
        children: [Text(
          label,
          style: Palette.lightModeAppTheme.textTheme.bodyMedium?.copyWith(
            color: labelColor,
          ),
        ),]
      ),
    );
  }
}
