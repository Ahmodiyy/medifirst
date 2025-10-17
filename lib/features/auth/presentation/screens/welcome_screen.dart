import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:medifirst/core/theming/palette.dart';
import 'package:medifirst/core/theming/spaces.dart';
import 'package:medifirst/core/widgets/elements/action_button_container.dart';
import 'package:medifirst/features/auth/presentation/screens/select_category_screen.dart';
import 'package:shared_preferences/shared_preferences.dart';

final disclaimerSeenProvider = FutureProvider<bool>((ref) async {
  final prefs = await SharedPreferences.getInstance();
  return prefs.getBool('disclaimerSeen') ?? false;
});

class WelcomeScreen extends ConsumerWidget {
  const WelcomeScreen({super.key});

  void _navigateToSignUp(BuildContext context) {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (_) => const SelectCategoryScreen(isNewUser: true),
      ),
    );
  }

  Future<void> _navigateToLogin(BuildContext context) async {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (_) => const SelectCategoryScreen(isNewUser: false),
      ),
    );
  }

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

  @override
  Widget build(BuildContext context, WidgetRef ref) {
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
          body: Container(
            width: double.infinity,
            height: double.infinity,
            padding: EdgeInsets.all(size.width * 16 / 393)
                .copyWith(bottom: size.height * 76 / 852),
            decoration: const BoxDecoration(
              image: DecorationImage(
                image: AssetImage('assets/images/welcome_bg.png'),
                fit: BoxFit.cover,
                alignment: Alignment.center,
              ),
            ),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.start,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                (size.height * 219 / 852).pv,
                Align(
                  alignment: Alignment.centerLeft,
                  child: SizedBox(
                    width: size.width * 250 / 393,
                    child: RichText(
                      text: TextSpan(
                        text: 'Welcome to Medi',
                        style: Palette.lightModeAppTheme.textTheme.titleMedium
                            ?.copyWith(
                          fontSize: 36,
                          color: Palette.whiteColor,
                        ),
                        children: [
                          TextSpan(
                            text: 'First',
                            style: Palette
                                .lightModeAppTheme.textTheme.titleMedium
                                ?.copyWith(
                              fontSize: 36,
                              color: Palette.redTextColor,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
                (size.height * 16 / 852).pv,
                Align(
                  alignment: Alignment.centerLeft,
                  child: Text(
                    '"Your Health Our Priority"',
                    style: Palette.lightModeAppTheme.textTheme.titleSmall
                        ?.copyWith(
                      fontSize: 20,
                      height: 0.08,
                      color: Palette.whiteColor,
                    ),
                  ),
                ),
                Flexible(child: Container()),
                InkWell(
                  onTap: () => _navigateToSignUp(context),
                  child: const ActionButtonContainer(title: 'Get Started'),
                ),
                (size.height * 16 / 852).pv,
                InkWell(
                  onTap: () async => await _navigateToLogin(context),
                  child: Container(
                    height: size.height * 50 / 852,
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(10),
                      border: Border.all(color: Palette.whiteColor, width: 2),
                    ),
                    child: Center(
                      child: Row(
                        mainAxisSize: MainAxisSize.min,
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Text(
                            'Already have an account? ',
                            style: Palette
                                .lightModeAppTheme.textTheme.titleSmall
                                ?.copyWith(
                              fontSize: 14,
                              height: 0,
                              color: Palette.whiteColor,
                            ),
                          ),
                          Text(
                            'Log In',
                            style: Palette
                                .lightModeAppTheme.textTheme.titleSmall
                                ?.copyWith(
                              fontSize: 14,
                              height: 0,
                              color: Palette.whiteColor,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
        );
      },
    );
  }
}
