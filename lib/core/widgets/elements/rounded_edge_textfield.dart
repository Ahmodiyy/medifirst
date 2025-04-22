import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:medifirst/core/theming/palette.dart';

class RoundedEdgeTextField extends StatefulWidget {
  final TextEditingController controller;
  final String prefixIcon;
  final String hint;
  final bool isReadOnly;
  final Function(String)? onSubmitted;
  const RoundedEdgeTextField({required this.controller, required this.prefixIcon, required this.hint, this.isReadOnly = false, super.key, this.onSubmitted});

  @override
  State<RoundedEdgeTextField> createState() => _RoundedEdgeTextFieldState();
}

class _RoundedEdgeTextFieldState extends State<RoundedEdgeTextField> {
  @override
  Widget build(BuildContext context) {
    final Size size = MediaQuery.sizeOf(context);
    return SizedBox(
      height: size.height * 48/852,
      child: TextField(
        controller: widget.controller,
        readOnly: widget.isReadOnly,
        onSubmitted: widget.onSubmitted,
        scrollPadding: EdgeInsets.zero,
        decoration: InputDecoration(
          hintText: widget.hint,
          hintStyle: Palette.lightModeAppTheme.textTheme.bodyMedium?.copyWith(
            fontSize: 12,
            color: Palette.highlightTextGray,
          ),
          filled: true,
          fillColor: Palette.whiteColor,
          enabledBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(50),
            borderSide: const BorderSide(color: Palette.dividerGray, width: 1,),
          ),
          focusedBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(50),
            borderSide: const BorderSide(color: Palette.blueText, width: 1,),
          ),
          prefixIcon: Padding(
            padding: EdgeInsets.symmetric(horizontal: size.width * 15/393),
            child: SvgPicture.asset(widget.prefixIcon, width: size.width * 24/393, height: size.width * 24/393,),
          ),
        ),
      ),
    );
  }
}
