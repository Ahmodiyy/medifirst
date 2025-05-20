
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:intl/intl.dart';
import 'package:medifirst/core/theming/palette.dart';
import 'package:medifirst/core/theming/spaces.dart';
import 'package:medifirst/core/widgets/elements/card_53_image.dart';
import 'package:medifirst/core/widgets/elements/section_container.dart';
import 'package:medifirst/models/prescription_info.dart';

class PrescriptionListTile extends ConsumerStatefulWidget {
  final PrescriptionInfo prescription;
  final bool isToday;
  const PrescriptionListTile(
      {super.key, required this.prescription, required this.isToday});

  @override
  ConsumerState createState() => _PrescriptionListTileState();
}

class _PrescriptionListTileState extends ConsumerState<PrescriptionListTile> {
  @override
  Widget build(BuildContext context) {
    final Size size = MediaQuery.sizeOf(context);
    final prescription = widget.prescription;
    return SectionContainer(
      backgroundColor: widget.isToday ? Palette.mainGreen : null,
      height: size.height * 70 / 852,
      child: Padding(
        padding: EdgeInsets.symmetric(
            vertical: size.height * 20 / 852,
            horizontal: size.width * 16 / 393),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Card53Image(imgUrl: prescription.drugImgUrl),
            (size.width * 10 / 393).ph,
            Column(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      prescription.drugName,
                      style: Palette.lightModeAppTheme.textTheme.bodyMedium
                          ?.copyWith(
                        color: widget.isToday ? Palette.whiteColor : null,
                        fontSize: 14,
                      ),
                    ),
                    (size.width * 4 / 393).ph,
                    Text(
                      prescription.dosage,
                      style: Palette.lightModeAppTheme.textTheme.bodyMedium
                          ?.copyWith(
                        color: widget.isToday ? Palette.whiteColor : null,
                        fontSize: 14,
                      ),
                    ),
                  ],
                ),
                Row(
                  children: [
                    Text(
                      'Refill reminder:',
                      style: Palette.lightModeAppTheme.textTheme.bodySmall
                          ?.copyWith(
                        color: widget.isToday ? Palette.whiteColor : null,
                        fontSize: 10,
                      ),
                    ),
                    (size.width * 4 / 393).ph,
                    CupertinoSwitch(
                      value: prescription.isRepeating,
                      activeColor: widget.isToday
                          ? Palette.whiteColor
                          : Palette.mainGreen,
                      thumbColor: widget.isToday
                          ? Palette.mainGreen
                          : Palette.whiteColor,
                      onChanged: (bool newValue) {
                        //TODO add change function
                      },
                    ),
                  ],
                ),
              ],
            ),
            Flexible(
              child: Container(),
            ),
            Row(
              children: [
                RichText(
                  text: TextSpan(
                    text: 'Next pickup: ',
                    style: Palette.lightModeAppTheme.textTheme.bodySmall
                        ?.copyWith(
                      color: widget.isToday ? Palette.whiteColor : null,
                      fontSize: 10,
                    ),
                    children: [
                      TextSpan(
                        text: (DateTime.now().month == prescription.nextPickupDate.toDate().month && DateTime.now().day == prescription.nextPickupDate.toDate().day)? 'Today' : DateFormat.MMMMEEEEd().format(prescription.nextPickupDate.toDate()),
                        style: Palette.lightModeAppTheme.textTheme.bodySmall
                            ?.copyWith(
                          color: widget.isToday ? Palette.whiteColor : null,
                          fontSize: 10,
                        ),
                      ),
                    ]
                  ),
                ),
                (size.width * 4/393).ph,
                SvgPicture.asset(widget.isToday ? 'assets/icons/svgs/arrow_right_white.svg':'assets/icons/svgs/arrow_right_black.svg', width: 24, height: 24,),
              ],
            )
          ],
        ),
      ),
    );
  }
}
