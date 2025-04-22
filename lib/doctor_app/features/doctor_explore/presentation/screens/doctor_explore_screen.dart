import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:medifirst/core/theming/spaces.dart';
import 'package:medifirst/core/theming/palette.dart';
import 'package:medifirst/core/widgets/molecules/appoint_request_bar.dart';
import 'package:medifirst/core/widgets/atoms/top_rated_doctor_bar.dart';
import 'package:medifirst/core/widgets/elements/error_text.dart';
import 'package:medifirst/core/widgets/elements/loader.dart';
import 'package:medifirst/core/widgets/molecules/error_modal.dart';
import 'package:medifirst/doctor_app/features/appointment_list/controller/appointment_list_controller.dart';
import 'package:medifirst/doctor_app/features/appointment_list/presentation/screens/appointment_list_screen.dart';
import 'package:medifirst/doctor_app/features/doctor_calls/presentation/screens/doctor_chat_page.dart';
import 'package:medifirst/doctor_app/features/doctor_calls/presentation/screens/doctor_video_call_screen.dart';
import 'package:medifirst/doctor_app/features/doctor_calls/presentation/screens/doctor_voice_call_screen.dart';
import 'package:medifirst/doctor_app/features/doctor_explore/presentation/widgets/expandable_section_heading.dart';
import 'package:medifirst/features/auth/controller/auth_controller.dart';
import 'package:medifirst/features/explore/controller/explore_controller.dart';
import 'package:medifirst/features/explore/presentation/widgets/appointment_bar.dart';
import 'package:flutter_chat_types/flutter_chat_types.dart' as types;
import 'package:zego_uikit_prebuilt_call/zego_uikit_prebuilt_call.dart';
import 'package:zego_uikit_signaling_plugin/zego_uikit_signaling_plugin.dart';
import '../../../../../core/constants/secret.dart';
import '../../../../../core/widgets/elements/section_heading_text.dart';
import '../widgets/doctor_explore_app_bar.dart';

class DoctorExploreScreen extends ConsumerStatefulWidget {
  const DoctorExploreScreen({Key? key}) : super(key: key);

  @override
  ConsumerState<DoctorExploreScreen> createState() => _DoctorExploreScreenState();
}

class _DoctorExploreScreenState extends ConsumerState<DoctorExploreScreen> {
  Future<void> initZegoCall()async {
    await ZegoUIKitPrebuiltCallInvitationService().init(
      appID: Secret.zegoCloudAppId, // Fill in the appID that you get from ZEGOCLOUD Admin Console.
      appSign: Secret.zegoCloudAppSign, // Fill in the appSign that you get from ZEGOCLOUD Admin Console.
      userID: ref.read(doctorProvider)?.doctorId ?? 'Guest',
      userName: ref.read(doctorProvider)?.name ?? 'Guest',
      plugins: [ZegoUIKitSignalingPlugin()],
    );
  }
  @override
  void initState() {
    super.initState();
    initZegoCall();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _checkDoctorLogin();
    });
  }

  void _checkDoctorLogin() {
    Future.delayed(const Duration(seconds: 1), () {
      if (mounted) {
        final doctor = ref.read(doctorProvider);
        if (doctor == null) {
          showModalBottomSheet(
            context: context,
            builder: (context) => const ErrorModal(
              message: 'Please close the app and sign into the correct category',
            ),
          );
        }
      }
    });
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
                    padding: EdgeInsets.symmetric(horizontal: size.width * 16 / 393),
                    child: DoctorExploreAppBar(name: doctor.name, profilePic: doctor.doctorImage),
                  ),
                  SizedBox(height: size.height * 24 / 852),
                  Padding(
                    padding: EdgeInsets.symmetric(horizontal: size.width * 16 / 393),
                    child: const ExpandableSectionHeading(heading: 'APPOINTMENTS', screen: null,),
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
                    padding: EdgeInsets.symmetric(horizontal: size.width * 16 / 393),
                    child: const ExpandableSectionHeading(heading: 'REQUESTS', screen:  AppointmentListScreen(),),
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
                    padding: EdgeInsets.symmetric(horizontal: size.width * 16 / 393),
                    child: const SectionHeadingText(heading: "TOP RATED DOCTORS"),
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
        child: ref.watch(nextAppointmentsProvider(doctorId)).when(
          data: (appointments) {
            return ListView.builder(
              scrollDirection: Axis.horizontal,
              itemCount: appointments.length.clamp(0, 2),
              itemBuilder: (context, index) {
                final appointment = appointments[index];
                return InkWell(
                  onTap: () => _handleAppointmentTap(appointment),
                  child: AppointmentBar(appointment: appointment),
                );
              },
            );
          },
          error: (error, stackTrace) => const ErrorText(error: 'No appointments upcoming'),
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
            MaterialPageRoute(builder: (context) => DoctorVideoCallScreen(appt: appointment)),
          );
          break;
        case 2:
          Navigator.push(
            context,
            MaterialPageRoute(builder: (context) => DoctorVoiceCallScreen(appt: appointment)),
          );
          break;
        default:
          final room = types.Room(
            id: appointment.aID,
            type: types.RoomType.direct,
            users: [
              types.User(id: appointment.doctorId, firstName: appointment.doctorName),
              types.User(id: appointment.patientId, firstName: appointment.patientName),
            ],
          );
          Navigator.push(
            context,
            MaterialPageRoute(builder: (context) => DoctorChatPage(appt: appointment)),
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
          error: (err, stack) => const ErrorText(error: 'No appointment requests'),
          loading: () => const Loader(),
        ),
      ),
    );
  }

  Widget _buildTopRatedDoctors(Size size) {
    return SliverToBoxAdapter(
      child: SizedBox(
        height: size.height * (852 * 0.5),
        child: ref.watch(topRatedDoctorsProvider).when(
          data: (doctors) {
            return ListView.builder(
              itemCount: doctors.length.clamp(0, 4),
              itemBuilder: (context, index) {
                return TopRatedDoctorBar(doctor: doctors[index]);
              },
            );
          },
          error: (error, stackTrace) => const ErrorText(error: 'An error occurred'),
          loading: () => const Loader(),
        ),
      ),
    );
  }
}
