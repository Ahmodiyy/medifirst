import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_svg/svg.dart';
import 'package:medifirst/core/theming/spaces.dart';
import 'package:medifirst/doctor_app/features/prescriptions/presentation/screens/create_prescription_screen.dart';
import 'package:medifirst/models/user_info.dart';

import '../../../../../core/theming/palette.dart';
import '../../../../../core/widgets/elements/action_button_container.dart';

class DoctorConsultationEndModal extends ConsumerWidget {
  final UserInfoModel patient;
  const DoctorConsultationEndModal({super.key, required this.patient});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final Size size = MediaQuery.sizeOf(context);
    return Container(
      height: size.height * 465/852,
      width: double.infinity,
      padding: EdgeInsets.only(bottom: MediaQuery.of(context).viewInsets.bottom),
      color: Palette.smallBodyGray,
      child: Container(
        width: double.infinity,
        padding: EdgeInsets.all(size.width * 18/393),
        decoration: const BoxDecoration(
          borderRadius: BorderRadius.only(
              topRight: Radius.circular(20), topLeft: Radius.circular(20)),
          color: Palette.whiteColor,
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          children: [
            (size.height * 51/852).pv,
            SvgPicture.asset('assets/icons/svgs/success.svg', height: 98, width: 98, fit: BoxFit.contain),
            (size.height * 24/852).pv,
            Text('Congratulations', style: Palette.lightModeAppTheme.textTheme.titleMedium?.copyWith(
              fontSize: 20,
            ),),
            (size.height * 12/852).pv,
            Text("Your session has ended", style: Palette.lightModeAppTheme.textTheme.bodySmall?.copyWith(
              fontSize: 14,
            ),),
            (size.height * 64/852).pv,
            InkWell(onTap: (){
              Navigator.push(context, MaterialPageRoute(builder: (context)=>CreatePrescriptionScreen(patientId: patient.uid)));
            },child: const ActionButtonContainer(title: 'Prescribe Drug', backGroundColor: Palette.highlightGreen, titleColor: Palette.mainGreen,),),
            (size.height * 12/852).pv,
            InkWell(onTap: (){
              Navigator.pop(context);
            },child: const ActionButtonContainer(title: 'Continue'),),
          ],
        ),
      ),
    );
  }
}