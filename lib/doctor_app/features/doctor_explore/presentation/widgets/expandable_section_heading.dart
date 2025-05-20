import 'package:flutter/material.dart';
import 'package:medifirst/core/theming/palette.dart';
import 'package:medifirst/core/widgets/elements/section_heading_text.dart';

import '../../../appointment_list/presentation/screens/appointment_list_screen.dart';

class ExpandableSectionHeading extends StatelessWidget {
  final String heading;
  final Widget? screen;
  const ExpandableSectionHeading({super.key, required this.heading,  this.screen});

  @override
  Widget build(BuildContext context) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.baseline,
      textBaseline: TextBaseline.alphabetic,
      children: [
        SectionHeadingText(heading: heading),
        Flexible(child: Container()),
        GestureDetector(
          onTap: () {
            if(screen!=null){
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) =>  screen!),
              );
            }

          },
          child: Text(
            'VIEW ALL',
            style: Palette.lightModeAppTheme.textTheme.titleMedium?.copyWith(
              color: Palette.blueText,
              fontSize: 10,
            ),
          ),
        ),
      ],
    );
  }
}
