import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:medifirst/core/theming/palette.dart';
import 'package:medifirst/core/widgets/elements/card_53_image.dart';
import 'package:medifirst/core/widgets/elements/rating_bar.dart';
import 'package:medifirst/core/widgets/elements/section_container.dart';
import 'package:medifirst/models/rating_model.dart';

import '../../theming/spaces.dart';

class ReviewCard extends StatelessWidget {
  final RatingModel review;
  const ReviewCard({super.key, required this.review});

  @override
  Widget build(BuildContext context) {
    return SectionContainer(
      height: 93,
      child: Padding(
        padding: const EdgeInsets.symmetric(vertical: 20.0, horizontal: 16.0),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.center,
          mainAxisSize: MainAxisSize.max,
          children: [
            Card53Image(imgUrl: review.raterImgUrl),
            12.ph,
            Column(
              mainAxisSize: MainAxisSize.max,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  mainAxisSize: MainAxisSize.max,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      review.raterName,
                      style: Palette.lightModeAppTheme.textTheme.titleSmall,
                    ),
                    Text(
                      DateFormat.yMMMd().format(review.postedAt.toDate()),
                      style: Palette.lightModeAppTheme.textTheme.bodySmall
                          ?.copyWith(
                        fontSize: 8,
                        color: Palette.smallBodyGray,
                      ),
                    ),
                  ],
                ),
                6.pv,
                RatingBar(rating: review.rating.toDouble()),
                9.pv,
                Text(
                  review.review,
                  maxLines: 2,
                  overflow: TextOverflow.fade,
                  style:
                      Palette.lightModeAppTheme.textTheme.bodySmall?.copyWith(
                    fontSize: 8,
                    color: Palette.smallBodyGray,
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
