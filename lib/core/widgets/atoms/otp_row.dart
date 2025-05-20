import 'package:flutter/material.dart';
import 'package:medifirst/core/widgets/elements/otp_box.dart';

class OTPRow extends StatelessWidget {
  final TextEditingController controller1;
  final TextEditingController controller2;
  final TextEditingController controller3;
  final TextEditingController controller4;
  final TextEditingController controller5;
  final TextEditingController controller6;
  final FocusNode focusNode1;
  final FocusNode focusNode2;
  final FocusNode focusNode3;
  final FocusNode focusNode4;
  final FocusNode focusNode5;
  final FocusNode focusNode6;
  const OTPRow({super.key,
    required this.controller1,
    required this.controller2,
    required this.controller3,
    required this.controller4,
    required this.controller5,
    required this.controller6,
    required this.focusNode1,
    required this.focusNode2,
    required this.focusNode3,
    required this.focusNode4,
    required this.focusNode5,
    required this.focusNode6,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Flexible(child: OTPBox(controller: controller1, thisFocusNode: focusNode1, nextFocusNode: focusNode2,)),
        Flexible(child: OTPBox(controller: controller2, thisFocusNode: focusNode2, nextFocusNode: focusNode3,)),
        Flexible(child: OTPBox(controller: controller3, thisFocusNode: focusNode3, nextFocusNode: focusNode4,)),
        Flexible(child: OTPBox(controller: controller4, thisFocusNode: focusNode4, nextFocusNode: focusNode5,)),
        Flexible(child: OTPBox(controller: controller5, thisFocusNode: focusNode5, nextFocusNode: focusNode6,)),
        Flexible(child: OTPBox(controller: controller6, thisFocusNode: focusNode6, nextFocusNode: focusNode6,)),
      ],
    );
  }


}
