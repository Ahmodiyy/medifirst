import 'package:flutter/material.dart';
import 'package:medifirst/core/theming/palette.dart';
import 'package:medifirst/core/theming/spaces.dart';

class ExploreCategoryItem extends StatelessWidget {
  final String svg;
  final String title;
  final Color topColor;
  final Color bottomColor;
  const ExploreCategoryItem({required this.svg, required this.title, required this.topColor, required this.bottomColor, super.key});

  @override
  Widget build(BuildContext context){
    final Size size = MediaQuery.sizeOf(context);
    return Container(
      width: size.width * 85/393,
      height: size.height * 91/852,
      padding: EdgeInsets.symmetric(vertical: size.height * 16/852, horizontal: size.width * 10/393),
      decoration: ShapeDecoration(
        gradient: LinearGradient(
          begin: const Alignment(0.00, -1.00),
          end: const Alignment(0, 1),
          colors: [topColor, bottomColor],
        ),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
      ),
      child: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          mainAxisSize: MainAxisSize.min,
          children: [
            Image.asset(
              svg,
              width: 32,
              height: 32,
              fit: BoxFit.contain,
            ),
            (size.height * 5/852).pv,
            Text(
              title,
              style: Palette.lightModeAppTheme.textTheme.bodyMedium?.copyWith(
                color: Palette.whiteColor,
                fontSize: (title.length > 10)? 9 : 10,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
