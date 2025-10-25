import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:medifirst/core/constants/constants.dart';
import 'package:medifirst/core/theming/palette.dart';
import 'package:medifirst/core/theming/spaces.dart';
import 'package:medifirst/core/widgets/elements/action_button_container.dart';
import 'package:medifirst/features/auth/presentation/screens/login_screen.dart';
import 'package:medifirst/features/auth/presentation/screens/sign_up_screen.dart';
import 'package:medifirst/features/auth/presentation/widgets/outline_category_button.dart';
import 'package:shared_preferences/shared_preferences.dart';

class SelectCategoryScreen extends ConsumerStatefulWidget {
  final bool isNewUser;

  const SelectCategoryScreen({super.key, required this.isNewUser});

  @override
  ConsumerState createState() => _SelectCategoryScreenState();
}

class _SelectCategoryScreenState extends ConsumerState<SelectCategoryScreen> {
  bool hasSelected = false;
  String picked = '';

  void selectCategory(String category) async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    setState(() {
      picked = category;
    });
    prefs.setString(Constants.appTypeKey, category);

    hasSelected = true;
  }

  Future<void> navigateToSignUpPage(BuildContext context, bool isNew) async {
    if (isNew) {
      Navigator.push(context,
          MaterialPageRoute(builder: (context) => const SignUpScreen()));
    } else {
      Navigator.push(context,
          MaterialPageRoute(builder: (context) => const LoginScreen()));
    }
  }

  @override
  Widget build(BuildContext context) {
    final Size size = MediaQuery.sizeOf(context);
    return Scaffold(
      backgroundColor: Palette.whiteColor,
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16.0),
          child: Column(
            children: [
              (size.height * 174 / 852).pv,
              Text(
                (widget.isNewUser) ? 'Registering As' : 'Select Category',
                style:
                    Palette.lightModeAppTheme.textTheme.titleMedium?.copyWith(
                  fontSize: 36,
                ),
              ),
              (size.height * 40 / 852).pv,
              InkWell(
                onTap: () => selectCategory(Constants.patientCategory),
                child: OutlineCategoryButton(
                  label: 'Patient',
                  selected: (picked == Constants.patientCategory),
                ),
              ),
              (size.height * 32 / 852).pv,
              InkWell(
                onTap: () => selectCategory(Constants.doctorCategory),
                child: OutlineCategoryButton(
                  label: 'Doctor',
                  selected: (picked == Constants.doctorCategory),
                ),
              ),
              (size.height * 32 / 852).pv,
              // InkWell(
              //   onTap: () => selectCategory(Constants.pharmacyCategory),
              //   child: OutlineCategoryButton(label: 'Pharmacy', selected: (picked == Constants.pharmacyCategory),),
              // ),
              (size.height * 139 / 852).pv,
              InkWell(
                onTap: () {
                  if (hasSelected) {
                    navigateToSignUpPage(context, widget.isNewUser);
                  }
                },
                child: const ActionButtonContainer(title: 'Continue'),
              ),
              (size.height * 25 / 852).pv,
              Text(
                'Once selected, this setting cannot be changed.',
                textAlign: TextAlign.center,
                style: Palette.lightModeAppTheme.textTheme.bodySmall?.copyWith(
                  height: 0.2,
                  fontFamily: 'Roboto',
                ),
              ),
              (size.height * 62 / 852).pv,
            ],
          ),
        ),
      ),
    );
  }
}
