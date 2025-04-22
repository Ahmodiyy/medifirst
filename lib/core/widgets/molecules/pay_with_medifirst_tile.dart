import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:medifirst/core/theming/spaces.dart';

import '../../theming/palette.dart';
import '../elements/section_container.dart';

class PayWithMedifirstTile extends StatelessWidget {
  const PayWithMedifirstTile({super.key});

  @override
  Widget build(BuildContext context) {
    final Size size = MediaQuery.sizeOf(context);
    return SectionContainer(
      height: size.height * 73 / 851,
      child: Padding(
        padding: EdgeInsets.symmetric(vertical: size.height*20/852, horizontal: size.width*16/393),
        child: Row(
          children: [
            Container(
              width: size.width * 32 / 393,
              height: size.width * 32 / 393,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                border: Border.all(color: Palette.dividerGray, width: 0.5),
              ),
              child: Image.asset(
                'assets/images/logo/medifirst_logo.png',
                width: size.width * 20 / 393,
                height: size.width * 20 / 393,
              ),
            ),
            (size.width * 8 / 393).ph,
            Column(
              children: [
                Text(
                  'Pay with MediFirst Wallet',
                  style: Palette.lightModeAppTheme.textTheme.bodyMedium?.copyWith(
                    fontSize: 14,
                  ),
                ),
                Container(
                  height: size.height * 15 / 852,
                  width: size.width * 46 / 393,
                  decoration: BoxDecoration(
                    color: Palette.highlightGreen,
                    borderRadius: BorderRadius.circular(2),
                  ),
                  child: Center(
                    child: Text(
                      'wallet',
                      style: Palette.lightModeAppTheme.textTheme.bodyMedium
                          ?.copyWith(
                        color: Palette.mainGreen,
                        fontSize: 12,
                      ),
                    ),
                  ),
                ),
              ],
            ),
            Flexible(child: Container()),
            Icon(Icons.arrow_forward_ios, size: size.width * 24/393, color: Palette.blackColor,),
          ],
        ),
      ),
    );
  }
}
