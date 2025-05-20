import 'package:flutter/material.dart';
import 'package:medifirst/core/theming/palette.dart';

class OutlineButton extends StatelessWidget {
  final Widget icon;
  final String label;
  final Color? color;
  const OutlineButton({required this.icon, required this.label, this.color, super.key});

  @override
  Widget build(BuildContext context) {
    final Size size = MediaQuery.sizeOf(context);
    return Container(
      height: (size.height * 51/852),
      width: size.width,
      decoration: BoxDecoration(
        color: color ?? Colors.white,
        border: Border.all(
          color: Palette.hintTextGray,
          width: 1.0,
        ),
        borderRadius: const BorderRadius.all(Radius.circular(10)),
      ),
      child: Center(
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            icon,
            SizedBox(
              width: size.width * 10/393,
            ),
            Text(
              label,
              style: Palette.lightModeAppTheme.textTheme.bodyMedium?.copyWith(
                fontSize: 16,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
