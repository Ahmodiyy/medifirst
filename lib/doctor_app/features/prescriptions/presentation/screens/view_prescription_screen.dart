import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:medifirst/core/theming/spaces.dart';
import 'package:medifirst/models/prescription_info.dart';

import '../../../../../core/theming/palette.dart';
import '../../../../../features/auth/controller/auth_controller.dart';

class ViewPrescriptionScreen extends ConsumerWidget {
  final PrescriptionInfo prescription;
  const ViewPrescriptionScreen({super.key, required this.prescription});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final Size size = MediaQuery.sizeOf(context);
    final doctor = ref.watch(doctorProvider);
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
              (size.height * 32 / 852).pv,
              Text(
                prescription.patientName,
                style: Palette.lightModeAppTheme.textTheme.bodySmall?.copyWith(
                  fontSize: 14,
                ),
              ).sidePad(size.width * 16 / 393),
              (size.height * 20 / 852).pv,
              const Divider(
                color: Palette.dividerGray,
              ),
              (size.height * 20 / 852).pv,
              Text(
                prescription.drugName,
                style:
                    Palette.lightModeAppTheme.textTheme.titleMedium?.copyWith(
                  fontSize: 36,
                ),
              ).sidePad(size.width * 16 / 393),
              (size.height * 20 / 852).pv,
              const Divider(
                color: Palette.dividerGray,
              ),
              (size.height * 20 / 852).pv,
              Row(
                children: [
                  Expanded(
                    child: RichText(
                      text: TextSpan(
                          text: prescription.qty.toString(),
                          style: Palette.lightModeAppTheme.textTheme.bodySmall
                              ?.copyWith(
                            fontSize: 20,
                          ),
                          children: [
                            TextSpan(
                              text: ' to be taken',
                              style: Palette
                                  .lightModeAppTheme.textTheme.bodySmall
                                  ?.copyWith(
                                color: Palette.highlightTextGray,
                                fontSize: 16,
                              ),
                            ),
                          ]),
                    ),
                  ),
                  Expanded(
                    child: RichText(
                      text: TextSpan(
                          text: prescription.noOfTimes.toString(),
                          style: Palette.lightModeAppTheme.textTheme.bodySmall
                              ?.copyWith(
                            fontSize: 20,
                          ),
                          children: [
                            TextSpan(
                              text: ' times daily',
                              style: Palette
                                  .lightModeAppTheme.textTheme.bodySmall
                                  ?.copyWith(
                                color: Palette.highlightTextGray,
                                fontSize: 16,
                              ),
                            ),
                          ]),
                    ),
                  ),
                ],
              ).sidePad(size.width * 16 / 393),
              (size.height * 16 / 852).pv,
              Container(
                height: size.height * 24 / 852,
                width: size.width * 167 / 393,
                color: Palette.prescriptionInfoYellow,
                child: Center(
                  child: Row(
                    children: [
                      SvgPicture.asset(
                        'assets/icons/svgs/pill_yellow.svg',
                        height: 24,
                        width: 24,
                      ),
                      RichText(
                        text: TextSpan(
                            text: '  To be taken ',
                            style: Palette.lightModeAppTheme.textTheme.bodySmall
                                ?.copyWith(
                              fontSize: 12,
                              color: Palette.ratingYellow,
                            ),
                            children: [
                              TextSpan(
                                text: (prescription.beforeMeal)
                                    ? 'before'
                                    : 'after',
                                style: Palette
                                    .lightModeAppTheme.textTheme.bodyLarge
                                    ?.copyWith(
                                  color: Palette.ratingYellow,
                                  fontSize: 12,
                                ),
                              ),
                              TextSpan(
                                text: ' meal',
                                style: Palette
                                    .lightModeAppTheme.textTheme.bodySmall
                                    ?.copyWith(
                                  color: Palette.ratingYellow,
                                  fontSize: 12,
                                ),
                              ),
                            ]),
                      ),
                    ],
                  ),
                ),
              ).sidePad(size.width * 16/393),
              (size.height * 20 / 852).pv,
              const Divider(
                color: Palette.dividerGray,
              ),
              (size.height * 20 / 852).pv,
              Row(
                children: [
                  SvgPicture.asset('assets/icons/svgs/person.svg', width: 24, height: 24,),
                  (size.width * 4/393).ph,
                  Text(
                    prescription.doctorName,
                    style: Palette.lightModeAppTheme.textTheme.bodySmall?.copyWith(
                      fontSize: 14,
                    ),
                  ),
                ],
              ).sidePad(size.width * 16/393),
              (size.height * 20 / 852).pv,
              const Divider(
                color: Palette.dividerGray,
              ),
              (size.height * 20 / 852).pv,
              Row(
                children: [
                  SvgPicture.asset('assets/icons/svgs/hospital.svg', width: 24, height: 24,),
                  (size.width * 4/393).ph,
                  Text(
                    prescription.pharmacyName,
                    style: Palette.lightModeAppTheme.textTheme.bodySmall?.copyWith(
                      fontSize: 14,
                    ),
                  ),
                ],
              ).sidePad(size.width * 16/393),
              (size.height * 20 / 852).pv,
              SizedBox(
                height: size.height * 363/852,
                child: ListView.builder(itemBuilder: (context, index){
                  if(prescription.images.isEmpty){
                    return Text('No image(s)', style: Palette.lightModeAppTheme.textTheme.bodySmall?.copyWith(
                      fontSize: 10,
                      color: Palette.highlightTextGray,
                    ),);
                  }
                  final image = prescription.images[index];
                  return Row(
                    children: [
                      SvgPicture.asset('assets/icons/svgs/adobe_pdf.svg', width: 24, height: 24,),
                      (size.width * 6/393).ph,
                      Text(
                        'IMG${prescription.prescGroupId}',
                        style: Palette.lightModeAppTheme.textTheme.bodyMedium?.copyWith(
                          fontSize: 16,
                        ),
                      ),
                    ],
                  );
                }),
              ).sidePad(size.width * 16/393),
            ],
          ),
        ),
      ),
    );
  }
}
