import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:medifirst/core/theming/palette.dart';
import 'package:medifirst/core/theming/spaces.dart';
import 'package:medifirst/models/message_info.dart';

class ReceivedChatBox extends StatelessWidget {
  final MessageInfo message;
  const ReceivedChatBox({super.key, required this.message});

  @override
  Widget build(BuildContext context) {
    final Size size = MediaQuery.sizeOf(context);
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        Container(
          padding: EdgeInsets.symmetric(vertical: size.height * 18/852, horizontal: size.width * 15/393),
          decoration: const BoxDecoration(
            color: Palette.whiteColor,
            borderRadius: BorderRadius.only(
                topLeft: Radius.circular(20),
                topRight: Radius.circular(20),
                bottomLeft: Radius.zero,
                bottomRight: Radius.circular(20)),
          ),
          child: Container(
            constraints: BoxConstraints(
              maxWidth: size.width * 184/393,
              minWidth: size.width * 27/393,
            ),
            child: Text(
              message.message,
              style: Palette.lightModeAppTheme.textTheme.titleMedium?.copyWith(
                fontSize: 12,
                color: Palette.blackColor,
              ),
            ),
          ),
        ),
        (size.height * 8/852).pv,
        Align(
          alignment: Alignment.centerLeft,
          child: Text(DateFormat.Hm().format(message.timeSent.toDate()), style: Palette.lightModeAppTheme.textTheme.bodyMedium?.copyWith(
            fontSize: 10,
            color: Palette.hintTextGray,
          ),),
        ),
      ],
    );
  }
}
