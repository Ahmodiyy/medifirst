import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:medifirst/core/theming/palette.dart';

class OopsDialog extends StatelessWidget {
  const OopsDialog({super.key});

  @override
  Widget build(BuildContext context) {
    final Size size = MediaQuery.sizeOf(context);
    return AlertDialog(
      backgroundColor: Palette.chatBackgroundColor,
      title: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          SvgPicture.asset(
            'assets/icons/svgs/rocket.svg',
            width: 24,
            height: 24,
          ),
          Text(
            ' Hello!',
            style: Palette.lightModeAppTheme.textTheme.titleSmall?.copyWith(
              fontSize: 20,
              height: 0,
              letterSpacing: -0.40,
            ),
          ),
        ],
      ),
      content: Text(
        'Get ready to experience the future of MediFirst like never before. Stay tuned for more updates, and be prepared to be amazed',
        textAlign: TextAlign.center,
        style: Palette.lightModeAppTheme.textTheme.titleSmall?.copyWith(
          color: Palette.messageHintText,
          fontSize: 10,
          height: 0,
          letterSpacing: -0.40,
        ),
      ),
    );
  }
}
