import 'package:flutter/material.dart';
import 'package:medifirst/core/theming/palette.dart';

class OutlineActionButton extends StatelessWidget {
  double? height;
  final String title;
  OutlineActionButton({super.key, this.height, required this.title});

  @override
  Widget build(BuildContext context) {
    final Size size = MediaQuery.sizeOf(context);
    return Container(
      width: double.infinity,
      height: height ?? size.height * 51 / 852,
      decoration: BoxDecoration(
        border: Border.all(
          color: Palette.mainGreen,
          width: 1,
        ),
        borderRadius: BorderRadius.circular(10),
      ),
      child: Center(
        child: Text(
          title,
          style: Palette.lightModeAppTheme.textTheme.bodyMedium?.copyWith(
            fontSize: 16,
            color: Palette.mainGreen,
          ),
        ),
      ),
    );
  }
}
