import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:geolocator/geolocator.dart';
import 'package:medifirst/core/theming/palette.dart';
import 'package:medifirst/core/theming/spaces.dart';
import 'package:medifirst/features/auth/controller/auth_controller.dart';
import 'package:medifirst/features/location/presentation/widgets/doctor_list_tile.dart';
import 'package:medifirst/features/settings/controller/settings_controller.dart';

import '../../../../models/healthcare_centre_info.dart';
import '../../controller/location_controller.dart';

class DoctorListScreen extends ConsumerStatefulWidget {
  const DoctorListScreen({super.key});

  @override
  ConsumerState createState() => _DoctorListScreenState();
}

class _DoctorListScreenState extends ConsumerState<DoctorListScreen> {
  late TextEditingController searchLocationController;
  int selectedTab = 0;
  List<HealthcareCentreInfo> pharmacies = [];

  @override
  void initState() {
    super.initState();
    searchLocationController = TextEditingController();
  }

  @override
  void dispose() {
    searchLocationController.dispose();
    super.dispose();
  }

  Future<bool> _handleLocationPermission() async {
    bool serviceEnabled;
    LocationPermission permission;

    serviceEnabled = await Geolocator.isLocationServiceEnabled();
    if (!serviceEnabled && mounted) {
      ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
          content: Text(
              'Location services are disabled. Please enable the services')));
      return false;
    }
    permission = await Geolocator.checkPermission();
    if (permission == LocationPermission.denied) {
      permission = await Geolocator.requestPermission();
      if (permission == LocationPermission.denied && mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(content: Text('Location permissions are denied')));
        return false;
      }
    }
    if (permission == LocationPermission.deniedForever && mounted) {
      ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
          content: Text(
              'Location permissions are permanently denied, we cannot request permissions.')));
      return false;
    }
    return true;
  }

  @override
  Widget build(BuildContext context) {
    final Size size = MediaQuery.sizeOf(context);
    final uid = ref.watch(userProvider);
    final user = ref.watch(userSettingsInfoProvider(uid!.uid));
    return Scaffold(
      backgroundColor: Palette.backGroundColor,
      appBar: AppBar(
        backgroundColor: Palette.whiteColor,
        leading: IconButton(
          onPressed: () {
            Navigator.pop(context);
          },
          padding: EdgeInsets.all(size.width * 16 / 393)
              .copyWith(bottom: size.height * 12 / 852),
          icon: const Icon(
            Icons.chevron_left,
            color: Palette.blackColor,
          ),
        ),
        centerTitle: true,
        title: Text(
          'List',
          style: Palette.lightModeAppTheme.textTheme.bodySmall?.copyWith(
            fontSize: 20,
            letterSpacing: -0.4,
          ),
        ),
        elevation: 0,
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          child: Column(
            children: [
              SizedBox(
                height: size.height * 16 / 852,
              ),
              // InkWell(
              //   onTap: () {
              //     Navigator.push(
              //         context,
              //         MaterialPageRoute(
              //             builder: (context) => const MapsScreen()));
              //   },
              //   child: LocationSearchBar(
              //     controller: searchLocationController,
              //     readOnly: true,
              //   ).sidePad(size.width * 16 / 393),
              // ),
              // (size.height * 20 / 852).pv,
              Text(
                'Doctors',
                style: Palette.lightModeAppTheme.textTheme.bodyMedium?.copyWith(
                  fontSize: 32,
                  color: Palette.hintTextGray,
                ),
              ).sidePad(size.width * 16 / 393).alignLeft(),
              (size.height * 20 / 852).pv,
              Row(
                mainAxisAlignment: MainAxisAlignment.start,
                children: [
                  InkWell(
                    onTap: () {
                      setState(() {
                        selectedTab = 0;
                      });
                    },
                    child: Text(
                      'All',
                      style: Palette.lightModeAppTheme.textTheme.bodyMedium
                          ?.copyWith(
                        fontSize: 16,
                        color: (selectedTab == 0)
                            ? Palette.blackColor
                            : Palette.highlightTextGray,
                      ),
                    ),
                  ),
                  (size.width * 31 / 393).ph,
                  InkWell(
                    onTap: () {
                      setState(() {
                        selectedTab = 1;
                      });
                    },
                    child: Text(
                      'Favorites',
                      style: Palette.lightModeAppTheme.textTheme.bodyMedium
                          ?.copyWith(
                        fontSize: 16,
                        color: (selectedTab == 1)
                            ? Palette.blackColor
                            : Palette.highlightTextGray,
                      ),
                    ),
                  ),
                ],
              ).sidePad(size.width * 16 / 393),
              (size.height * 10 / 852).pv,
              Divider(
                color: Palette.dividerGray,
                thickness: 1,
                indent: size.width * 16 / 393,
                endIndent: size.width * 16 / 393,
              ),
              SizedBox(
                height: size.height * 600 / 852,
                child: (selectedTab == 0)
                    ? ref.watch(getDoctorsProvider).when(
                          data: (doctors) {
                            if (doctors.isEmpty) {
                              return Container(
                                alignment: Alignment.center,
                                padding: const EdgeInsets.all(20),
                                child: Text(
                                  'No doctor',
                                  style: Palette
                                      .lightModeAppTheme.textTheme.bodyMedium
                                      ?.copyWith(
                                    fontSize: 16,
                                    color: Palette.blackColor,
                                  ),
                                ),
                              );
                            }
                            return ListView.builder(
                                itemCount: doctors.length,
                                itemBuilder: (context, index) {
                                  final doctor = doctors[index];
                                  return DoctorListTile(doctor: doctor);
                                });
                          },
                          error: (err, st) {
                            return Container(
                              alignment: Alignment.center,
                              padding: const EdgeInsets.all(20),
                              child: Text(
                                err.toString(),
                                style: Palette
                                    .lightModeAppTheme.textTheme.bodyMedium
                                    ?.copyWith(
                                  fontSize: 16,
                                  color: Palette.blackColor,
                                ),
                              ),
                            );
                          },
                          loading: () => const Center(
                            child: CircularProgressIndicator(
                              color: Palette.mainGreen,
                            ),
                          ),
                        )
                    : ref.watch(getFavDoctorsProvider(user.value!)).when(
                          data: (doctors) {
                            if (doctors.isEmpty) {
                              return Container(
                                alignment: Alignment.center,
                                padding: const EdgeInsets.all(20),
                                child: Text(
                                  'No favourite',
                                  style: Palette
                                      .lightModeAppTheme.textTheme.bodyMedium
                                      ?.copyWith(
                                    fontSize: 16,
                                    color: Palette.blackColor,
                                  ),
                                ),
                              );
                            }
                            return ListView.builder(
                                itemCount: doctors.length,
                                itemBuilder: (context, index) {
                                  final doctor = doctors[index];
                                  return DoctorListTile(doctor: doctor);
                                });
                          },
                          error: (err, st) {
                            print(err.toString());
                            return Container(
                              alignment: Alignment.center,
                              padding: const EdgeInsets.all(20),
                              child: Text(
                                err.toString(),
                                style: Palette
                                    .lightModeAppTheme.textTheme.bodyMedium
                                    ?.copyWith(
                                  fontSize: 16,
                                  color: Palette.blackColor,
                                ),
                              ),
                            );
                          },
                          loading: () => const Center(
                            child: CircularProgressIndicator(
                              color: Palette.mainGreen,
                            ),
                          ),
                        ),
              )
            ],
          ),
        ),
      ),
    );
  }
}
