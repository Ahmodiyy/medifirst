import 'package:flutter/material.dart';
import 'package:medifirst/core/theming/palette.dart';
import 'package:medifirst/core/theming/spaces.dart';

import '../../../../core/widgets/elements/action_button_container.dart';

class ErrorModal extends StatefulWidget {
  final String message;

  const ErrorModal({super.key, required this.message});

  @override
  State<ErrorModal> createState() => _ErrorModalState();
}

class _ErrorModalState extends State<ErrorModal> {
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
            Container(
              width: size.width * 98 / 393,
              height: size.width * 98 / 393,
              decoration: const ShapeDecoration(
                shape: OvalBorder(),
                color: Palette.redTextColor,
              ),
              child: Center(
                child: Icon(
                  Icons.close_rounded,
                  size: size.width * 98 / 393,
                  color: Palette.whiteColor,
                ),
              ),
            ),
            (size.height * 20 / 852).pv,
            Text(
              'An error occurred',
              style: Palette.lightModeAppTheme.textTheme.titleMedium
                  ?.copyWith(fontSize: 20),
            ),
            (size.height * 25 / 852).pv,
            Flexible(
              child: Text(
                widget.message,
                textAlign: TextAlign.center,
                style: Palette.lightModeAppTheme.textTheme.bodySmall
                    ?.copyWith(fontSize: 14),
              ),
            ),
            Flexible(child: Container()),
            InkWell(
              onTap: () {
                Navigator.pop(context);
              },
              child: const ActionButtonContainer(title: 'Retry'),
            ),
          ],
        ),
      ),
    );
  }
}
