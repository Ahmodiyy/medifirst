import 'dart:typed_data';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:intl/intl.dart';
import 'package:medifirst/core/theming/palette.dart';
import 'package:medifirst/core/theming/spaces.dart';
import 'package:medifirst/core/widgets/atoms/underlined_text_field.dart';
import 'package:medifirst/core/widgets/elements/action_button_container.dart';

import '../../../../../core/utils/utils.dart';
import '../../../../../core/widgets/elements/icon_action_button.dart';

class CreatePrescriptionScreen extends ConsumerStatefulWidget {
  final String patientId;
  const CreatePrescriptionScreen({super.key, required this.patientId});

  @override
  ConsumerState createState() => _CreatePrescriptionScreenState();
}

class _CreatePrescriptionScreenState
    extends ConsumerState<CreatePrescriptionScreen> {
  late TextEditingController _patientNameController;
  late TextEditingController _drugNameController;
  late TextEditingController _timesController;
  late TextEditingController _dosageController;
  late TextEditingController _doctorController;
  late TextEditingController _pharmacyController;
  bool beforeMeal = true;
  bool refillReminder = true;
  Uint8List? image;

  void selectAnImage() async {
    image = await pickOneImage();
    setState(() {});
  }

  @override
  void initState() {
    super.initState();
    _patientNameController = TextEditingController();
    _drugNameController = TextEditingController();
    _timesController = TextEditingController();
    _dosageController = TextEditingController();
    _doctorController = TextEditingController();
    _pharmacyController = TextEditingController();
  }


  @override
  void dispose() {
    _patientNameController.dispose();
    _drugNameController.dispose();
    _timesController.dispose();
    _dosageController.dispose();
    _doctorController.dispose();
    _pharmacyController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final Size size = MediaQuery.sizeOf(context);
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
          padding: EdgeInsets.only(right: size.width * 16/393),
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
        child: Padding(
          padding: EdgeInsets.symmetric(vertical: size.height * 32/852, horizontal: size.width * 16/393),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              UnderlinedTextField(controller: _patientNameController, hint: 'Patient Name'),
              (size.height * 32/852).pv,
              UnderlinedTextField(controller: _drugNameController, hint: 'Name of drug'),
              (size.height * 32/852).pv,
              Row(
                mainAxisAlignment: MainAxisAlignment.start,
                mainAxisSize: MainAxisSize.min,
                children: [
                  SizedBox(
                    width: size.width * 108/393,
                    child: UnderlinedTextField(controller: _dosageController, hint: 'To be taken'),
                  ),
                  (size.width * 37/393).ph,
                  SizedBox(
                    width: size.width * 108/393,
                    child: UnderlinedTextField(controller: _timesController, hint: 'Times daily'),
                  ),
                ],
              ),
              (size.height * 32/852).pv,
              Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Container(
                    height: size.height * 41/852,
                    width: size.width * 189/393,
                    padding: EdgeInsets.all(size.height * 3/852),
                    decoration: BoxDecoration(
                      color: Palette.dividerGray,
                      borderRadius: BorderRadius.circular(8),
                    ),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Container(
                          height: size.height * 35/852,
                          width: size.width * 90/393,
                          color: (beforeMeal)? Palette.whiteColor : null,
                          child: Text('Before', style: Palette.lightModeAppTheme.textTheme.bodyMedium?.copyWith(
                            fontSize: 14,
                            color: (beforeMeal)? Palette.blackColor : Palette.hintTextGray,
                          ),),
                        ),
                        Container(
                          height: size.height * 35/852,
                          width: size.width * 90/393,
                          color: (!beforeMeal)? Palette.whiteColor : null,
                          child: Text('After', style: Palette.lightModeAppTheme.textTheme.bodyMedium?.copyWith(
                            fontSize: 14,
                            color: (!beforeMeal)? Palette.blackColor : Palette.hintTextGray,
                          ),),
                        ),
                      ],
                    ),
                  ),
                  (size.width * 10/393).ph,
                  Text('After', style: Palette.lightModeAppTheme.textTheme.bodyMedium?.copyWith(
                    fontSize: 14,
                    color: Palette.hintTextGray,
                  ),),
                ],
              ),
              (size.height * 32/852).pv,
              UnderlinedTextField(controller: _doctorController, hint: 'Prescribed by'),
              (size.height * 32/852).pv,
              UnderlinedTextField(controller: _pharmacyController, hint: 'Supplied by'),
              (size.height * 32/852).pv,
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text('Date', style: Palette.lightModeAppTheme.textTheme.bodySmall?.copyWith(
                    fontSize: 14,
                    color: Palette.hintTextGray,
                  ),),
                  Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Text(DateFormat.yMd().format(DateTime.now()), style: Palette.lightModeAppTheme.textTheme.bodySmall?.copyWith(
                        fontSize: 14,
                        color: Palette.hintTextGray,
                      ),),
                      (size.width * 16/393).ph,
                      const Icon(Icons.calendar_month, size: 24, color: Palette.iconDarkGrey,),
                    ],
                  ),
                ],
              ),
              (size.height * 32/852).pv,
              Row(
                mainAxisSize: MainAxisSize.max,
                children: [
                  Text('Refill Consultation', style: Palette.lightModeAppTheme.textTheme.bodySmall?.copyWith(
                    fontSize: 14,
                    color: Palette.hintTextGray,
                  ),),
                  Switch(value: refillReminder, onChanged: (newValue){
                    setState(() {
                      refillReminder = newValue;
                    });
                  })
                ],
              ),
              (size.height * 80/852).pv,
              InkWell(onTap: (){
                selectAnImage();
              },child: const IconActionButtonContainer(title: 'Upload File', svgURL: 'assets/icons/svgs/upload.svg', titleColor: Palette.blackColor, backGroundColor: Palette.dividerGray,),),
              (size.height * 12/852).pv,
              InkWell(
                onTap: (){},
                child: const ActionButtonContainer(title: 'Done'),
              )
            ],
          ),
        ),
      ),
    );
  }
}
