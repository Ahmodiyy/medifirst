import 'package:flutter/material.dart';
import 'package:medifirst/core/theming/palette.dart';

class SectionContainer extends StatelessWidget {
  final double height;
  final Widget child;
  final Color? backgroundColor;

  const SectionContainer(
      {required this.height,
      required this.child,
      this.backgroundColor,
      super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      // width: 361,
      height: height,
      width: double.infinity,
      decoration: BoxDecoration(
        color: backgroundColor ?? Palette.whiteColor,
        // borderRadius: BorderRadius.circular(10),
      ),
      alignment: Alignment.center,
      child: child,
    );
  }
}
