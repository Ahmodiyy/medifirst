import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:medifirst/core/theming/spaces.dart';
import 'package:medifirst/core/widgets/atoms/open_close_time.dart';
import 'package:medifirst/core/widgets/elements/action_button_container.dart';
import 'package:medifirst/core/widgets/elements/icon_action_button.dart';
import 'package:medifirst/core/widgets/elements/rating_bar.dart';
import 'package:medifirst/features/catalog/presentation/screens/catalog_screen.dart';
import 'package:medifirst/features/location/presentation/screens/select_prescription_screen.dart';
import 'package:medifirst/models/healthcare_centre_info.dart';

import '../../../../core/theming/palette.dart';

class MapPharmacyModal extends StatefulWidget {
  final HealthcareCentreInfo pharmacy;
  const MapPharmacyModal({super.key, required this.pharmacy});

  @override
  State<MapPharmacyModal> createState() => _MapPharmacyModalState();
}

class _MapPharmacyModalState extends State<MapPharmacyModal> {
  @override
  Widget build(BuildContext context) {
    final Size size = MediaQuery.sizeOf(context);
    final pharmacy = widget.pharmacy;
    return Container(
      height: size.height * 457.5 / 852,
      width: double.infinity,
      padding:
          EdgeInsets.only(bottom: MediaQuery.of(context).viewInsets.bottom),
      color: Palette.smallBodyGray,
      child: Container(
        width: double.infinity,
        padding: EdgeInsets.all(size.width * 18 / 393),
        decoration: const BoxDecoration(
          borderRadius: BorderRadius.only(
              topRight: Radius.circular(20), topLeft: Radius.circular(20)),
          color: Palette.whiteColor,
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          children: [
            Container(
              height: size.height * 191 / 852,
              width: double.infinity,
              decoration: BoxDecoration(
                borderRadius: const BorderRadius.only(
                    topRight: Radius.circular(20),
                    topLeft: Radius.circular(20)),
                image: DecorationImage(
                  image: NetworkImage(pharmacy.pharmacyImgUrl),
                  fit: BoxFit.fill,
                ),
              ),
            ),
            (size.height * 20 / 852).pv,
            Row(
              children: [
                Column(
                  children: [
                    Text(
                      pharmacy.name,
                      style: Palette.lightModeAppTheme.textTheme.titleSmall
                          ?.copyWith(fontSize: 16),
                    ),
                    (size.height * 8 / 852).pv,
                    Row(
                      children: [
                        Text(
                          '(${(pharmacy.totalRating / pharmacy.noOfReviews).toString()}) ',
                          style: Palette.lightModeAppTheme.textTheme.bodySmall
                              ?.copyWith(
                            fontSize: 14,
                            color: Palette.hintTextGray,
                          ),
                        ),
                        RatingBar(
                            rating:
                                (pharmacy.totalRating / pharmacy.noOfReviews)),
                        Text(
                          ' (${pharmacy.noOfReviews.toString()})',
                          style: Palette.lightModeAppTheme.textTheme.bodySmall
                              ?.copyWith(
                            fontSize: 14,
                            color: Palette.hintTextGray,
                          ),
                        ),
                      ],
                    ),
                    (size.height * 8 / 852).pv,
                    SizedBox(
                      width: size.width * 233 / 393,
                      child: Text(
                        '${pharmacy.type} • ${pharmacy.address}',
                        overflow: TextOverflow.ellipsis,
                        style: Palette.lightModeAppTheme.textTheme.bodySmall
                            ?.copyWith(
                          fontSize: 14,
                          color: Palette.hintTextGray,
                        ),
                      ),
                    ),
                    (size.height * 8 / 852).pv,
                    OpenCloseTime(
                        openTime: pharmacy.openingHours,
                        closeTime: pharmacy.closingHours),
                  ],
                ),
                Flexible(child: Container()),
                Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Column(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        SvgPicture.asset(
                          'assets/icons/svgs/phone_call.svg',
                          width: 24,
                          height: 24,
                        ),
                        Text(
                          'Call',
                          style: Palette.lightModeAppTheme.textTheme.bodyMedium
                              ?.copyWith(
                            color: Palette.blueText,
                            fontSize: 10,
                          ),
                        ),
                      ],
                    ),
                    (size.height * 14 / 852).pv,
                    Column(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        SvgPicture.asset(
                          'assets/icons/svgs/route_square.svg',
                          width: 24,
                          height: 24,
                        ),
                        Text(
                          'Directions',
                          style: Palette.lightModeAppTheme.textTheme.bodyMedium
                              ?.copyWith(
                            color: Palette.blueText,
                            fontSize: 10,
                          ),
                        ),
                      ],
                    ),
                  ],
                )
              ],
            ).sidePad(size.width * 16 / 393),
            (size.height * 24 / 852).pv,
            InkWell(
                onTap: () {
                  Navigator.push(
                      context,
                      MaterialPageRoute(
                          builder: (context) =>
                              SelectPrescriptionScreen(pharmacy: pharmacy)));
                },
                child: const IconActionButtonContainer(
                    title: 'Upload Prescription',
                    svgURL: 'assets/icons/svgs/upload.svg')),
            (size.height * 12 / 852).pv,
            InkWell(
                onTap: () {
                  Navigator.push(
                      context,
                      MaterialPageRoute(
                          builder: (context) =>
                              CatalogScreen(pharmacyId: pharmacy.pId)));
                },
                child: const ActionButtonContainer(title: 'Browse Catalog')),
          ],
        ),
      ),
    );
  }
}
