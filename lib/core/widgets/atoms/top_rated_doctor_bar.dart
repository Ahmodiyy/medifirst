import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:intl/intl.dart';
import 'package:medifirst/core/theming/palette.dart';
import 'package:medifirst/core/theming/spaces.dart';
import 'package:medifirst/core/widgets/elements/rating_bar.dart';
import 'package:medifirst/core/widgets/elements/card_53_image.dart';
import 'package:medifirst/core/widgets/elements/section_container.dart';
import 'package:medifirst/models/doctor_info.dart';

class TopRatedDoctorBar extends StatefulWidget {
  final DoctorInfo doctor;
  const TopRatedDoctorBar({super.key, required this.doctor});

  @override
  State<TopRatedDoctorBar> createState() => _TopRatedDoctorBarState();
}

class _TopRatedDoctorBarState extends State<TopRatedDoctorBar> {
  final value = NumberFormat('#,##0.00', 'en_US');
  @override
  Widget build(BuildContext context) {
    final Size size = MediaQuery.sizeOf(context);
    return SectionContainer(
      height: size.height * 93.4/852,
      child: Padding(
        padding: EdgeInsets.symmetric(
          horizontal: size.width * 10/393,
          // vertical: size.height * 20/852,
        ),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.center,
          mainAxisSize: MainAxisSize.max,
          children: [
            Card53Image(imgUrl: widget.doctor.doctorImage,height: 50, width: 50,),
            (size.width * 12/393).ph,
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisAlignment: MainAxisAlignment.center,
              mainAxisSize: MainAxisSize.min,
              children: [
                Text(
                  '${widget.doctor.name} ${widget.doctor.surname}',
                  style: Palette.lightModeAppTheme.textTheme.bodyMedium
                      ?.copyWith(fontSize: 14, letterSpacing: -0.4),
                ),
                Text(
                  widget.doctor.profession,
                  style: Palette.lightModeAppTheme.textTheme.bodySmall
                      ?.copyWith(letterSpacing: -0.4),
                ),
                (size.height * 12/852).pv,
                Row(
                  mainAxisSize: MainAxisSize.min,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    RatingBar(rating: widget.doctor.avgRating),
                    (size.width * 10/393).ph,
                    Text(
                      '${widget.doctor.numberOfReviews} reviews',
                      style: Palette.lightModeAppTheme.textTheme.bodySmall
                          ?.copyWith(
                              fontSize: 9,
                              color: Palette.highlightTextGray,
                              letterSpacing: -0.4),
                    ),
                  ],
                ),
              ],
            ),
            Flexible(child: Container()),
            Column(
              crossAxisAlignment: CrossAxisAlignment.end,
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                SvgPicture.asset(
                  'assets/icons/svgs/heart_outline.svg',
                  height: 24,
                  width: 24,
                ),
                Text(
                  'N${value.format(widget.doctor.consultationFee)}',
                  style: Palette.lightModeAppTheme.textTheme.titleMedium
                      ?.copyWith(
                      fontSize: 12,
                      letterSpacing: -0.4),
                ),
              ],
            )
          ],
        ),
      ),
    );
  }
}
