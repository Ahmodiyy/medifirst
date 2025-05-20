import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_svg/svg.dart';
import 'package:medifirst/core/theming/spaces.dart';
import 'package:medifirst/features/cart_and_checkout/presentation/widgets/drug_review_modal.dart';
import 'package:medifirst/features/home/presentation/screens/home_screen.dart';

import '../../../../core/theming/palette.dart';
import '../../../../core/widgets/elements/action_button_container.dart';

class DrugPurchaseModal extends ConsumerWidget {
  final String drugId;
  const DrugPurchaseModal({super.key, required this.drugId});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final Size size = MediaQuery.sizeOf(context);
    return Container(
      height: size.height * 434/852,
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
            (size.height * 51/852).pv,
            SvgPicture.asset('assets/icons/svgs/success.svg', height: 98, width: 98, fit: BoxFit.contain),
            (size.height * 24/852).pv,
            Text('Congratulations', style: Palette.lightModeAppTheme.textTheme.titleMedium?.copyWith(
              fontSize: 20,
            ),),
            (size.height * 12/852).pv,
            Text("Your purchase was successful", style: Palette.lightModeAppTheme.textTheme.bodySmall?.copyWith(
              fontSize: 14,
            ),),
            (size.height * 52/852).pv,
            InkWell(onTap: (){
              Navigator.push(context, MaterialPageRoute(builder: (context)=>const HomeScreen()));
            }, child: const ActionButtonContainer(title: 'Continue')),
            (size.height * 21/852).pv,
            InkWell(
              onTap: (){
                showModalBottomSheet(context: context, builder: (context)=>DrugReviewModal(drugId: drugId,));
              },
              child: Text("Give Feedback", style: Palette.lightModeAppTheme.textTheme.bodyMedium?.copyWith(
                fontSize: 16,
                color: Palette.blueText,
                decoration: TextDecoration.underline,
                decorationColor: Palette.blueText,
              ),),
            ),
          ],
        ),
      ),
    );
  }
}