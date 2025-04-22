import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:medifirst/core/theming/palette.dart';
import 'package:medifirst/core/theming/spaces.dart';
import 'package:medifirst/core/widgets/elements/action_button_container.dart';
import 'package:medifirst/core/widgets/molecules/error_modal.dart';
import 'package:medifirst/features/auth/controller/auth_controller.dart';
import 'package:medifirst/features/drug_details/controller/drug_details_controller.dart';

import '../../../../core/widgets/elements/rating_star.dart';

class AddDrugReviewModal extends ConsumerStatefulWidget {
  final String drugID;
  final String storeId;
  const AddDrugReviewModal(
      {super.key, required this.drugID, required this.storeId});

  @override
  ConsumerState<AddDrugReviewModal> createState() => _AddDrugReviewModalState();
}

class _AddDrugReviewModalState extends ConsumerState<AddDrugReviewModal> {
  late TextEditingController _controller;
  int rating = 0;

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

  Future<void> saveReview({
    required WidgetRef ref,
    required BuildContext context,
    required String raterId,
    required String raterImgUrl,
    required String drugId,
    required String storeId,
    required String raterName,
  }) async {
    try{
      if(_controller.text.isNotEmpty){
        final controller = ref.read(drugDetailsControllerProvider);
        await controller.addDrugReview(
            raterId: raterId,
            raterImgUrl: raterImgUrl,
            drugId: drugId,
            storeId: storeId,
            review: _controller.text,
            rating: rating,
            raterName: raterName);
        Navigator.pop(context);
      }
    }catch(e){
      showModalBottomSheet(context: context, builder: (context)=>const ErrorModal(message: 'An error occurred'));
    }
  }

  @override
  Widget build(BuildContext context) {
    final Size size = MediaQuery.sizeOf(context);
    final user = ref.read(userProvider);
    return Container(
      width: double.infinity,
      height: (size.height * 521 / 852),
      padding: EdgeInsets.only(bottom: MediaQuery.viewInsetsOf(context).bottom),
      child: Container(
        height: (size.height * 521 / 852),
        width: double.infinity,
        decoration: const BoxDecoration(
          color: Palette.whiteColor,
          borderRadius: BorderRadius.only(
              topRight: Radius.circular(20), topLeft: Radius.circular(20)),
        ),
        child: Padding(
          padding: EdgeInsets.symmetric(horizontal: size.width * 16.0 / 393),
          child: Column(
            mainAxisSize: MainAxisSize.max,
            children: [
              (size.height * 82 / 852).pv,
              Text(
                'Add your review',
                style:
                    Palette.lightModeAppTheme.textTheme.titleMedium?.copyWith(
                  fontSize: 20,
                  height: 0,
                ),
              ),
              (size.height * 12 / 852).pv,
              Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  InkWell(
                      onTap: () {
                        setState(() {
                          rating = 1;
                        });
                      },
                      child: RatingStar(
                        color: (rating >= 1)
                            ? Palette.ratingYellow
                            : Palette.ratingGray,
                        starSize: 66,
                      )),
                  InkWell(
                      onTap: () {
                        setState(() {
                          rating = 2;
                        });
                      },
                      child: RatingStar(
                        color: (rating >= 2)
                            ? Palette.ratingYellow
                            : Palette.ratingGray,
                        starSize: 66,
                      )),
                  InkWell(
                      onTap: () {
                        setState(() {
                          rating = 3;
                        });
                      },
                      child: RatingStar(
                        color: (rating >= 3)
                            ? Palette.ratingYellow
                            : Palette.ratingGray,
                        starSize: 66,
                      )),
                  InkWell(
                      onTap: () {
                        setState(() {
                          rating = 4;
                        });
                      },
                      child: RatingStar(
                        color: (rating >= 4)
                            ? Palette.ratingYellow
                            : Palette.ratingGray,
                        starSize: 66,
                      )),
                  InkWell(
                      onTap: () {
                        setState(() {
                          rating = 5;
                        });
                      },
                      child: RatingStar(
                        color: (rating == 5)
                            ? Palette.ratingYellow
                            : Palette.ratingGray,
                        starSize: 66,
                      )),
                ],
              ),
              (size.height * 49 / 852).pv,
              SizedBox(
                width: size.width * (364 / 396),
                height: size.height * (171 / 759),
                child: TextField(
                  controller: _controller,
                  keyboardType: TextInputType.multiline,
                  maxLines: 8,
                  minLines: 8,
                  style: Palette.lightModeAppTheme.textTheme.bodySmall
                      ?.copyWith(fontSize: 14),
                  decoration: InputDecoration(
                    hintText: 'Write a message...',
                    hintStyle: Palette.lightModeAppTheme.textTheme.bodySmall
                        ?.copyWith(fontSize: 14, color: Palette.hintTextGray),
                    enabledBorder: const OutlineInputBorder(
                      borderSide:
                          BorderSide(color: Palette.hintTextGray, width: 1.5),
                      borderRadius: BorderRadius.all(Radius.circular(8)),
                    ),
                    focusedBorder: const OutlineInputBorder(
                      borderSide:
                          BorderSide(color: Palette.mainGreen, width: 1.5),
                      borderRadius: BorderRadius.all(Radius.circular(8)),
                    ),
                    filled: true,
                    fillColor: Palette.whiteColor,
                  ),
                ),
              ),
              (size.height * 50 / 852).pv,
              InkWell(
                  onTap: () async {
                    await saveReview(ref: ref, context: context, raterId: user!.uid, raterImgUrl: user.profilePicture, drugId: widget.drugID, storeId: widget.storeId, raterName: '${user.name} ${user.surname}');
                  },
                  child: const ActionButtonContainer(title: 'Done')),
            ],
          ),
        ),
      ),
    );
  }
}
