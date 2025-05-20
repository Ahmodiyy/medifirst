import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:medifirst/core/theming/palette.dart';
import 'package:medifirst/core/widgets/elements/section_container.dart';

class SettingButtonTile extends StatelessWidget {
  final String label;
  final String svg;
  final Color color;
  const SettingButtonTile({super.key, required this.label, this.svg = 'assets/icons/svgs/chevron_left.svg', this.color = Palette.blackColor});

  @override
  Widget build(BuildContext context) {
    final Size size = MediaQuery.sizeOf(context);
    return SectionContainer(
      height: size.height * 48/852,
      child: Padding(
        padding: EdgeInsets.symmetric(horizontal: size.width * 16/393,),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Text(label, style: Palette.lightModeAppTheme.textTheme.bodySmall?.copyWith(
              fontSize: 12,
              color: color,
              height: 0.14,
            ),),
            Flexible(child: Container()),
            SvgPicture.asset(svg, width: 24, height: 24,),
          ],
        ),
      ),
    );
  }
}
