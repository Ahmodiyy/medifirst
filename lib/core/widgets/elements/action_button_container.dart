import 'package:flutter/material.dart';
import 'package:medifirst/core/theming/palette.dart';

class ActionButtonContainer extends StatelessWidget {
  final String title;
  final double? width;
  final Color? backGroundColor;
  final Color? titleColor;
  const ActionButtonContainer({required this.title, this.width, this.backGroundColor, this.titleColor, super.key});

  @override
  Widget build(BuildContext context) {
    final Size size = MediaQuery.sizeOf(context);
    return Container(
      width: double.infinity,
      height: (size.height * 51/852),
      padding: EdgeInsets.symmetric(horizontal: (size.width * 10/393), vertical: (size.height * 12/852)),
      decoration: BoxDecoration(
        color: backGroundColor ?? Palette.mainGreen,
        borderRadius: BorderRadius.circular(10),
      ),
      child: Center(
        child: Text(
          title,
          style: Palette.lightModeAppTheme.textTheme.titleSmall?.copyWith(
            color: titleColor ?? Palette.whiteColor,
            fontSize: 16,
            height: 0,
          ),
        ),
      ),
    );
  }
}
