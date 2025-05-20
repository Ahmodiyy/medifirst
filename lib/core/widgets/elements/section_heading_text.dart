import 'package:flutter/material.dart';

import '../../theming/palette.dart';

class SectionHeadingText extends StatelessWidget {
  final String heading;
  const SectionHeadingText({super.key, required this.heading});

  @override
  Widget build(BuildContext context) {
    return Text(
      heading,
      style:
      Palette.lightModeAppTheme.textTheme.titleMedium?.copyWith(
        fontSize: 10,
        color: Palette.highlightTextGray,
      ),
    );
  }
}
