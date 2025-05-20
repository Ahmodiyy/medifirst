import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:medifirst/core/theming/spaces.dart';
import 'package:medifirst/models/doctor_info.dart';

import '../../../../core/theming/palette.dart';
import '../../../../core/widgets/atoms/full_rating_details.dart';

class DoctorPageDoctorInfo extends StatelessWidget {
  final DoctorInfo doctor;
  const DoctorPageDoctorInfo({super.key, required this.doctor});

  @override
  Widget build(BuildContext context) {
    final Size size = MediaQuery.sizeOf(context);
    return Container(
      width: double.infinity,
      padding: EdgeInsets.all(size.width * 16/393).copyWith(top: size.height * 24/852),
      decoration: const BoxDecoration(
        border:
            Border(bottom: BorderSide(color: Palette.dividerGray, width: 1.0)),
      ),
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
                style: Palette.lightModeAppTheme.textTheme.bodyMedium?.copyWith(
                  fontSize: 20,
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
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              FullRatingDetails(
                totalRating: doctor.totalRating,
                noOfReviews: doctor.numberOfReviews,
              ),
              Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  SvgPicture.asset('assets/icons/svgs/people.svg', height: 13, width: 13, colorFilter: ColorFilter.mode(Palette.highlightTextGray, BlendMode.srcIn),),
                  Text(
                    '1000',
                    style: Palette.lightModeAppTheme.textTheme.bodySmall?.copyWith(
                      color: Palette.highlightTextGray,
                      fontSize: 14,
                    ),),
                ],
              )
            ],
          ),
        ],
      ),
    );
  }
}
