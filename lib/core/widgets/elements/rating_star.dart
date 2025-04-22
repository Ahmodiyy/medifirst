import 'package:flutter/material.dart';

class RatingStar extends StatelessWidget {
  final Color color;
  final double? starSize;
  const RatingStar({required this.color, this.starSize, super.key});

  @override
  Widget build(BuildContext context) {
    final Size size = MediaQuery.sizeOf(context);
    return Container(
      height: starSize ?? (size.height * 12/852),
      width: starSize ?? (size.height * 12/852),
      decoration: ShapeDecoration(
        color: color,
        shape: const StarBorder(
          points: 5,
          innerRadiusRatio: 0.38,
          pointRounding: 0.69,
        ),
      ),
    );
  }
}
