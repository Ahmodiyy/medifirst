import 'package:flutter/material.dart';


class ErrorText extends StatelessWidget {
  final String error;
  const ErrorText({Key? key, required this.error}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final Size size = MediaQuery.sizeOf(context);
    return SizedBox(
      height: size.height * 47/852,
      width: size.width * 360/393,
      // decoration: BoxDecoration(
      //   color: Palette.otpGrey,
      //   borderRadius: BorderRadius.circular(5),
      //   border: Border.all(color: Palette.errorBorderGray, width: 0.5),
      // ),
      child: Center(
        child: Text(error),
      ),
    );
  }
}
