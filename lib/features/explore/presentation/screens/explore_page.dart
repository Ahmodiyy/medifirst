import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_svg/svg.dart';
import 'package:medifirst/core/theming/palette.dart';
import 'package:medifirst/core/widgets/atoms/drug_order_bar.dart';
import 'package:medifirst/core/widgets/atoms/medication_bar.dart';
import 'package:medifirst/core/widgets/atoms/top_rated_doctor_bar.dart';
import 'package:medifirst/core/widgets/elements/error_text.dart';
import 'package:medifirst/core/widgets/elements/loader.dart';
import 'package:medifirst/core/widgets/elements/section_heading_text.dart';
import 'package:medifirst/features/auth/controller/auth_controller.dart';
import 'package:medifirst/features/book_doctors/presentation/screens/doctor_details_page.dart';
import 'package:medifirst/features/explore/controller/explore_controller.dart';
import 'package:medifirst/features/explore/presentation/screens/doctor_search_bar.dart';
import 'package:medifirst/features/explore/presentation/widgets/appointment_bar.dart';
import 'package:medifirst/features/explore/presentation/widgets/explore_category_row.dart';
import 'package:medifirst/features/location/presentation/widgets/doctor_list_tile.dart';
import 'package:zego_uikit_prebuilt_call/zego_uikit_prebuilt_call.dart';
import 'package:zego_uikit_signaling_plugin/zego_uikit_signaling_plugin.dart';

import '../../../../models/doctor_info.dart';
import '../widgets/GroupedSpecialtySelector.dart';
import '../widgets/explore_app_bar.dart';

class ExplorePage extends ConsumerStatefulWidget {
  const ExplorePage({Key? key}) : super(key: key);

  @override
  ConsumerState<ExplorePage> createState() => _ExplorePageState();
}

class _ExplorePageState extends ConsumerState<ExplorePage> {
  late TextEditingController searchLocationController;
  String searchQuery = '';

  Future<void> initZegoCall() async {
    await ZegoUIKitPrebuiltCallInvitationService().init(
      appID: int.parse(
          const String.fromEnvironment('zegoCloudAppId', defaultValue: '')),
      appSign:
          const String.fromEnvironment('zegoCloudAppSign', defaultValue: ''),
      userID: ref.read(userProvider)?.uid ?? 'Guest',
      userName: ref.read(userProvider)?.name ?? 'Guest',
      plugins: [ZegoUIKitSignalingPlugin()],
    );
  }

  @override
  void initState() {
    super.initState();
    searchLocationController = TextEditingController();
    initZegoCall();
  }

