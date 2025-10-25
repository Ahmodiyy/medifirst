import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:medifirst/core/theming/palette.dart';
import 'package:medifirst/core/theming/spaces.dart';
import 'package:medifirst/core/widgets/elements/action_button_container.dart';

class ActionSuccessModal extends StatefulWidget {
  const ActionSuccessModal({super.key});

  @override
  State<ActionSuccessModal> createState() => _ActionSuccessModalState();
}

class _ActionSuccessModalState extends State<ActionSuccessModal> {
  @override
  Widget build(BuildContext context) {
    final Size size = MediaQuery.sizeOf(context);
    return Container(
      height: size.height * 355 / 852,
      width: double.infinity,
      padding:
          EdgeInsets.only(bottom: MediaQuery.of(context).viewInsets.bottom),
      color: Palette.smallBodyGray,
      child: Container(
        width: double.infinity,
        padding: EdgeInsets.all(size.width * 18 / 393),
        decoration: const BoxDecoration(
          borderRadius: BorderRadius.only(
              topRight: Radius.circular(20), topLeft: Radius.circular(20)),
          color: Palette.whiteColor,
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          children: [
            (size.height * 46 / 852).pv,
            SvgPicture.asset('assets/icons/svgs/success.svg',
                height: 98, width: 98, fit: BoxFit.contain),
            (size.height * 16 / 852).pv,
            Text(
              'Congratulations',
              style: Palette.lightModeAppTheme.textTheme.titleMedium?.copyWith(
                fontSize: 20,
              ),
            ),
            (size.height * 8 / 852).pv,
            Text(
              "You're all set!",
              style: Palette.lightModeAppTheme.textTheme.bodySmall?.copyWith(
                fontSize: 14,
              ),
            ),
            Flexible(child: Container()),
            InkWell(
                onTap: () {
                  Navigator.pop(context);
                },
                child: const ActionButtonContainer(title: 'Continue')),
            (size.height * 8 / 852).pv,
          ],
        ),
      ),
    );
  }
}
