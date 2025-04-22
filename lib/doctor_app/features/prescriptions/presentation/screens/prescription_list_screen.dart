import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:intl/intl.dart';
import 'package:medifirst/core/theming/spaces.dart';
import 'package:medifirst/core/widgets/elements/action_button_container.dart';
import 'package:medifirst/core/widgets/elements/icon_action_button.dart';
import 'package:medifirst/core/widgets/elements/loader.dart';
import 'package:medifirst/doctor_app/features/prescriptions/presentation/screens/create_prescription_screen.dart';
import 'package:medifirst/core/widgets/molecules/prescription_tile.dart';
import 'package:medifirst/features/auth/controller/auth_controller.dart';
import 'package:medifirst/models/user_info.dart';

import '../../../../../core/theming/palette.dart';
import '../../controller/prescription_controller.dart';

class PrescriptionListScreen extends ConsumerStatefulWidget {
  final UserInfoModel patient;
  const PrescriptionListScreen({super.key, required this.patient});

  @override
  ConsumerState createState() => _PrescriptionListScreenState();
}

class _PrescriptionListScreenState
    extends ConsumerState<PrescriptionListScreen> {
  @override
  Widget build(BuildContext context) {
    final Size size = MediaQuery.sizeOf(context);
    final doctor = ref.watch(doctorProvider);
    final patient = widget.patient;
    return Scaffold(
      backgroundColor: Palette.whiteColor,
      appBar: AppBar(
        backgroundColor: Palette.whiteColor,
        centerTitle: true,
        automaticallyImplyLeading: false,
        leading: IconButton(
          onPressed: () {
            Navigator.pop(context);
          },
          padding: EdgeInsets.only(right: size.width * 16 / 393),
          icon: const Icon(
            Icons.chevron_left_sharp,
            color: Palette.blackColor,
          ),
        ),
        title: Text(
          'E - Prescription',
          style: Palette.lightModeAppTheme.textTheme.bodySmall?.copyWith(
            fontSize: 20,
          ),
        ),
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          child: Column(
            children: [
              SizedBox(
                height: size.height * 565 / 852,
                child: ref
                    .watch(getCurrentPrescriptionsProvider(
                        '${doctor!.doctorId}${patient.uid}${DateFormat.yMd().format(DateTime.now())}'))
                    .when(
                      data: (prescriptions) {
                        return ListView.builder(itemBuilder: (context, index) {
                          final prescription = prescriptions[index];
                          return Column(
                            children: [
                              PrescriptionTile(prescription: prescription),
                              Divider(
                                color: Palette.dividerGray,
                                indent: size.width * 72 / 393,
                                endIndent: size.width * 16 / 393,
                              ),
                            ],
                          );
                        });
                      },
                      error: (err, st) => Text(
                        'No prescriptions',
                        style: Palette.lightModeAppTheme.textTheme.bodySmall
                            ?.copyWith(
                          color: Palette.hintTextGray,
                          fontSize: 10,
                        ),
                      ),
                      loading: () => const Loader(),
                    ),
              ),
              (size.height * 5/852).pv,
              InkWell(onTap: (){
                Navigator.push(context, MaterialPageRoute(builder: (context)=>CreatePrescriptionScreen(patientId: patient.uid)));
              }, child: const IconActionButtonContainer(title: 'Add Prescription', svgURL: 'assets/icons/svgs/add_black.svg'),).sidePad(size.width * 16/393),
              (size.height * 12/852).pv,
              InkWell(onTap: (){
                //TODO send
              }, child: const ActionButtonContainer(title: 'Send Prescription')),
            ],
          ),
        ),
      ),
    );
  }
}
