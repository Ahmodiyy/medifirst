import 'package:flutter/material.dart';

import '../../../../core/theming/palette.dart';

class OutlineCategoryButton extends StatelessWidget {
  final String label;
  final bool selected;
  const OutlineCategoryButton({super.key, required this.label, required this.selected});

  @override
  Widget build(BuildContext context) {
    final Size size = MediaQuery.sizeOf(context);
    return Container(
      height: size.height * 51/852,
      width: size.width * 359/393,
      decoration: BoxDecoration(
        color: selected? Palette.mainGreen : null,
        border: Border.all(color: Palette.dividerGray, width: 1),
        borderRadius: BorderRadius.circular(10),
      ),
      child: Center(
        child: Text(
          label,
          style: Palette.lightModeAppTheme.textTheme.titleSmall?.copyWith(
            color: selected? Palette.whiteColor : Palette.mainGreen,
            fontSize: 16,
          ),
        ),
      ),
    );
  }
}
