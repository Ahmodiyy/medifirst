import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:medifirst/core/theming/palette.dart';
import 'package:medifirst/core/theming/spaces.dart';
import 'package:medifirst/core/widgets/atoms/address_bar.dart';
import 'package:medifirst/core/widgets/atoms/full_rating_details.dart';
import 'package:medifirst/core/widgets/atoms/open_close_time.dart';
import 'package:medifirst/features/book_doctors/presentation/screens/doctor_details_page.dart';
import 'package:medifirst/models/doctor_info.dart';
import 'package:medifirst/models/healthcare_centre_info.dart';

class DoctorListTile extends StatefulWidget {
  final DoctorInfo doctor;
  const DoctorListTile({super.key, required this.doctor});

  @override
  State<DoctorListTile> createState() => _DoctorListTileState();
}

class _DoctorListTileState extends State<DoctorListTile> {
  @override
  Widget build(BuildContext context) {
    final Size size = MediaQuery.sizeOf(context);
    return InkWell(
      onTap: (){
        Navigator.push(context, MaterialPageRoute(builder: (context)=>DoctorDetailsPage(doctorInfo: widget.doctor)));
      },
      child: Container(
        height: size.height * 124/852,
        width: double.infinity,
        padding: EdgeInsets.symmetric(horizontal: size.width * 16/393).copyWith(bottom: 0, top: size.height * 8/852),
        child: Column(
          mainAxisSize: MainAxisSize.max,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Row(
              mainAxisSize: MainAxisSize.max,
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text('Dr. ${widget.doctor.name} ${widget.doctor.surname}', style: Palette.lightModeAppTheme.textTheme.bodyMedium?.copyWith(fontSize: 16),),
                    (size.height * 4/852).pv,
                    FullRatingDetails(totalRating: widget.doctor.totalRating, noOfReviews: widget.doctor.numberOfReviews,),
                    (size.height * 4/852).pv,
                    OpenCloseTime(openTime: widget.doctor.openingHours, closeTime: widget.doctor.closingHours,),
                  ],
                ),
                // Column(
                //   mainAxisSize: MainAxisSize.max,
                //   crossAxisAlignment: CrossAxisAlignment.center,
                //   children: [
                //     SvgPicture.asset('assets/icons/svgs/route-square.svg', height: 24, width: 24,),
                //     (size.height * 4/852).pv,
                //     Text('Directions', style: Palette.lightModeAppTheme.textTheme.bodyMedium?.copyWith(fontSize: 10, color: Palette.blueText,),)
                //   ],
                // ),
              ],
            ),
            (size.height * 10/852).pv,
            const Divider(
              thickness: 1.0,
              color: Palette.dividerGray,
            )
          ],
        ),
      ),
    );
  }
}
