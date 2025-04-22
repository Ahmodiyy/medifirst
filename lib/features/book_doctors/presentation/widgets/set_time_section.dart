import 'package:flutter/material.dart';
import 'package:medifirst/core/theming/palette.dart';
import 'package:medifirst/core/widgets/elements/section_container.dart';

class SetTimeSection extends StatefulWidget {
  final String label;
  final double height;
  final Widget child;
  const SetTimeSection({super.key, required this.label, required this.child, this.height = 48});

  @override
  State<SetTimeSection> createState() => _SetTimeSectionState();
}

class _SetTimeSectionState extends State<SetTimeSection> {
  @override
  Widget build(BuildContext context) {
    final Size size = MediaQuery.sizeOf(context);
    return SectionContainer(
      height: size.height * widget.height / 852,
      child: Padding(
        padding: EdgeInsets.symmetric(
            horizontal: size.width * 24 / 393,
            vertical: size.height * 12 / 852),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Flexible(
              child: Text(
                widget.label,
                maxLines: 2,
                overflow: TextOverflow.ellipsis,
                style: Palette.lightModeAppTheme.textTheme.bodySmall?.copyWith(
                  color: Palette.highlightTextGray,
                  // height: 0.15,
                  fontSize: 12,
                ),
              ),
            ),
            Flexible(child: widget.child),
          ],
        ),
      ),
    );
  }
}
