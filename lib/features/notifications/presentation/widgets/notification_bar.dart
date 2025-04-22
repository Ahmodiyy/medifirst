import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:intl/intl.dart';
import 'package:medifirst/core/theming/palette.dart';
import 'package:medifirst/core/theming/spaces.dart';
import 'package:medifirst/models/notification_info.dart';

class NotificationBar extends StatelessWidget {
  final NotificationInfo notification;
  const NotificationBar({super.key, required this.notification,});

  @override
  Widget build(BuildContext context) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Container(
          height: 36.54,
          width: 36.54,
          decoration: const BoxDecoration(
            shape: BoxShape.circle,
            color: Palette.mainGreen,
          ),
          child: Center(
            child: SvgPicture.asset('', height: 20, width: 20,),
          ),
        ),
        14.ph,
        SizedBox(
          width: 246,
          child: Text(notification.message, style: Palette.lightModeAppTheme.textTheme.bodySmall?.copyWith(
            fontSize: 12
          ),),
        ),
        Flexible(child: Container(),),
        Column(
          crossAxisAlignment: CrossAxisAlignment.end,
          children: [
            Container(
              height: 9,
              width: 9,
              decoration: BoxDecoration(
                color: (notification.isUnread)? Palette.mainGreen: Palette.dividerGray,
                shape: BoxShape.circle,
              ),
            ),
            Flexible(child: Container()),
            Text(DateFormat.yMMMMd().format(notification.time.toDate()), style: Palette.lightModeAppTheme.textTheme.bodyMedium?.copyWith(
              fontSize: 8,
              color: Palette.hintTextGray,
            ),),
          ],
        )
      ],
    );
  }
}
