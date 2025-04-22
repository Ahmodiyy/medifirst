import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:medifirst/core/theming/palette.dart';
import 'package:medifirst/core/theming/spaces.dart';
import 'package:medifirst/models/message_info.dart';

class SentChatBox extends StatelessWidget {
  final MessageInfo message;
  const SentChatBox({super.key, required this.message});

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        Container(
          padding: const EdgeInsets.symmetric(vertical: 18, horizontal: 15),
          decoration: const BoxDecoration(
            color: Palette.mainGreen,
            borderRadius: BorderRadius.only(
                topLeft: Radius.circular(20),
                topRight: Radius.circular(20),
                bottomLeft: Radius.circular(20),
                bottomRight: Radius.zero),
          ),
          child: Container(
            constraints: const BoxConstraints(
              maxWidth: 184,
              minWidth: 27,
            ),
            child: Text(
              message.message,
              style: Palette.lightModeAppTheme.textTheme.titleMedium?.copyWith(
                fontSize: 12,
                color: Palette.whiteColor,
              ),
            ),
          ),
        ),
        8.pv,
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
