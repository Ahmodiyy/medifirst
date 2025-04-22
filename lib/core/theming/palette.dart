import 'package:flutter/material.dart';

class Palette {
  static const Color mainGreen = Color(0xFF40724E);
  static const Color blackColor = Color(0xFF3E3E3E);
  static const Color discountGreen = Color(0xFF699E6B);
  static const Color highlightGreen = Color(0xFFBBFFCE);
  static const Color categoryGreen = Color(0x1940724E);
  static const Color categoryHighlightGreen = Color(0xFFD3FFE0);
  static const Color backGroundColor = Color(0xFFE7F0E9);
  static const Color chatBackgroundColor = Color(0xFFF6F6F6);
  static const Color dividerGray = Color(0xFFDADADA);
  static const Color hintTextGray = Color(0xFFAFAFAF);
  static const Color messageFieldGray = Color(0xFFF5F5F5);
  static const Color messageHintText = Color(0xFF757575);
  static const Color smallBodyGray = Color(0xFF565656);
  static const Color containerBgGray = Color(0xFFF3F3F3);
  static const Color grayBgContrastButtonGray = Color(0xFFEEEEEE);
  static const Color errorBorderGray = Color(0xFFAFAFAF);
  static const Color iconDarkGrey = Color(0xFF767676);
  static const Color otpGrey = Color(0xFFEFEFEF);
  static const Color whiteColor = Colors.white;
  static const Color highlightTextGray = Color(0xFF909090);
  static const Color avatarGray = Color(0xFFD9D9D9);
  static const Color categoryPink = Color(0xFFFBE2E3);
  static const Color boldRedText = Color(0xFFB20014);
  static const Color redTextColor = Color(0xFFFC4B53);
  static const Color logoutRed = Color(0xFFFF4955);
  static const Color noRed = Color(0xFFB83C3C);
  static const Color ratingYellow = Color(0xFFDEB114);
  static const Color tipBackgroundYellow = Color(0xFFFFF8EB);
  static const Color prescriptionInfoYellow = Color(0xFFFFF6D7);
  static const Color ratingGray = Color(0xFFD9D9D9);
  static const Color faintGreen = Color(0xFF699E6B);
  static const Color buttonOffWhite = Color(0xFFF2F0F0);
  static const Color validationGreen = Color(0xFF4CAF50);
  static const Color blueText = Color(0xFF2790C3);
  static const Color orderProcessingBlueBg = Color(0xFFD5ECFF);
  static const Color orderProcessingBlueText = Color(0xFF1B75BB);
  static const Color orderDeliveredGreenBg = Color(0xFFEEFFDA);
  static const Color orderDeliveredGreenText = Color(0xFF34A853);
  static const Color orderCancelledRedBg = Color(0xFFFFDDDD);
  static const Color orderCancelledRedText = Color(0xFFC23838);
  static const Color consultationGreen = Color(0xFF25AF2A);
  static const Color consultationDarkGreen = Color(0xFF1B781F);
  static const Color medicineBlue = Color(0xFF0085C5);
  static const Color medicineDarkBlue = Color(0xFF04557D);
  static const Color emergencyRed = Color(0xFFE6444B);
  static const Color emergencyDarkRed = Color(0xFF9B2C31);
  static const Color healthcarePurple = Color(0xFF6E00FF);
  static const Color healthcareDarkPurple = Color(0xFF5003B4);

  static var lightModeAppTheme = ThemeData.light().copyWith(
    scaffoldBackgroundColor: backGroundColor,
    dividerColor: dividerGray,
    iconTheme: const IconThemeData(
      color: blackColor,
    ),
    appBarTheme: const AppBarTheme(
      backgroundColor: whiteColor,
      iconTheme: IconThemeData(
        color: blackColor,
      ),
    ),
    textTheme: const TextTheme(
      bodyLarge: TextStyle(
        color: blackColor,
        fontFamily: 'Inter',
        fontWeight: FontWeight.w600,
        fontSize: 24,
      ),
      bodyMedium: TextStyle(
        color: blackColor,
        fontFamily: 'Inter',
        fontWeight: FontWeight.w500,
        fontSize: 12,
      ),
      bodySmall: TextStyle(
        color: blackColor,
        fontFamily: 'Inter',
        fontWeight: FontWeight.w400,
        fontSize: 10,
      ),
      titleLarge: TextStyle(
        color: blackColor,
        fontFamily: 'Inter',
        fontWeight: FontWeight.w700,
        fontSize: 24,
      ),
      titleMedium: TextStyle(
        color: blackColor,
        fontFamily: 'Inter',
        fontWeight: FontWeight.w600,
        fontSize: 20,
      ),
      titleSmall: TextStyle(
        color: blackColor,
        fontFamily: 'Inter',
        fontWeight: FontWeight.w500,
        fontSize: 14,
      ),
    ),
    // drawerTheme: const DrawerThemeData(
    //   backgroundColor: whiteColor,
    // ),
    primaryColor: mainGreen,
    // colorScheme: const ColorScheme(
    //   brightness: Brightness.light,
    //   primary: Palette.offWhiteColor,
    //   onPrimary: Palette.blackColor,
    //   secondary: whiteColor,
    //   onSecondary: Palette.black1000,
    //   error: Palette.redColor,
    //   onError: Palette.whiteColor,
    //   background: Palette.whiteColor,
    //   onBackground: Palette.blackColor,
    //   surface: Palette.whiteColor,
    //   onSurface: Palette.darkGreyColor,
    //   tertiary: Palette.whiteColor,
    // ),
  );
}
