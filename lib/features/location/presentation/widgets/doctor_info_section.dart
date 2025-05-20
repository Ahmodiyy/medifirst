import 'package:flutter/material.dart';
import 'package:medifirst/models/doctor_info.dart';

import '../../../../core/theming/palette.dart';
import '../../../../core/widgets/atoms/full_rating_details.dart';

class DoctorInfoSection extends StatelessWidget {
  final DoctorInfo doctor;
  const DoctorInfoSection({super.key, required this.doctor});

  @override
  Widget build(BuildContext context) {
    final Size size = MediaQuery.sizeOf(context);
    return Container(
      height: size.height * 89/852,
      width: double.infinity,
      padding: EdgeInsets.all(size.width * 16/393).copyWith(top: size.height * 16/852),
      child: Column(
        mainAxisSize: MainAxisSize.max,
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Row(
            mainAxisSize: MainAxisSize.max,
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Text(
                doctor.profession,
                style: Palette.lightModeAppTheme.textTheme.bodySmall?.copyWith(
                  fontSize: 14,
                ),
              ),
              Text(
                '${doctor.yearsOfExperience} years',
                style: Palette.lightModeAppTheme.textTheme.bodySmall?.copyWith(
                  color: Palette.highlightTextGray,
                  fontSize: 14,
                ),
              ),
            ],
          ),
          FullRatingDetails(
            totalRating: doctor.totalRating,
            noOfReviews: doctor.numberOfReviews,
          ),
        ],
      ),
    );
  }
}
