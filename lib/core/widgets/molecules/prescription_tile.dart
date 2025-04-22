import 'package:flutter/material.dart';
import 'package:medifirst/core/theming/palette.dart';
import 'package:medifirst/core/theming/spaces.dart';
import 'package:medifirst/core/widgets/elements/card_53_image.dart';
import 'package:medifirst/models/prescription_info.dart';

class PrescriptionTile extends StatelessWidget {
  final PrescriptionInfo prescription;
  const PrescriptionTile({super.key, required this.prescription});

  @override
  Widget build(BuildContext context) {
    final Size size = MediaQuery.sizeOf(context);
    return Container(
      width: double.infinity,
      height: size.height * 69/852,
      color: Palette.whiteColor,
      padding: EdgeInsets.symmetric(horizontal: size.width * 16/393),
      child: Row(
        children: [
          Card53Image(imgUrl: prescription.drugImgUrl),
          (size.width * 10/393).ph,
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(prescription.drugName, style: Palette.lightModeAppTheme.textTheme.bodyMedium?.copyWith(
                fontSize: 14,
              ),),
              (size.width * 4/393).ph,
              Text(prescription.drugName, style: Palette.lightModeAppTheme.textTheme.bodySmall?.copyWith(
                fontSize: 8,
              ),),
            ],
          ),
        ],
      ),
    );
  }
}
