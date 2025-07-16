import 'package:flutter/material.dart';
import 'package:flutter_chat_types/flutter_chat_types.dart' as types;
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:intl/intl.dart';
import 'package:medifirst/core/theming/palette.dart';
import 'package:medifirst/core/theming/spaces.dart';
import 'package:medifirst/core/widgets/atoms/top_rated_doctor_bar.dart';
import 'package:medifirst/core/widgets/elements/error_text.dart';
import 'package:medifirst/core/widgets/elements/loader.dart';
import 'package:medifirst/core/widgets/molecules/appoint_request_bar.dart';
import 'package:medifirst/doctor_app/features/appointment_list/controller/appointment_list_controller.dart';
import 'package:medifirst/doctor_app/features/appointment_list/presentation/screens/appointment_list_screen.dart';
import 'package:medifirst/doctor_app/features/doctor_calls/presentation/screens/doctor_chat_page.dart';
import 'package:medifirst/doctor_app/features/doctor_calls/presentation/screens/doctor_video_call_screen.dart';
import 'package:medifirst/doctor_app/features/doctor_calls/presentation/screens/doctor_voice_call_screen.dart';
import 'package:medifirst/doctor_app/features/doctor_explore/presentation/widgets/expandable_section_heading.dart';
import 'package:medifirst/features/auth/controller/auth_controller.dart';
import 'package:medifirst/features/explore/controller/explore_controller.dart';
import 'package:zego_uikit_prebuilt_call/zego_uikit_prebuilt_call.dart';
import 'package:zego_uikit_signaling_plugin/zego_uikit_signaling_plugin.dart';

import '../../../../../core/widgets/elements/card_53_image.dart';
import '../../../../../core/widgets/elements/section_heading_text.dart';
import '../widgets/doctor_explore_app_bar.dart';

class DoctorExploreScreen extends ConsumerStatefulWidget {
  const DoctorExploreScreen({Key? key}) : super(key: key);

  @override
  ConsumerState<DoctorExploreScreen> createState() =>
      _DoctorExploreScreenState();
}

class _DoctorExploreScreenState extends ConsumerState<DoctorExploreScreen> {
  Future<void> initZegoCall() async {
    await ZegoUIKitPrebuiltCallInvitationService().init(
      appID: int.parse(
          const String.fromEnvironment('zegoCloudAppId', defaultValue: '1')),
      appSign:
          const String.fromEnvironment('zegoCloudAppSign', defaultValue: ''),
      userID: ref.read(doctorProvider)?.doctorId ?? 'Guest',
      userName: ref.read(doctorProvider)?.name ?? 'Guest',
      plugins: [ZegoUIKitSignalingPlugin()],
    );
  }

  @override
  void initState() {
    super.initState();
    initZegoCall();
  }

