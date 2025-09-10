import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:medifirst/core/theming/palette.dart';
import 'package:medifirst/core/widgets/elements/error_text.dart';
import 'package:medifirst/core/widgets/elements/loader.dart';
import 'package:medifirst/features/auth/controller/auth_controller.dart';

import '../../../explore/controller/explore_controller.dart';
import '../../../explore/presentation/widgets/appointment_bar.dart';

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
      body: _buildAppointmentsList(ref, user?.uid ?? ''),
    );
  }

  Widget _buildAppointmentsList(WidgetRef ref, String uid) {
    return ref.watch(nextAppointmentsProvider(uid)).when(
          data: (appointments) {
            if (appointments.isEmpty) {
              return const Center(child: Text('No appointments scheduled'));
            }
            return ListView.builder(
              scrollDirection: Axis.vertical,
              itemCount: appointments.length,
              itemBuilder: (context, index) {
                final appointment = appointments[index];
                return AppointmentBar(appointment: appointment);
              },
            );
          },
          error: (err, st) {
            print('$err $st');
            return const ErrorText(error: 'No appointments scheduled');
          },
          loading: () => const Loader(),
        );
  }
}
