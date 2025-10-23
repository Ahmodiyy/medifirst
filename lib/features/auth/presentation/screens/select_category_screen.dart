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

final disclaimerSeenProvider = FutureProvider<bool>((ref) async {
  final prefs = await SharedPreferences.getInstance();
  return prefs.getBool('disclaimerSeen') ?? false;
});

class SelectCategoryScreen extends ConsumerStatefulWidget {
  final bool isNewUser;

  const SelectCategoryScreen({super.key, required this.isNewUser});

  @override
  ConsumerState createState() => _SelectCategoryScreenState();
}

class _SelectCategoryScreenState extends ConsumerState<SelectCategoryScreen> {
  bool hasSelected = false;
  String picked = '';

  Future<void> _showDisclaimerDialog(
      BuildContext context, WidgetRef ref) async {
    final prefs = await SharedPreferences.getInstance();
    if (!context.mounted) return;
    await showDialog<void>(
        context: context,
        barrierDismissible: false,
        builder: (_) => AlertDialog(
              backgroundColor: Colors.white,
              shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12)),
              title: const Text(
                'Medical Disclaimer',
                style:
                    TextStyle(color: Colors.black, fontWeight: FontWeight.bold),
              ),
              content: const Text(
                'This app is not a substitute for professional medical advice, '
                'diagnosis or treatment. Always consult a qualified health-care provider.',
                style: TextStyle(color: Colors.black),
              ),
              actions: [
                TextButton(
                  onPressed: () async {
                    await prefs.setBool('disclaimerSeen', true);
                    if (context.mounted) Navigator.of(context).pop();
                  },
                  style: TextButton.styleFrom(
                    foregroundColor: Colors.white,
                    backgroundColor: const Color(0xFF2E7D32), // green 700
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(8),
                    ),
                  ),
                  child: const Text('I understand'),
                ),
              ],
            ));
  }

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
    final disclaimerAsync = ref.watch(disclaimerSeenProvider);

    return disclaimerAsync.when(
      loading: () => const Scaffold(
        body: Center(child: CircularProgressIndicator()),
      ),
      error: (_, __) => const Scaffold(
        body: Center(child: Text('Error loading disclaimer')),
      ),
      data: (seen) {
        if (!seen) {
          WidgetsBinding.instance.addPostFrameCallback((_) {
            _showDisclaimerDialog(context, ref);
          });
        }
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
                    style: Palette.lightModeAppTheme.textTheme.titleMedium
                        ?.copyWith(
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
                    style:
                        Palette.lightModeAppTheme.textTheme.bodySmall?.copyWith(
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
      },
    );
  }
}
