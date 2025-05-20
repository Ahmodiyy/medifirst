import 'package:flutter/material.dart';

class Card53Image extends StatelessWidget {
  final String imgUrl;
  final double? height;
  final double? width;
  final double radius;
  const Card53Image({required this.imgUrl, this.height,this.width, this.radius = 10, super.key});

  @override
  Widget build(BuildContext context) {
    final Size size = MediaQuery.sizeOf(context);
    return Container(
      height: height ?? (size.height * 53/852),
      width: width ?? (size.width * 53/852),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(radius),
        image: DecorationImage(
          image: NetworkImage(imgUrl),
          fit: BoxFit.fill,
        ),
      ),
    );
  }
}
