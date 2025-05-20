import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:medifirst/core/theming/palette.dart';
import 'package:medifirst/core/theming/spaces.dart';

class CommunicationTypeButton extends StatelessWidget {
  final String icon;
  final String label;
  final Color color;
  const CommunicationTypeButton({super.key, required this.icon, required this.label, required this.color});

  @override
  Widget build(BuildContext context) {
    final Size size = MediaQuery.sizeOf(context);
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        Container(
          height: size.width * 54/393,
          width: size.width * 54/393,
          decoration:
              BoxDecoration(shape: BoxShape.circle, color: color),
          child: Center(
            child: SvgPicture.asset(
              icon,
              width: size.width * 24/393,
              height: size.width * 24/393,
            ),
          ),
        ),
        (size.height * 8/852).pv,
        Text(label, style: Palette.lightModeAppTheme.textTheme.bodySmall?.copyWith(
          height: 0.15,
        ),),
      ],
    );
  }
}
