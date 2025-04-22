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
import 'package:medifirst/features/location/presentation/widgets/map_pharmacy_modal.dart';
import 'package:medifirst/models/healthcare_centre_info.dart';

import '../../../auth/controller/auth_controller.dart';

class MapsScreen extends ConsumerStatefulWidget {
  const MapsScreen({super.key});

  @override
  ConsumerState createState() => _MapsScreenState();
}

class _MapsScreenState extends ConsumerState<MapsScreen> {
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
    final practices = ref.watch(getPracticesProvider);
    practices.when(data: (practices) {
      for (HealthcareCentreInfo practice in practices) {
        if (calculateDistance(
                lat1: lat,
                lon1: long,
                lat2: practice.latitude,
                lon2: practice.longitude) <=
            4000) {
          final marker = Marker(
            markerId: MarkerId(practice.pId),
            position: LatLng(practice.latitude, practice.longitude),
            infoWindow: InfoWindow(
              title: practice.name,
            ),
            onTap: (){
              if(mounted){
                showModalBottomSheet(context: context, builder: (context)=>MapPharmacyModal(pharmacy: practice),);
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
    _marker.addAll(_list);
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
        getMarkers(
            BuildContext: BuildContext,
            ref: ref,
            lat: snapshot.data!.latitude,
            long: snapshot.data!.longitude);

        return Scaffold(
          appBar: AppBar(
            backgroundColor: Palette.whiteColor,
            title: const Text('Map'),
            centerTitle: true,
          ),
          body: Stack(
            alignment: Alignment.bottomCenter,
            children: [
              Positioned.fill(
                // on below line creating google maps.
                child: GoogleMap(
                  // on below line setting camera position
                  initialCameraPosition: CameraPosition(
                      target: LatLng(
                          snapshot.data!.latitude, snapshot.data!.longitude),
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
                            title: 'Browse Places').sidePad(size.width * 16/393)),
                    SizedBox(
                      height: size.height * 16 / 852,
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
