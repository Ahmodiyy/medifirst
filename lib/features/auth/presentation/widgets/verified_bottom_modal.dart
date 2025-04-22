import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:medifirst/core/theming/palette.dart';
import 'package:medifirst/core/theming/spaces.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../../../../core/constants/constants.dart';
import '../../../../core/widgets/elements/action_button_container.dart';
import '../../../../doctor_app/features/home/presentation/doctor_home_screen.dart';
import '../../../../pharmacy_app/features/pharmacy_home/presentation/screens/pharmacy_home_screen.dart';
import '../../../home/presentation/screens/home_screen.dart';
import '../../controller/auth_controller.dart';

class VerifiedBottomModal extends ConsumerStatefulWidget {
  const VerifiedBottomModal({super.key});

  @override
  ConsumerState createState() => _VerifiedBottomModalState();
}

class _VerifiedBottomModalState extends ConsumerState<VerifiedBottomModal> {
  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.only(bottom: MediaQuery.of(context).viewInsets.bottom),
      height: 355,
      color: Palette.smallBodyGray,
      child: Container(
        padding: const EdgeInsets.all(18),
        decoration: const BoxDecoration(
          borderRadius: BorderRadius.only(topRight: Radius.circular(20), topLeft: Radius.circular(20)),
          color: Palette.whiteColor,
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          children: [
            SvgPicture.asset('assets/icons/svgs/success.svg', width: 98, height: 98,),
            20.pv,
            Text('Account Verified', style: Palette.lightModeAppTheme.textTheme.titleMedium?.copyWith(fontSize: 20),),
            25.pv,
            Text('Thank you for choosing MediFirst', style: Palette.lightModeAppTheme.textTheme.bodySmall?.copyWith(fontSize: 14),),
            44.pv,
            //TODO add correct function
            InkWell(
              onTap: () {
                navigateToHome();
              },
              child: const ActionButtonContainer(title: 'Continue'),
            ),
          ],
        ),
      ),
    );
  }


  Future<void> navigateToHome() async {
    final sharedPrefs = await SharedPreferences.getInstance();
    final category = sharedPrefs.getString(Constants.appTypeKey);
    switch (category) {
      case Constants.patientCategory:
        ref.listenManual(userProvider, (previous, next) {
          if (previous == null && next != null) {
            Navigator.pushReplacement(context, MaterialPageRoute(builder: (context) => const HomeScreen()));
          }
        }, onError: (er, st){
          throw Exception('$er $st');
        }, fireImmediately: true);
        break;
      case Constants.doctorCategory:
        ref.listenManual(doctorProvider, (previous, next) {
          if (previous == null && next != null) {
            Navigator.pushReplacement(context, MaterialPageRoute(builder: (context) => const DoctorHomeScreen()));
          }
        }, onError: (er, st){
          throw Exception('$er $st');
        });
        break;
      case Constants.pharmacyCategory:
        ref.listenManual(pharmacyProvider, (previous, next) {
          if (previous == null && next != null) {
            Navigator.pushReplacement(context, MaterialPageRoute(builder: (context) => const PharmacyHomeScreen()));
          }
        }, onError: (er, st){
          throw Exception('$er $st');
        }, fireImmediately: true);
        break;
    }
  }
}
