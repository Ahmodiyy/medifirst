import 'package:flutter/material.dart';
import 'package:medifirst/core/theming/palette.dart';

class ItemTag extends StatelessWidget {
  final String tag;
  const ItemTag({super.key, required this.tag});

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 25,
      padding: const EdgeInsets.symmetric(vertical: 8, horizontal: 10),
      decoration: BoxDecoration(
        color: Palette.mainGreen,
        borderRadius: BorderRadius.circular(4),
      ),
      child: Text(
        tag,
        style: Palette.lightModeAppTheme.textTheme.bodySmall
            ?.copyWith(color: Palette.whiteColor, fontSize: 12, height: 0.14),
      ),
    );
  }
}
