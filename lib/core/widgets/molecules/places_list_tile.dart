import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:medifirst/core/theming/palette.dart';
import 'package:medifirst/core/theming/spaces.dart';
import 'package:medifirst/core/widgets/atoms/address_bar.dart';
import 'package:medifirst/core/widgets/atoms/full_rating_details.dart';
import 'package:medifirst/core/widgets/atoms/open_close_time.dart';
import 'package:medifirst/models/healthcare_centre_info.dart';

class PlacesListTile extends StatefulWidget {
  final HealthcareCentreInfo practice;
  const PlacesListTile({super.key, required this.practice});

  @override
  State<PlacesListTile> createState() => _PlacesListTileState();
}

class _PlacesListTileState extends State<PlacesListTile> {
  @override
  Widget build(BuildContext context) {
    final Size size = MediaQuery.sizeOf(context);
    return Container(
      height: size.height * 124/852,
      width: double.infinity,
      padding: EdgeInsets.all(size.height * 16/393).copyWith(bottom: 0, top: size.height * 20/852),
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
                  //TODO add correct name
                  Text(widget.practice.name, style: Palette.lightModeAppTheme.textTheme.bodyMedium?.copyWith(fontSize: 16),),
                  (size.height * 8/852).pv,
                  FullRatingDetails(totalRating: widget.practice.totalRating, noOfReviews: widget.practice.noOfReviews,),
                  (size.height * 8/852).pv,
                  AddressBar(practice: widget.practice,),
                  (size.height * 8/852).pv,
                  OpenCloseTime(openTime: widget.practice.openingHours, closeTime: widget.practice.closingHours,),
                ],
              ),
              Column(
                mainAxisSize: MainAxisSize.max,
                crossAxisAlignment: CrossAxisAlignment.center,
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Column(
                    mainAxisSize: MainAxisSize.min,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      SvgPicture.asset('assets/icons/svgs/route-square.svg', height: 24, width: 24,),
                      (size.height * 4/852).pv,
                      Text('Directions', style: Palette.lightModeAppTheme.textTheme.bodyMedium?.copyWith(fontSize: 10, color: Palette.blueText,),)
                    ],
                  ),
                  Column(
                    mainAxisSize: MainAxisSize.min,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      SvgPicture.asset('assets/icons/svgs/route-square.svg', height: 24, width: 24,),
                      (size.height * 4/852).pv,
                      Text('Directions', style: Palette.lightModeAppTheme.textTheme.bodyMedium?.copyWith(fontSize: 10, color: Palette.blueText,),)
                    ],
                  ),
                ],
              )
            ],
          ),
          (size.height * 10/852).pv,
          const Divider(
            thickness: 1.0,
            color: Palette.dividerGray,
          )
        ],
      ),
    );
  }
}
