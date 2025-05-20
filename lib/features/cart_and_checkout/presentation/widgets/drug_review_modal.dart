import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:medifirst/core/theming/spaces.dart';
import 'package:medifirst/core/widgets/elements/rating_star.dart';

import '../../../../core/theming/palette.dart';

class DrugReviewModal extends ConsumerStatefulWidget {
  final String drugId;
  const DrugReviewModal({super.key, required this.drugId});

  @override
  ConsumerState createState() => _DrugReviewModalState();
}

class _DrugReviewModalState extends ConsumerState<DrugReviewModal> {
  int rating = 0;
  late TextEditingController _controller;


  @override
  void initState() {
    super.initState();
    _controller = TextEditingController();
  }


  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final Size size = MediaQuery.sizeOf(context);
    return Container(
      height: size.height * 521/852,
      width: double.infinity,
      padding: EdgeInsets.only(bottom: MediaQuery.of(context).viewInsets.bottom),
      color: Palette.smallBodyGray,
      child: Container(
        width: double.infinity,
        padding: EdgeInsets.all(size.width * 18/393),
        decoration: const BoxDecoration(
          borderRadius: BorderRadius.only(
              topRight: Radius.circular(20), topLeft: Radius.circular(20)),
          color: Palette.whiteColor,
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          children: [
            (size.height * 82/852).pv,
            Text('Rate drug experience', style: Palette.lightModeAppTheme.textTheme.titleMedium?.copyWith(
              fontSize: 20,
            ),),
            (size.height * 12/852).pv,
            Row(
              children: [
                InkWell(onTap: (){setState(() {
                  rating = 1;
                });},child: RatingStar(color: (rating >= 1)? Palette.ratingYellow : Palette.ratingGray, starSize: size.height*66/852,)),
                InkWell(onTap: (){setState(() {
                  rating = 2;
                });},child: RatingStar(color: (rating >= 2)? Palette.ratingYellow : Palette.ratingGray, starSize: size.height*66/852,)),
                InkWell(onTap: (){setState(() {
                  rating = 3;
                });},child: RatingStar(color: (rating >= 3)? Palette.ratingYellow : Palette.ratingGray, starSize: size.height*66/852,)),
                InkWell(onTap: (){setState(() {
                  rating = 4;
                });},child: RatingStar(color: (rating >= 4)? Palette.ratingYellow : Palette.ratingGray, starSize: size.height*66/852,)),
                InkWell(onTap: (){setState(() {
                  rating = 5;
                });},child: RatingStar(color: (rating >= 5)? Palette.ratingYellow : Palette.ratingGray, starSize: size.height*66/852,)),
              ],
            ).sidePad(size.width * 33/393),
            (size.height * 49/852).pv,

          ],
        ),
      ),
    );
  }
}
