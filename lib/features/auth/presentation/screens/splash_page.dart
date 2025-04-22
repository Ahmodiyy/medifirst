import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:medifirst/core/theming/palette.dart';
import 'package:medifirst/core/theming/spaces.dart';
import 'package:medifirst/core/widgets/elements/logo_typeface.dart';

class SplashPage extends ConsumerStatefulWidget {
  const SplashPage({super.key,});

  @override
  _SplashState createState() => _SplashState();
}

class _SplashState extends ConsumerState<SplashPage> {
  int screen = 1;
  AssetImage currentImg = const AssetImage('assets/images/splash/logo.png');

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    precacheImage(currentImg, context);
  }


  @override
  Widget build(BuildContext context) {
    var t = Timer(const Duration(milliseconds: 500), () async {
      //TODO add routing, find a way of switching it from main file
    });
    return AnimatedSwitcher(
      duration: const Duration(milliseconds: 300),
      transitionBuilder: (Widget child, Animation<double> animation) {
        return FadeTransition(opacity: animation, child: child);
      },
      child: Scaffold(
        body: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            const SizedBox(
              height: 361,
            ),
            Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              mainAxisSize: MainAxisSize.min,
              children: [
                Image.asset(
                  'assets/images/logo/mf_temp.png',
                  height: 78,
                  width: 81,
                  fit: BoxFit.fill,
                ),
                8.pv,
                const LogoTypeface(),
              ],
            ),
            const SizedBox(
              height: 283,
            ),
            Text(
              'Your Health Our Priority',
              style: Palette.lightModeAppTheme.textTheme.bodySmall?.copyWith(
                color: Palette.redTextColor,
                fontSize: 14,
                fontFamily: 'Roboto',
                height: 0.10,
              ),
            ),
            24.pv,
          ],
        ),
      ),
    );
  }
}
