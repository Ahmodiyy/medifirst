import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:medifirst/core/widgets/elements/section_container.dart';
import 'package:medifirst/models/medication_info.dart';
import 'package:intl/intl.dart';

import '../../theming/palette.dart';
import '../../theming/spaces.dart';

class MedicationBar extends StatefulWidget {
  final MedicationInfo medication;
  const MedicationBar({super.key, required this.medication});

  @override
  State<MedicationBar> createState() => _MedicationBarState();
}

class _MedicationBarState extends State<MedicationBar> {
  @override
  Widget build(BuildContext context) {
    final DateTime date = widget.medication.pickupDate.toDate();
    return SectionContainer(
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
                        style: Palette.lightModeAppTheme.textTheme.bodySmall?.copyWith(fontSize: 10, color: Palette.highlightTextGray),
                      ),
                      TextSpan(
                        text: DateFormat.MMMEd().format(date),
                        style: Palette.lightModeAppTheme.textTheme.bodySmall?.copyWith(fontSize: 10),
                      ),
                    ],
                  ),
                ),
                const Icon(Icons.chevron_right, color: Palette.blackColor, size: 24,),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
