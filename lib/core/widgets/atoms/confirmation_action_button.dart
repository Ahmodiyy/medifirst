import 'package:flutter/material.dart';
import 'package:medifirst/core/theming/palette.dart';

class ConfirmationActionButton extends StatelessWidget {
  final bool yes;
  const ConfirmationActionButton({super.key, required this.yes});

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 45,
      width: 45,
      decoration: BoxDecoration(
        color: yes? Palette.faintGreen : Palette.noRed,
      ),
      child: Center(
        child: yes? const Icon(Icons.check, color: Palette.whiteColor, size: 20,) : const Icon(Icons.close, color: Palette.whiteColor, size: 20,),
      ),
    );
  }
}