  @override
  Widget build(BuildContext context) {
    final Size size = MediaQuery.of(context).size;
    final doctor = ref.watch(doctorProvider);
    if (doctor == null) {
      return const Scaffold(
        body: Center(child: CircularProgressIndicator()),
      );
    }
    return Scaffold(
      backgroundColor: Palette.backGroundColor,
      body: SafeArea(
        child: CustomScrollView(
          slivers: [
            SliverToBoxAdapter(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  SizedBox(height: size.height * 23 / 852),
                  Padding(
                    padding:
                        EdgeInsets.symmetric(horizontal: size.width * 16 / 393),
                    child: DoctorExploreAppBar(
                        name: doctor.name, profilePic: doctor.doctorImage),
                  ),
                  SizedBox(height: size.height * 24 / 852),
                  Padding(
                    padding:
                        EdgeInsets.symmetric(horizontal: size.width * 16 / 393),
                    child: const ExpandableSectionHeading(
                      heading: 'APPOINTMENTS',
                      screen: AppointmentListScreen(),
                    ),
                  ),
                  SizedBox(height: size.height * 12 / 852),
                ],
              ),
            ),
            _buildAppointmentsList(doctor.doctorId, size),
            SliverToBoxAdapter(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  SizedBox(height: size.height * 24 / 852),
                  Padding(
                    padding:
                        EdgeInsets.symmetric(horizontal: size.width * 16 / 393),
                    child: const ExpandableSectionHeading(
                      heading: 'REQUESTS',
                      screen: AppointmentListScreen(),
                    ),
                  ),
                  SizedBox(height: size.height * 12 / 852),
                ],
              ),
            ),
            _buildAppointmentRequests(doctor.doctorId, size),
            SliverToBoxAdapter(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  SizedBox(height: size.height * 24 / 852),
                  Padding(
                    padding:
                        EdgeInsets.symmetric(horizontal: size.width * 16 / 393),
                    child:
                        const SectionHeadingText(heading: "TOP RATED DOCTORS"),
                  ),
                  SizedBox(height: size.height * 12 / 852),
                ],
              ),
            ),
            _buildTopRatedDoctors(size),
          ],
        ),
      ),
    );
  }

  Widget _buildAppointmentsList(String doctorId, Size size) {
    return SliverToBoxAdapter(
      child: SizedBox(
        height: size.height * 111 / 852,
        child: ref.watch(getDoctorAppointmentProvider(doctorId)).when(
              data: (appointments) {
                if (appointments.isNotEmpty) {
                  final request = appointments[appointments.length - 1];
                  return InkWell(
                    onTap: () => Navigator.push(
                      context,
                      MaterialPageRoute(
                          builder: (context) => const AppointmentListScreen()),
                    ),
                    child: Container(
                      color: Palette.whiteColor,
                      child: Padding(
                        padding: const EdgeInsets.all(20),
                        child: Row(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Center(
                              child: Padding(
                                padding: const EdgeInsets.only(right: 20),
                                child: Card53Image(
                                  imgUrl: request.patientImageURL,
                                  height: 50,
                                  width: 50,
                                ),
                              ),
                            ),
                            Expanded(
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                mainAxisAlignment: MainAxisAlignment.center,
                                mainAxisSize: MainAxisSize.max,
                                children: [
                                  Text(
                                    request.patientName,
                                    style: Palette
                                        .lightModeAppTheme.textTheme.titleSmall
                                        ?.copyWith(
                                      letterSpacing: -0.4,
                                    ),
                                  ),
                                  (size.height * 8 / 852).pv,
                                  RichText(
                                    text: TextSpan(
                                        text: DateFormat('dd/MM/yyyy')
                                            .format(request.startTime.toDate()),
                                        style: Palette.lightModeAppTheme
                                            .textTheme.bodySmall
                                            ?.copyWith(
                                          letterSpacing: -0.4,
                                          color: Palette.smallBodyGray,
                                        ),
                                        children: [
                                          TextSpan(
                                            text: '   ',
                                            style: Palette.lightModeAppTheme
                                                .textTheme.bodySmall
                                                ?.copyWith(
                                              letterSpacing: -0.4,
                                              color: Palette.smallBodyGray,
                                            ),
                                          ),
                                          TextSpan(
                                            text: DateFormat.jm().format(
                                                request.startTime.toDate()),
                                            style: Palette.lightModeAppTheme
                                                .textTheme.bodySmall
                                                ?.copyWith(
                                              letterSpacing: -0.4,
                                              color: Palette.smallBodyGray,
                                            ),
                                          )
                                        ]),
                                  ),
                                ],
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  );
                } else {
                  return const ErrorText(error: 'No appointment');
                }
              },
              error: (error, stackTrace) =>
                  const ErrorText(error: 'No appointments upcoming'),
              loading: () => const Loader(),
            ),
      ),
    );
  }

  void _handleAppointmentTap(dynamic appointment) {
    final now = DateTime.now();
    final start = appointment.startTime.toDate();
    final end = appointment.endTime.toDate();

    if (now.isAfter(start) && now.isBefore(end)) {
      switch (appointment.type) {
        case 1:
          Navigator.push(
            context,
            MaterialPageRoute(
                builder: (context) => DoctorVideoCallScreen(appt: appointment)),
          );
          break;
        case 2:
          Navigator.push(
            context,
            MaterialPageRoute(
                builder: (context) => DoctorVoiceCallScreen(appt: appointment)),
          );
          break;
        default:
          final room = types.Room(
            id: appointment.aID,
            type: types.RoomType.direct,
            users: [
              types.User(
                  id: appointment.doctorId, firstName: appointment.doctorName),
              types.User(
                  id: appointment.patientId,
                  firstName: appointment.patientName),
            ],
          );
          Navigator.push(
            context,
            MaterialPageRoute(
                builder: (context) => DoctorChatPage(appt: appointment)),
          );
      }
    }
  }

  Widget _buildAppointmentRequests(String doctorId, Size size) {
    return SliverToBoxAdapter(
      child: SizedBox(
        height: size.height * 111 / 852,
        child: ref.watch(getDoctorAppointmentRequestsProvider(doctorId)).when(
              data: (requests) {
                if (requests.isNotEmpty) {
                  return AppointmentRequestBar(request: requests[0]);
                } else {
                  return const ErrorText(error: 'No appointment requests');
                }
              },
              error: (err, stack) =>
                  const ErrorText(error: 'No appointment requests'),
              loading: () => const Loader(),
            ),
      ),
    );
  }

  Widget _buildTopRatedDoctors(Size size) {
    return SliverToBoxAdapter(
      child: SizedBox(
        height: size.height * (852 * 0.5) / 852,
        child: ref.watch(topRatedDoctorsProvider).when(
              data: (doctors) {
                return ListView.builder(
                  itemCount: doctors.length.clamp(0, 4),
                  itemBuilder: (context, index) {
                    return TopRatedDoctorBar(doctor: doctors[index]);
                  },
                );
              },
              error: (error, stackTrace) =>
                  const ErrorText(error: 'An error occurred'),
              loading: () => const Loader(),
            ),
      ),
    );
  }
}
