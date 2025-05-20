import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:medifirst/core/theming/palette.dart';
import 'package:medifirst/core/theming/spaces.dart';

class IconActionButtonContainer extends StatelessWidget {
  final String title;
  final String svgURL;
  final double width;
  final Color? backGroundColor;
  final Color? titleColor;
  const IconActionButtonContainer({required this.title, required this.svgURL, this.width = 359, this.backGroundColor, this.titleColor, super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: width,
      height: 51,
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 16),
      decoration: BoxDecoration(
        color: backGroundColor ?? Palette.mainGreen,
        borderRadius: BorderRadius.circular(10),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.max,
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          SvgPicture.asset(svgURL, height: 24, width: 24),
          9.pv,
          Text(
            title,
            style: Palette.lightModeAppTheme.textTheme.titleSmall?.copyWith(
              color: titleColor ?? Palette.whiteColor,
              fontSize: 16,
            ),
          ),
        ],
      ),
    );
  }
}
