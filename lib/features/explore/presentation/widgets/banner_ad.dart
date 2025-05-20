import 'package:flutter/material.dart';
import 'package:medifirst/core/theming/spaces.dart';

import '../../../../core/theming/palette.dart';

class BannerAd extends StatelessWidget {
  const BannerAd({super.key});

  @override
  Widget build(BuildContext context) {
    final Size size = MediaQuery.sizeOf(context);
    return Container(
      width: double.infinity,
      height: size.height * 119/852,
      padding: EdgeInsets.symmetric(horizontal: size.width * 15/393),
      decoration: const BoxDecoration(
        color: Palette.mainGreen,
        // borderRadius: BorderRadius.circular(10),
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.end,
        children: [
          Padding(
            padding: EdgeInsets.symmetric(vertical: size.height * 25/852),
            child: SizedBox(
              width: size.width * 168/393,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Looking for a Specialist Doctor?',
                    style: Palette.lightModeAppTheme.textTheme.titleMedium
                        ?.copyWith(
                            fontSize: 16,
                            color: Palette.whiteColor,
                            height: 0,
                            letterSpacing: -0.4),
                  ),
                  (size.height * 13/852).pv,
                  Text(
                    'Expertise and Care, Right at Your Fingertips',
                    style: Palette.lightModeAppTheme.textTheme.titleSmall
                        ?.copyWith(
                            fontSize: 8,
                            color: Palette.whiteColor,
                            letterSpacing: -0.4),
                  ),
                ],
              ),
            ),
          ),
          (size.width * 9/393).ph,
          SizedBox(
            height: size.height * 105/852,
            width: size.width * 154/393,
            child: FittedBox(
              child: Image.asset(
                'assets/icons/explore/doctors.png',
                fit: BoxFit.contain,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
