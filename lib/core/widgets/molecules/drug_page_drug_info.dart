import 'package:flutter/material.dart';
import 'package:medifirst/core/widgets/atoms/full_rating_details.dart';

import '../../theming/palette.dart';
import '../../theming/spaces.dart';

class DrugPageDrugInfo extends StatelessWidget {
  final String name;
  final String dosage;
  final String price;
  final String pharmacy;
  final int totalRating;
  final int noOfReviews;
  const DrugPageDrugInfo({
    super.key,
    required this.name,
    required this.dosage,
    required this.price,
    required this.pharmacy,
    required this.totalRating,
    required this.noOfReviews,
  });
  @override
  Widget build(BuildContext context) {
    final Size size = MediaQuery.sizeOf(context);
    return Container(
      height: size.height * 89 / 852,
      width: double.infinity,
      padding: EdgeInsets.all(size.width * 16 / 393)
          .copyWith(top: size.height * 24 / 852),
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
              Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisSize: MainAxisSize.min,
                children: [
                  Text(
                    name,
                    style: Palette.lightModeAppTheme.textTheme.bodyMedium
                        ?.copyWith(
                      fontSize: 20,
                    ),
                  ),
                  (size.width * 4 / 393).ph,
                  Text(
                    dosage,
                    style:
                        Palette.lightModeAppTheme.textTheme.bodySmall?.copyWith(
                      color: Palette.dividerGray,
                      fontSize: 12,
                    ),
                  ),
                ],
              ),
              Text(
                'N$price',
                style:
                    Palette.lightModeAppTheme.textTheme.titleMedium?.copyWith(
                  color: Palette.mainGreen,
                  fontSize: 16,
                ),
              ),
            ],
          ),
          Row(
            mainAxisSize: MainAxisSize.max,
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              FullRatingDetails(
                totalRating: totalRating,
                noOfReviews: noOfReviews,
              ),
              Text(
                pharmacy,
                style: Palette.lightModeAppTheme.textTheme.bodySmall?.copyWith(
                  color: Palette.highlightTextGray,
                  fontSize: 14,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
