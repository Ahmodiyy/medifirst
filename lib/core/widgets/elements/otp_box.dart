import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:medifirst/core/theming/palette.dart';

class OTPBox extends StatefulWidget {
  final TextEditingController controller;
  final FocusNode nextFocusNode;
  final FocusNode thisFocusNode;
  const OTPBox({required this.controller,
    required  this.nextFocusNode,
    required this.thisFocusNode, super.key});

  @override
  State<OTPBox> createState() => _OTPBoxState();
}

class _OTPBoxState extends State<OTPBox> {
  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 2),
      alignment: Alignment.center,
      child: SizedBox(
        height: 70,
        width: 60,
        child: TextFormField(
          textInputAction: TextInputAction.next,
          inputFormatters: [
            LengthLimitingTextInputFormatter(1),
            FilteringTextInputFormatter.digitsOnly
          ],
         keyboardType: TextInputType.number,
          controller: widget.controller,
          focusNode: widget.thisFocusNode,
          textAlign: TextAlign.center,
          onChanged: (value) {
           // if (widget.controller.text.length == 1) {
            if (value.length == 1) {
              //widget.nextFocusNode.requestFocus();
              FocusScope.of(context).nextFocus();
            }
          },
          style: Palette.lightModeAppTheme.textTheme.titleMedium,
          decoration: InputDecoration(
            filled: true,
            fillColor: Palette.otpGrey,
            border: OutlineInputBorder(
              borderSide: const BorderSide(
                  color: Palette.dividerGray, width: 1.0),
              borderRadius: BorderRadius.circular(15),
            ),
            focusedBorder: OutlineInputBorder(
              borderSide: const BorderSide(color: Palette.mainGreen, width: 0.8),
              borderRadius: BorderRadius.circular(15),
            ),
          ),
        ),
      ),
    );
  }
}
