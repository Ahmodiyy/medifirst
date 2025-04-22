import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:medifirst/core/theming/palette.dart';
import 'package:medifirst/core/theming/spaces.dart';

class AmountTextfield extends StatelessWidget {
  final TextEditingController controller;
  const AmountTextfield({super.key, required this.controller});

  @override
  Widget build(BuildContext context) {
    final Size size = MediaQuery.sizeOf(context);
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        SvgPicture.asset('assets/icons/svgs/mdi_naira.svg', width: size.width*15/393, height: size.height*15/393,),
        (size.width*5/393).ph,
        SizedBox(
          // width: size.width*116/393,
          width: size.width*200/393,
          child: TextField(
            controller: controller,
            keyboardType: TextInputType.number,
            style: Palette.lightModeAppTheme.textTheme.bodyMedium?.copyWith(
              fontSize: 16,
            ),
            decoration: const InputDecoration(
              enabledBorder: UnderlineInputBorder(
                borderSide: BorderSide(color: Palette.avatarGray),
              ),
              focusedBorder: UnderlineInputBorder(
                borderSide: BorderSide(color: Palette.mainGreen),
              ),
            ),
          ),
        )
      ],
    );
  }
}
