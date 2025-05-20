import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:medifirst/core/theming/palette.dart';
import 'package:medifirst/core/theming/spaces.dart';
import 'package:medifirst/core/widgets/elements/error_text.dart';
import 'package:medifirst/core/widgets/elements/loader.dart';
import 'package:medifirst/features/auth/controller/auth_controller.dart';
import 'package:medifirst/features/notifications/controller/notification_controller.dart';
import 'package:medifirst/features/notifications/presentation/widgets/notification_bar.dart';

class NotificationScreen extends ConsumerStatefulWidget {
  const NotificationScreen({super.key});

  @override
  ConsumerState createState() => _NotificationScreenState();
}

class _NotificationScreenState extends ConsumerState<NotificationScreen> {
  @override
  Widget build(BuildContext context) {
    final Size size = MediaQuery.sizeOf(context);
    final user = ref.watch(userProvider);
    return Scaffold(
      backgroundColor: Palette.backGroundColor,
      appBar: AppBar(
        backgroundColor: Palette.whiteColor,
        centerTitle: true,
        automaticallyImplyLeading: false,
        title: Text(
          'Notifications',
          style: Palette.lightModeAppTheme.textTheme.bodySmall?.copyWith(
            fontSize: 20,
          ),
        ),
      ),
      body: SizedBox(
        height: size.height * 707 / 852,
        child: ref.watch(getNotificationsProvider(user!.uid)).when(
              data: (notifications) {
                return ListView.builder(itemCount: notifications.isEmpty? 0:notifications.length,itemBuilder: (context, index) {
                  if (notifications.isEmpty) {
                    return const Center(
                      child: ErrorText(error: 'No notifications available'));
                  }
                  final notif = notifications[index];
                  return Column(
                    children: [
                      NotificationBar(notification: notif)
                          .sidePad(size.width * 16 / 393),
                      (size.height * 16 / 852).pv,
                      const Divider(
                        thickness: 1,
                        color: Palette.dividerGray,
                      ).alignRight().sidePad(size.width * 16 / 393),
                    ],
                  );
                });
              },
              error: (er, st) => const Center(
                  child: ErrorText(error: 'No notifications available')),
              loading: () => const Loader(),
            ),
      ),
    );
  }
}
