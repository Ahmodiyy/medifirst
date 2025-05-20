import 'package:flutter/material.dart';

import '../../theming/palette.dart';

class LogoTypeface extends StatelessWidget {
  const LogoTypeface({super.key});

  @override
  Widget build(BuildContext context) {
    return Text.rich(
      TextSpan(
        children: [
          TextSpan(
            text: 'Medi',
            style: Palette.lightModeAppTheme.textTheme.titleMedium
                ?.copyWith(
              color: Palette.mainGreen,
              fontSize: 36,
              height: 0,
            ),
          ),
          TextSpan(
            text: 'First',
            style: Palette.lightModeAppTheme.textTheme.titleMedium
                ?.copyWith(
              color: Palette.redTextColor,
              fontSize: 36,
              height: 0,
            ),
          ),
        ],
      ),
    );
  }
}
