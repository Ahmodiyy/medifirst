import 'dart:convert';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:medifirst/core/constants/constants.dart';
import 'package:medifirst/core/theming/palette.dart';
import 'package:medifirst/core/theming/spaces.dart';
import 'package:medifirst/core/widgets/elements/action_button_container.dart';
import 'package:medifirst/features/auth/presentation/screens/login_screen.dart';
import 'package:medifirst/features/auth/presentation/screens/select_category_screen.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../../../../doctor_app/features/home/presentation/doctor_home_screen.dart';
import '../../../../firebase_options.dart';
import '../../../home/presentation/screens/home_screen.dart';

class WelcomeScreen extends StatelessWidget {
  const WelcomeScreen({super.key});

  void navigateToSignUp(BuildContext context) {
    Navigator.push(
        context,
        MaterialPageRoute(
            builder: (context) => const SelectCategoryScreen(
                  isNewUser: true,
                )));
  }

  Future<void> navigateToLogin(BuildContext context) async {
    Navigator.push(
        context,
        MaterialPageRoute(
            builder: (context) => const SelectCategoryScreen(
              isNewUser: false,
            )));
  }

  @override
  Widget build(BuildContext context) {
    final Size size = MediaQuery.sizeOf(context);
    return Scaffold(
      body: Container(
        width: double.infinity,
        height: double.infinity,
        padding: EdgeInsets.all(size.width * 16 / 393)
            .copyWith(bottom: size.height * 76 / 852),
        decoration: const BoxDecoration(
          image: DecorationImage(
            image: AssetImage('assets/images/welcome_bg.png'),
            fit: BoxFit.cover,
            alignment: Alignment.center,
          ),
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            (size.height * 219 / 852).pv,
            Align(
              alignment: Alignment.centerLeft,
              child: SizedBox(
                width: size.width * 250 / 393,
                child: RichText(
                  text: TextSpan(
                      text: 'Welcome to Medi',
                      style: Palette.lightModeAppTheme.textTheme.titleMedium
                          ?.copyWith(
                        fontSize: 36,
                        color: Palette.whiteColor,
                      ),
                      children: [
                        TextSpan(
                            text: 'First',
                            style: Palette
                                .lightModeAppTheme.textTheme.titleMedium
                                ?.copyWith(
                              fontSize: 36,
                              color: Palette.redTextColor,
                            ))
                      ]),
                ),
              ),
            ),
            (size.height * 16 / 852).pv,
            Align(
              alignment: Alignment.centerLeft,
              child: Text(
                '"Your Health Our Priority"',
                style: Palette.lightModeAppTheme.textTheme.titleSmall?.copyWith(
                  fontSize: 20,
                  height: 0.08,
                  color: Palette.whiteColor,
                ),
              ),
            ),
            Flexible(child: Container()),
            InkWell(
              onTap: () => navigateToSignUp(context),
              child: const ActionButtonContainer(title: 'Get Started'),
            ),
            (size.height * 16 / 852).pv,
            InkWell(
              onTap: () async {
                  await navigateToLogin(context);
              },
              child: Container(
                height: size.height * 50 / 852,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(10),
                  border: Border.all(color: Palette.whiteColor, width: 2),
                ),
                child: Center(
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text(
                        'Already have an account? ',
                        style: Palette.lightModeAppTheme.textTheme.titleSmall
                            ?.copyWith(
                          fontSize: 14,
                          height: 0,
                          color: Palette.whiteColor,
                        ),
                      ),
                      Text(
                        'Log In',
                        style: Palette.lightModeAppTheme.textTheme.titleSmall
                            ?.copyWith(
                          fontSize: 14,
                          height: 0,
                          color: Palette.whiteColor,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
