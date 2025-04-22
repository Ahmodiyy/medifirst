import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:medifirst/core/theming/palette.dart';

class CustomDropdownButton extends ConsumerStatefulWidget {
  final List<String> list;
  final TextEditingController controller;
  final double? height;
  final double? width;
  const CustomDropdownButton(
      {required this.list, required this.controller, this.height = 16, this.width = 61, super.key});

  @override
  ConsumerState<CustomDropdownButton> createState() => _CustomDropdownButtonState();
}

class _CustomDropdownButtonState extends ConsumerState<CustomDropdownButton> {
  @override
  Widget build(BuildContext context) {
    return Container(
      height: widget.height,
      width: widget.width,
      decoration: ShapeDecoration(
        color: Palette.faintGreen,
        shape: RoundedRectangleBorder(
          side: const BorderSide(color: Palette.dividerGray, width: 1.0),
          borderRadius: BorderRadius.circular(2),
        ),
      ),
      child: DropdownButton<String>(
          value: widget.controller.text,
          items: widget.list.map<DropdownMenuItem<String>>((e) {
            return DropdownMenuItem(
                child: Text(
              e,
              style: Palette.lightModeAppTheme.textTheme.bodySmall,
            ));
          }).toList(),
          onChanged: (String? newValue) {
            setState(() {
              widget.controller.text = newValue!;
            });
          }),
    );
  }
}
