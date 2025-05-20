import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_svg/svg.dart';
import 'package:medifirst/core/theming/spaces.dart';
import 'package:medifirst/core/widgets/elements/action_button_container.dart';

import '../../../../core/theming/palette.dart';

class DoctorSessionEndModal extends ConsumerWidget {
  const DoctorSessionEndModal({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Container(
      height: 465,
      width: double.infinity,
      padding: EdgeInsets.only(bottom: MediaQuery.of(context).viewInsets.bottom),
      color: Palette.smallBodyGray,
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 18).copyWith(bottom: 40, top: 72),
        decoration: const BoxDecoration(
          borderRadius: BorderRadius.only(
              topRight: Radius.circular(20), topLeft: Radius.circular(20)),
          color: Palette.whiteColor,
        ),
        child: Column(
          children: [
            SvgPicture.asset('assets/icons/svgs/success.svg', height: 98, width: 98, fit: BoxFit.contain),
            24.pv,
            Text('Congratulations', style: Palette.lightModeAppTheme.textTheme.titleMedium?.copyWith(
              fontSize: 20,
            ),),
            12.pv,
            Text("Your session has ended", style: Palette.lightModeAppTheme.textTheme.bodySmall?.copyWith(
              fontSize: 14,
            ),),
            64.pv,
            //TODO add function to navigate to prescription screen
            const ActionButtonContainer(title: 'Prescribe Drug', backGroundColor: Palette.highlightGreen, titleColor: Palette.mainGreen,),
            12.pv,
            //TODO add function to go back home
            const ActionButtonContainer(title: 'Done'),
          ],
        ),
      ),
    );
  }
}