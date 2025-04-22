import 'package:flutter/material.dart';
import 'package:medifirst/core/theming/palette.dart';
import 'package:medifirst/core/widgets/elements/rating_star.dart';

class RatingBar extends StatelessWidget {
  final double rating;
  const RatingBar({required this.rating, super.key});

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        RatingStar(color: (rating>=1)? Palette.ratingYellow: Palette.ratingGray,),
        RatingStar(color: (rating>=2)? Palette.ratingYellow: Palette.ratingGray,),
        RatingStar(color: (rating>=3)? Palette.ratingYellow: Palette.ratingGray,),
        RatingStar(color: (rating>=4)? Palette.ratingYellow: Palette.ratingGray,),
        RatingStar(color: (rating>=5)? Palette.ratingYellow: Palette.ratingGray,),
      ],
    );
  }
}
