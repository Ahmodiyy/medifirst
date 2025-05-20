import 'package:flutter/material.dart';

import '../../theming/palette.dart';
import '../../theming/spaces.dart';
import '../elements/rating_bar.dart';

class FullRatingDetails extends StatelessWidget {
  final int totalRating;
  final int noOfReviews;
  const FullRatingDetails({super.key, required this.totalRating, required this.noOfReviews});

  @override
  Widget build(BuildContext context) {
    final Size size = MediaQuery.sizeOf(context);
    return Row(
      crossAxisAlignment: CrossAxisAlignment.center,
      mainAxisSize: MainAxisSize.min,
      children: [
        Text(
          (totalRating == 0)? '(0)': '(${(totalRating / noOfReviews).toStringAsFixed(2)})',
          style:
          Palette.lightModeAppTheme.textTheme.bodySmall?.copyWith(
            color: Palette.highlightTextGray,
            fontSize: 14,
          ),
        ),
        (size.width * 6/393).ph,
        RatingBar(rating: (totalRating/noOfReviews)),
        (size.width * 6/393).ph,
        Text(
          '($noOfReviews)',
          style:
          Palette.lightModeAppTheme.textTheme.bodySmall?.copyWith(
            color: Palette.highlightTextGray,
            fontSize: 14,
          ),
        ),
      ],
    );
  }
}
