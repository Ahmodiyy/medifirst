import 'package:flutter/material.dart';
import 'package:medifirst/core/theming/palette.dart';

class MessageTextField extends StatefulWidget {
  final TextEditingController controller;
  final String hint;
  const MessageTextField({super.key, required this.controller, required this.hint});

  @override
  State<MessageTextField> createState() => _MessageTextFieldState();
}

class _MessageTextFieldState extends State<MessageTextField> {
  @override
  Widget build(BuildContext context) {
    return TextField(
      controller: widget.controller,
      style: Palette.lightModeAppTheme.textTheme.bodySmall?.copyWith(
        fontSize: 14,
        letterSpacing: -0.4,
        color: Palette.blackColor,
      ),
      decoration: InputDecoration(
        filled: true,
        fillColor: Palette.messageFieldGray,
        hintStyle: Palette.lightModeAppTheme.textTheme.bodySmall?.copyWith(
          fontSize: 14,
          letterSpacing: -0.4,
          color: Palette.messageHintText,
        ),
        hintText: widget.hint,
        enabledBorder: OutlineInputBorder(
          borderSide: const BorderSide(color: Palette.dividerGray, width: 1,),
          borderRadius: BorderRadius.circular(50),
        ),
        focusedBorder: OutlineInputBorder(
          borderSide: const BorderSide(color: Palette.mainGreen, width: 1,),
          borderRadius: BorderRadius.circular(50),
        ),
      ),
    );
  }
}