  @override
  void dispose() {
    searchLocationController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final user = ref.watch(userProvider);
    final Size size = MediaQuery.of(context).size;
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
                    child: ExploreAppBar(
                        uid: user?.uid ?? '',
                        name: user?.name ?? '',
                        profilePic: user?.profilePicture ?? ''),
                  ),
                  SizedBox(height: size.height * 12 / 852),
                  _buildSearchBar(context, size),
                  SizedBox(height: size.height * 24 / 852),
                  Padding(
                    padding:
                        EdgeInsets.symmetric(horizontal: size.width * 16 / 393),
                    child: const SectionHeadingText(heading: 'APPOINTMENTS'),
                  ),
                  SizedBox(height: size.height * 12 / 852),
                ],
              ),
            ),
            SliverToBoxAdapter(
              child: SizedBox(
                height: size.height * 100 / 600, // Adjust this value as needed
                child: _buildAppointmentsList(ref, user?.uid ?? ''),
              ),
            ),
            SliverToBoxAdapter(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  SizedBox(height: size.height * 24 / 852),
                  Padding(
                    padding:
                        EdgeInsets.symmetric(horizontal: size.width * 16 / 393),
                    child: const ExploreCategoryRow(),
                  ),
                  SizedBox(height: size.height * 24 / 852),
                  Padding(
                    padding:
                        EdgeInsets.symmetric(horizontal: size.width * 16 / 393),
                    child: const SectionHeadingText(heading: 'MEDICATION'),
                  ),
                  SizedBox(height: size.height * 12 / 852),
                  SizedBox(
                    height: size.height * 93 / 852,
                    child: _buildMedicationBar(ref, user?.uid ?? ''),
                  ),
                  SizedBox(height: size.height * 24 / 852),
                  Image.asset(
                    'assets/images/banner.png',
                    width: double.infinity,
                    height: size.height * 109 / 852,
                    fit: BoxFit.fitWidth,
                  ),
                  SizedBox(height: size.height * 24 / 852),
                  Padding(
                    padding:
                        EdgeInsets.symmetric(horizontal: size.width * 16 / 393),
                    child: const SectionHeadingText(heading: 'MY ORDERS'),
                  ),
                  SizedBox(height: size.height * 12 / 852),
                  SizedBox(
                    height: size.height * 93 / 852,
                    child: _buildOrderBar(ref, user?.uid ?? ''),
                  ),
                  SizedBox(height: size.height * 24 / 852),
                  Padding(
                    padding:
                        EdgeInsets.symmetric(horizontal: size.width * 16 / 393),
                    child:
                        const SectionHeadingText(heading: 'TOP RATED DOCTORS'),
                  ),
                  SizedBox(height: size.height * 12 / 852),
                  SizedBox(
                    height: size.height * 93 / 852,
                    child: _buildTopRatedDoctors(ref, context),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildSearchBar(BuildContext context, Size size) {
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: size.width * 16 / 393),
      child: InkWell(
        onTap: () async {
          Navigator.push(
              context,
              MaterialPageRoute(
                  builder: (context) => const DoctorSearchPage()));
        },
        child: Container(
          height: size.height * 48 / 852,
          width: double.infinity,
          decoration: BoxDecoration(
            border: Border.all(color: Palette.highlightTextGray),
            borderRadius: BorderRadius.circular(50),
            color: Palette.whiteColor,
          ),
          child: Row(
            children: [
              SizedBox(width: size.width * 4 / 393),
              SvgPicture.asset(
                'assets/icons/svgs/location.svg',
                width: size.width * 24 / 393,
                height: size.width * 24 / 393,
              ),
              SizedBox(width: size.width * 8 / 393),
              Text(
                'Search For Doctors',
                style: Palette.lightModeAppTheme.textTheme.bodyMedium?.copyWith(
                  fontSize: 14,
                  color: Palette.highlightTextGray,
                ),
              ),
              Spacer(),
            ],
          ),
        ),
      ),
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

  Widget _buildMedicationBar(WidgetRef ref, String uid) {
    return ref.watch(nextMedicationProvider(uid)).when(
          data: (medication) {
            return MedicationBar(medication: medication);
          },
          error: (error, stackTrace) =>
              const ErrorText(error: 'No medications scheduled'),
          loading: () => const Loader(),
        );
  }

  Widget _buildOrderBar(WidgetRef ref, String uid) {
    return ref.watch(nextOrderProvider(uid)).when(
          data: (order) {
            return DrugOrderBar(order: order);
          },
          error: (error, stackTrace) => const ErrorText(error: 'No orders'),
          loading: () => const Loader(),
        );
  }

  Widget _buildTopRatedDoctors(WidgetRef ref, BuildContext context) {
    return ref.watch(topRatedDoctorsProvider).when(
          data: (doctors) {
            return ListView.builder(
                itemCount: doctors.length >= 3 ? 3 : doctors.length,
                itemBuilder: (context, index) {
                  if (doctors.isNotEmpty) {
                    final doctor = doctors[index];
                    if (index <= 3) {
                      return InkWell(
                        onTap: () {
                          Navigator.push(
                              context,
                              MaterialPageRoute(
                                  builder: (context) =>
                                      DoctorDetailsPage(doctorInfo: doctor)));
                        },
                        child: TopRatedDoctorBar(
                          doctor: doctor,
                        ),
                      );
                    }
                  } else {
                    return const Center(
                        child: ErrorText(error: 'No notifications available'));
                  }
                  return null;
                });
          },
          error: (error, stackTrace) =>
              const ErrorText(error: 'No doctors listed'),
          loading: () => const Loader(),
        );
  }
}

final doctorSearchResultsProvider = StreamProvider<List<DoctorInfo>>((ref) {
  final query = ref.watch(searchQueryProvider);
  final doctorService = ref.watch(exploreControllerProvider);
  return doctorService.getDoctorSearchResults(query);
});

class DoctorSearchPage extends ConsumerWidget {
  const DoctorSearchPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final searchResults = ref.watch(doctorSearchResultsProvider);
    return Scaffold(
      backgroundColor: Palette.whiteColor,
      appBar: AppBar(
        title: const Text('Doctor Search'),
        backgroundColor: Palette.whiteColor,
      ),
      body: Column(
        children: [
          const DoctorSearchBar(),
          const SizedBox(
            height: 10,
          ),
          const SpecialtySelector(),
          const SizedBox(
            height: 10,
          ),
          Expanded(
            child: searchResults.when(
              data: (doctors) {
                if (doctors.isEmpty) {
                  return Center(child: Text('No doctors found'));
                }
                return ListView.builder(
                  itemCount: doctors.length,
                  itemBuilder: (context, index) =>
                      DoctorListTile(doctor: doctors[index]),
                );
              },
              loading: () => Center(child: CircularProgressIndicator()),
              error: (error, stack) => Center(child: Text('Error: $error')),
            ),
          ),
        ],
      ),
    );
  }
}
