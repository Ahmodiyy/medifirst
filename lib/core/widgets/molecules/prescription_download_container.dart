import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:medifirst/core/theming/palette.dart';
import 'package:medifirst/core/theming/spaces.dart';
import 'package:medifirst/core/widgets/elements/card_53_image.dart';
import 'package:medifirst/models/prescription_info.dart';

import '../elements/section_container.dart';

class PrescriptionDownloadContainer extends StatelessWidget {
  final PrescriptionInfo prescription;
  const PrescriptionDownloadContainer({super.key, required this.prescription});

  @override
  Widget build(BuildContext context) {
    final Size size = MediaQuery.sizeOf(context);
    return SectionContainer(
      backgroundColor: Palette.whiteColor,
      height: size.height * 93/852,
      child: Padding(
        padding: EdgeInsets.symmetric(horizontal: size.width * 16/393),
        child: Row(
          children: [
            Card53Image(imgUrl: prescription.patientImgUrl),
            (size.width * 12/393).ph,
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                //TODO add correct name
                Text(
                  prescription.patientName,
                  style:
                      Palette.lightModeAppTheme.textTheme.titleSmall?.copyWith(
                    fontSize: 14,
                    height: 0,
                    letterSpacing: -0.4,
                  ),
                ),
                (size.height * 10/852).pv,
                //TODO add correct doctor and hospital
                RichText(
                  text: TextSpan(
                    text: '${prescription.doctorName}   ',
                    style:
                        Palette.lightModeAppTheme.textTheme.bodySmall?.copyWith(
                      height: 0,
                      letterSpacing: -0.4,
                    ),
                    children: [
                      TextSpan(
                        text: prescription.pharmacyName,
                        style:
                        Palette.lightModeAppTheme.textTheme.bodySmall?.copyWith(
                          height: 0,
                          letterSpacing: -0.4,
                        ),
                      ),
                    ]
                  ),
                ),
              ],
            ),
            Flexible(child: Container()),
            IconButton(onPressed: (){
              //TODO add correct Navigation function
            }, icon: SvgPicture.asset('assets/icons/svgs/download.svg', width: 24, height: 24,),),
          ],
        ),
      ),
    );
  }
}
