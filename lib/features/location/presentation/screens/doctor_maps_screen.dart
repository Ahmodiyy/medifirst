import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:geolocator/geolocator.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:medifirst/core/theming/palette.dart';
import 'package:medifirst/core/theming/spaces.dart';
import 'package:medifirst/core/utils/utils.dart';
import 'package:medifirst/core/widgets/elements/action_button_container.dart';
import 'package:medifirst/features/location/controller/location_controller.dart';
import 'package:medifirst/features/location/presentation/screens/pharmacy_list_screen.dart';
import 'package:medifirst/features/location/presentation/widgets/map_doctor_modal.dart';
import 'package:medifirst/features/location/presentation/widgets/map_pharmacy_modal.dart';
import 'package:medifirst/models/doctor_info.dart';
import 'package:medifirst/models/healthcare_centre_info.dart';

import '../../../auth/controller/auth_controller.dart';

class DoctorMapsScreen extends ConsumerStatefulWidget {
  const DoctorMapsScreen({super.key});

  @override
  ConsumerState createState() => _DoctorMapsScreenState();
}

class _DoctorMapsScreenState extends ConsumerState<DoctorMapsScreen> {
  final Completer<GoogleMapController> _controller = Completer();

  final List<Marker> _marker = [];

  final List<Marker> _list = [];

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

  Future<void> getMarkers(
      {required BuildContext,
        required WidgetRef ref,
        required double lat,
        required double long}) async {
    final doctors = ref.watch(getDoctorsProvider);
    doctors.when(data: (doctors) {
      for (DoctorInfo doctor in doctors) {
        if (calculateDistance(
            lat1: lat,
            lon1: long,
            lat2: doctor.latitude!,
            lon2: doctor.longitude!) <=
            4000) {
          final marker = Marker(
              markerId: MarkerId(doctor.doctorId),
              position: LatLng(doctor.latitude!, doctor.longitude!),
              infoWindow: InfoWindow(
                title: doctor.name,
              ),
              onTap: (){
                if(mounted){
                  showModalBottomSheet(context: context, builder: (context)=>MapDoctorModal(doctor: doctor),);
                }
              }
          );
          _list.add(marker);
        }
      }
    }, error: (err, st) {
      ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
          content: Text(
              'Location permissions are permanently denied, we cannot request permissions.')));
    }, loading: () {
      ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
          content: Text(
              'Location permissions are permanently denied, we cannot request permissions.')));
    });
  }

  @override
  void initState(){
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_)async{
      var pos = await Geolocator.getCurrentPosition(desiredAccuracy: LocationAccuracy.high);
      getMarkers(BuildContext: context, ref: ref, lat: pos.latitude, long: pos.longitude);
      _marker.addAll(_list);
    });
  }

  @override
  Widget build(BuildContext context) {
    final Size size = MediaQuery.sizeOf(context);
    final user = ref.watch(userProvider);
    return FutureBuilder(
      future:
      Geolocator.getCurrentPosition(desiredAccuracy: LocationAccuracy.high),
      builder: (context, snapshot) {
        _handleLocationPermission();
        // getMarkers(
        //     BuildContext: context,
        //     ref: ref,
        //     lat: snapshot.data!.latitude,
        //     long: snapshot.data!.longitude);
        // setState(() {
        //   _marker.addAll(_list);
        // });
        return Scaffold(
          appBar: AppBar(
            backgroundColor: Palette.whiteColor,
            title: const Text('Map'),
            centerTitle: true,
          ),
          body: Stack(
            children: [
              Positioned.fill(
                // on below line creating google maps.
                child: GoogleMap(
                  // on below line setting camera position
                  initialCameraPosition: CameraPosition(
                      target: LatLng(
                          user!.latitude, user.longitude),
                      zoom: 16),
                  // on below line specifying map type.
                  mapType: MapType.normal,
                  // on below line setting user location enabled.
                  myLocationEnabled: true,
                  // on below line setting compass enabled.
                  compassEnabled: true,
                  markers: _list.toSet(),
                  // on below line specifying controller on map complete.
                  onMapCreated: (GoogleMapController controller) {
                    _controller.complete(controller);
                  },
                ),
              ),
              Align(
                alignment: Alignment.bottomCenter,
                child: Column(
                  children: [
                    Flexible(child: Container()),
                    InkWell(
                        onTap: () {
                          Navigator.push(
                              context,
                              MaterialPageRoute(
                                  builder: (context) =>
                                  const PharmacyListScreen()));
                        },
                        child: const ActionButtonContainer(
                            title: 'Browse Places')).sidePad(size.width*16/393),
                    SizedBox(
                      height: size.height * 12 / 852,
                      child: Container(),
                    )
                  ],
                ),
              )
            ],
          ),
        );
      },
    );
  }
}
