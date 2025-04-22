import 'package:flutter/material.dart';
import 'package:medifirst/core/theming/spaces.dart';
import 'package:medifirst/features/book_doctors/presentation/screens/book_doctor_page.dart';
import 'package:medifirst/features/book_doctors/presentation/screens/doctor_details_page.dart';
import 'package:medifirst/features/location/presentation/widgets/outline_action_button.dart';
import 'package:medifirst/models/doctor_info.dart';

import '../../../../core/theming/palette.dart';
import '../../../../core/widgets/elements/action_button_container.dart';
import 'doctor_info_section.dart';

class MapDoctorModal extends StatefulWidget {
  final DoctorInfo doctor;
  const MapDoctorModal({super.key, required this.doctor});

  @override
  State<MapDoctorModal> createState() => _MapDoctorModalState();
}

class _MapDoctorModalState extends State<MapDoctorModal> {
  @override
  Widget build(BuildContext context) {
    final Size size = MediaQuery.sizeOf(context);
    final doctor = widget.doctor;
    return Container(
      height: size.height * 457.5 / 852,
      width: double.infinity,
      padding:
      EdgeInsets.only(bottom: MediaQuery.of(context).viewInsets.bottom),
      color: Palette.smallBodyGray,
      child: Container(
        width: double.infinity,
        padding: EdgeInsets.all(size.width * 18 / 393),
        decoration: const BoxDecoration(
          borderRadius: BorderRadius.only(
              topRight: Radius.circular(20), topLeft: Radius.circular(20)),
          color: Palette.whiteColor,
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          children: [
            Container(
              height: size.height * 234 / 852,
              width: double.infinity,
              decoration: BoxDecoration(
                borderRadius: const BorderRadius.only(
                    topRight: Radius.circular(20),
                    topLeft: Radius.circular(20)),
                image: DecorationImage(
                  image: NetworkImage(doctor.doctorImage),
                  fit: BoxFit.fill,
                ),
              ),
            ),
            (size.height * 20 / 852).pv,
            DoctorInfoSection(doctor: doctor),
            (size.height * 19/852).pv,
            InkWell(onTap: (){
              Navigator.push(context, MaterialPageRoute(builder: (context)=>DoctorDetailsPage(doctorInfo: widget.doctor)));
            }, child: OutlineActionButton(title: 'View Details')),
            (size.height * 12/852).pv,
            InkWell(onTap: (){
              Navigator.push(context, MaterialPageRoute(builder: (context)=>BookDoctorPage(doctorInfo: widget.doctor)));
            },child: const ActionButtonContainer(title: 'Book Appointment')),
          ],
        ),
      ),
    );
  }
}
