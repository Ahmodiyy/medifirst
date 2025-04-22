import 'package:flutter/material.dart';
import 'package:medifirst/core/theming/palette.dart';

class UnderlinedTextField extends StatelessWidget {
  final TextEditingController controller;
  final String hint;
  final Widget? suffix;
  final Widget? prefix;
  final TextCapitalization cap;
  final TextInputType? textInputType;
  final bool obscured;
  final bool readOnly;
  final Function(String)? onSubmitted;

  const UnderlinedTextField({
    required this.controller,
    required this.hint,
    this.suffix,
    this.prefix,
    this.textInputType,
    this.cap = TextCapitalization.none,
    this.obscured = false,
    this.readOnly = false,
    this.onSubmitted,
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return TextField(
      controller: controller,
      textCapitalization: cap,
      obscureText: obscured,
      onSubmitted: onSubmitted,
      keyboardType: textInputType ?? TextInputType.text,
      decoration: InputDecoration(
        hintText: hint,
        prefix: prefix,
        hintStyle: Palette.lightModeAppTheme.textTheme.bodySmall?.copyWith(
          color: Palette.hintTextGray,
          fontSize: 16,
        ),
        enabledBorder: const UnderlineInputBorder(
          borderSide: BorderSide(color: Palette.hintTextGray, width: 1),
        ),
        focusedBorder: const UnderlineInputBorder(
          borderSide: BorderSide(color: Palette.mainGreen, width: 1),
        ),
        suffix: suffix,
      ),
    );
  }
}
