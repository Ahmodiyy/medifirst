import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:medifirst/core/theming/spaces.dart';
import 'package:medifirst/core/widgets/elements/section_container.dart';
import 'package:medifirst/models/medication_info.dart';
import 'package:intl/intl.dart';

import '../../../../core/theming/palette.dart';

class PrescriptionBar extends StatefulWidget {
  final MedicationInfo medication;
  const PrescriptionBar({super.key, required this.medication});

  @override
  State<PrescriptionBar> createState() => _PrescriptionBarState();
}

class _PrescriptionBarState extends State<PrescriptionBar> {
  @override
  Widget build(BuildContext context) {
    final DateTime date = widget.medication.pickupDate.toDate();
    final bool isToday = DateFormat.yMd().format(date) ==
        DateFormat.yMd().format(DateTime.now());
    return SectionContainer(
      backgroundColor: isToday ? Palette.mainGreen : Palette.whiteColor,
      height: 70,
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Row(
          mainAxisSize: MainAxisSize.max,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Container(
              height: 34,
              width: 34,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(5),
                image: DecorationImage(
                  image: NetworkImage(widget.medication.drugImageURL),
                  fit: BoxFit.fill,
                ),
              ),
            ),
            12.ph,
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Row(
                  mainAxisSize: MainAxisSize.min,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      widget.medication.drugName,
                      style: Palette.lightModeAppTheme.textTheme.bodyMedium
                          ?.copyWith(
                        color: isToday ? Palette.whiteColor : null,
                        fontSize: 14,
                      ),
                    ),
                    4.ph,
                    Text(
                      widget.medication.dosage,
                      style: Palette.lightModeAppTheme.textTheme.bodySmall
                          ?.copyWith(
                        color: Palette.smallBodyGray,
                        fontSize: 8,
                      ),
                    ),
                  ],
                ),
                Row(
                  mainAxisSize: MainAxisSize.min,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    Text(
                      'Refill reminder:',
                      style: Palette.lightModeAppTheme.textTheme.bodySmall
                          ?.copyWith(
                        color: Palette.highlightTextGray,
                        fontSize: 8,
                      ),
                    ),
                    6.ph,
                    SizedBox(
                        height: 15.43,
                        width: 27,
                        child: CupertinoSwitch(
                          value: widget.medication.isRefill,
                          activeColor: Palette.mainGreen,
                          onChanged: (newBool) {
                            //TODO add backend function to change value
                          },
                        )),
                  ],
                )
              ],
            ),
            Flexible(child: Container()),
            Row(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Text.rich(
                  TextSpan(
                    children: [
                      TextSpan(
                        text: 'Next pickup: ',
                        style: Palette.lightModeAppTheme.textTheme.bodySmall
                            ?.copyWith(
                          fontSize: 10,
                          color: Palette.highlightTextGray,
                        ),
                      ),
                      TextSpan(
                        text: DateFormat.MMMEd().format(date),
                        style: Palette.lightModeAppTheme.textTheme.bodySmall
                            ?.copyWith(
                          color: isToday? Palette.whiteColor : null,
                          fontSize: 10,
                        ),
                      ),
                    ],
                  ),
                ),
                Icon(
                  Icons.chevron_right,
                  color: isToday? Palette.whiteColor : Palette.blackColor,
                  size: 24,
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
