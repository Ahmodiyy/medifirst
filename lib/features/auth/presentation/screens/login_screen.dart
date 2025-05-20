import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:medifirst/core/constants/constants.dart';
import 'package:medifirst/core/theming/palette.dart';
import 'package:medifirst/core/theming/spaces.dart';
import 'package:medifirst/core/widgets/atoms/phone_text_field.dart';
import 'package:medifirst/core/widgets/atoms/underlined_text_field.dart';
import 'package:medifirst/core/widgets/elements/action_button_container.dart';
import 'package:medifirst/core/widgets/elements/outline_button.dart';
import 'package:medifirst/doctor_app/features/home/presentation/doctor_home_screen.dart';
import 'package:medifirst/features/auth/presentation/screens/password_reset-screen.dart';
import 'package:medifirst/features/auth/presentation/screens/privacy_terms_screen.dart';
import 'package:medifirst/features/auth/presentation/screens/sign_up_screen.dart';
import 'package:medifirst/features/home/presentation/screens/home_screen.dart';
import 'package:medifirst/models/healthcare_centre_info.dart';
import 'package:medifirst/models/user_info.dart';
import 'package:medifirst/pharmacy_app/features/pharmacy_home/presentation/screens/pharmacy_home_screen.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../../../../core/widgets/molecules/error_modal.dart';
import '../../../../models/doctor_info.dart';
import '../../controller/auth_controller.dart';

class LoginScreen extends ConsumerStatefulWidget {
  const LoginScreen({super.key});

  @override
  ConsumerState createState() => _LoginScreenState();
}

extension MediaQueryValues on BuildContext {
  double get mediaQueryWidth => MediaQuery.of(this).size.width;
  double get mediaQueryHeight => MediaQuery.of(this).size.height;
}

class _LoginScreenState extends ConsumerState<LoginScreen> {
  late TextEditingController _emailController;
  late TextEditingController _phoneController;
  late TextEditingController _codeController;
  late TextEditingController _pwController;
  late String category;
  bool obscured = true;
  bool isEmail = true;
  bool isLoading = false;


  @override
  void initState(){
    super.initState();
     getCategory();
    _emailController = TextEditingController();
    _pwController = TextEditingController();
    _phoneController = TextEditingController();
    _codeController = TextEditingController(text: '+234');
  }
  void getCategory() async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    setState(() {
      category = prefs.getString(Constants.appTypeKey)!;
    });
  }

  @override
  void dispose() {
    _emailController.dispose();
    _phoneController.dispose();
    _codeController.dispose();
    _pwController.dispose();
    super.dispose();
  }


  Future<void> login({required WidgetRef ref, required BuildContext context}) async {
    setState(() {
      isLoading = true;
    });
    final sharedPrefs = await SharedPreferences.getInstance();
    final category = sharedPrefs.getString(Constants.appTypeKey);
    try {
      AuthController controller = ref.read(authControllerProvider.notifier);
      if (!isEmail &&
          _phoneController.text.isNotEmpty &&
          _codeController.text.isNotEmpty) {
        debugPrint('${_codeController.text}${_phoneController.text}');
        await controller.loginUserWithNumber(
            '${_codeController.text}${_phoneController.text}', context);
        // Navigator.pop(context);
      } else if (isEmail &&
          _emailController.text.isNotEmpty &&
          _pwController.text.isNotEmpty) {
        print('--------------LOGIN IN WITH EMAIL AND PASSWORD---------------');
        await controller.loginUserWithEmail(
            email: _emailController.text, password: _pwController.text);

      }
      switch (category) {
        case Constants.patientCategory:
          ref.listenManual(userProvider, (previous, next) {
            //if (previous == null && next != null) {
              Navigator.pushReplacement(context, MaterialPageRoute(builder: (context) => const HomeScreen()));
            //}
          }, onError: (er, st){
            throw Exception('$er $st');
          }, fireImmediately: true);
          break;
        case Constants.doctorCategory:
          ref.listenManual(doctorProvider, (previous, next) {
            debugPrint('-------------logiing email and password ----------');
           // if (previous == null && next != null) {
              debugPrint('-------------doctor logging in ----------');
              Navigator.pushReplacement(context, MaterialPageRoute(builder: (context) => const DoctorHomeScreen()));
            //}
          }, onError: (er, st){
            throw Exception('$er $st');
          });
          break;
        case Constants.pharmacyCategory:
          ref.listenManual(pharmacyProvider, (previous, next) {
            //if (previous == null && next != null) {
              Navigator.pushReplacement(context, MaterialPageRoute(builder: (context) => const PharmacyHomeScreen()));
            //}
          }, onError: (er, st){
            throw Exception('$er $st');
          }, fireImmediately: true);
          break;
      }
      final SharedPreferences prefs = await SharedPreferences.getInstance();
      prefs.setBool(Constants.isLogin, true);

    } catch (e, st) {
      print("........LOGIN ERROR....... => $e $st");
      FocusScope.of(context).unfocus();
      await Future.delayed(const Duration(milliseconds: 500));
      showModalBottomSheet(
        context: context,
        builder: (context) => SingleChildScrollView(
          child: ErrorModal(
            message: e.toString(),
          ),
        ),
      );
    }
    setState(() {
      isLoading = false;
    });
  }
  void loginWithGoogle({required WidgetRef ref, required BuildContext context}) async {
    setState(() {
      isLoading = true;
    });
    try {
      final controller = ref.read(authControllerProvider.notifier);
      await controller.registerWithGoogle();
      Navigator.pushReplacement(
          context, MaterialPageRoute(builder: (context) => const HomeScreen()));
    } catch (e) {
      showModalBottomSheet(
        context: context,
        builder: (context) => const SingleChildScrollView(
          child: ErrorModal(
            message: 'Please check your network and try again',
          ),
        ),
      );
    }
    setState(() {
      isLoading = false;
    });
  }

  void navigateToSignUpPage(BuildContext context) {
    Navigator.push(
        context, MaterialPageRoute(builder: (context) => const SignUpScreen()));
  }

  @override
  Widget build(BuildContext context) {
    final Size size = MediaQuery.sizeOf(context);
    return Scaffold(
      backgroundColor: Palette.whiteColor,
      appBar: AppBar(
        backgroundColor: Palette.whiteColor,
        elevation: 0,
        leading: IconButton(
          padding: EdgeInsets.zero,
          onPressed: () {
            Navigator.pop(context);
          },
          icon: const Icon(
            Icons.chevron_left,
            color: Palette.blackColor,
            size: 24,
          ),
        ),
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          child: Padding(
            padding: EdgeInsets.symmetric(horizontal: size.width * 16.0 / 393),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              mainAxisSize: MainAxisSize.max,
              children: [
                (size.height * 40 / 852).pv,
                Text(
                  'Log In',
                  style:
                      Palette.lightModeAppTheme.textTheme.titleMedium?.copyWith(
                    fontSize: 36,
                  ),
                ).alignLeft(),
                /**
                (size.height * 7 / 852).pv,
                GestureDetector(
                  onTap: () {
                    setState(() {
                      isEmail = !isEmail;
                    });
                  },
                  child: Text(
                    (isEmail)
                        ? 'Sign in with phone number'
                        : 'Sign in with email',
                    style:
                        Palette.lightModeAppTheme.textTheme.bodySmall?.copyWith(
                      fontSize: 14,
                      color: Palette.blueText,
                    ),
                  ).alignRight(),
                ),
                    **/
                (size.height * 61 / 852).pv,
                (isEmail)
                    ? UnderlinedTextField(
                        controller: _emailController,
                        hint: 'Email',
                        textInputType: TextInputType.emailAddress,
                      )
                    : PhoneTextField(
                        codeController: _codeController,
                        phoneController: _phoneController),
                (size.height * 30 / 852).pv,
                (isEmail)
                    ? UnderlinedTextField(
                        controller: _pwController,
                        hint: 'Password',
                        obscured: obscured,
                        suffix: GestureDetector(
                          onTap: () {
                            setState(() {
                              obscured = !obscured;
                            });
                          },
                          child: (obscured)
                              ? const Icon(
                                  Icons.visibility_off_outlined,
                                  color: Palette.hintTextGray,
                                )
                              : const Icon(
                                  Icons.visibility_outlined,
                                  color: Palette.hintTextGray,
                                ),
                        ),
                      )
                    : (size.height * 29 / 852).pv,
                (size.height * 20 / 852).pv,
                (isEmail)
                    ? InkWell(
                  onTap: () {
                    Navigator.pushReplacement(context, MaterialPageRoute(builder: (context) => const PasswordResetScreen()));
                  },
                      child: Text(
                          'Forgot password?',
                          style: Palette.lightModeAppTheme.textTheme.bodySmall
                              ?.copyWith(
                            color: Palette.blueText,
                            fontSize: 16,
                          ),
                        ).alignLeft(),
                    )
                    : Container(),
                (size.height * 51 / 852).pv,
                InkWell(
                  onTap: () async {
                    await login(ref: ref, context: context);
                  },
                  child: isLoading
                      ? const SizedBox(
                          height: 20,
                          child: CircularProgressIndicator(
                            color: Palette.mainGreen,
                          ),
                        )
                      : const ActionButtonContainer(title: 'Login'),
                ),
                (size.height * 20 / 852).pv,
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(
                      'By, signing up, you agree to MediFirst\'s ',
                      style: Palette.lightModeAppTheme.textTheme.bodySmall
                          ?.copyWith(
                        fontFamily: 'Roboto',
                      ),
                    ),
                    GestureDetector(
                      onTap: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(builder: (context) => const PrivacyTermsScreen()),
                        );
                      },
                      child: Text(
                        'Terms & Conditions',
                        style: Palette.lightModeAppTheme.textTheme.bodySmall
                            ?.copyWith(
                          fontFamily: 'Roboto',
                          color: Palette.blueText,
                        ),
                      ),
                    ),
                  ],
                ),
                (size.height * 40.5 / 852).pv,
                /**
                const OutlineButton(
                    icon: Icon(
                      Icons.apple,
                      color: Palette.blackColor,
                      size: 24,
                    ),
                    label: 'Continue with Apple'),
                (size.height * 8 / 852).pv,
                InkWell(
                  onTap: () => loginWithGoogle(ref: ref, context: context),
                  child: OutlineButton(
                      icon: SvgPicture.asset(
                        'assets/icons/svgs/google.svg',
                        height: 24,
                        width: 24,
                      ),
                      label: 'Continue with Google'),
                ),
                (size.height * 24 / 852).pv,
                    **/
                InkWell(
                  onTap: () {
                    Navigator.pushReplacement(
                        context,
                        MaterialPageRoute(
                            builder: (context) => const SignUpScreen()));
                  },
                  child: Row(
                    mainAxisSize: MainAxisSize.max,
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text(
                        'Don\'t have an account? ',
                        style: Palette.lightModeAppTheme.textTheme.titleSmall
                            ?.copyWith(
                          fontSize: 16,
                          height: 0,
                          color: Palette.blackColor,
                        ),
                      ),
                      Text(
                        'Join',
                        style: Palette.lightModeAppTheme.textTheme.titleSmall
                            ?.copyWith(
                          fontSize: 16,
                          height: 0,
                          color: Palette.blueText,
                          decoration: TextDecoration.underline,
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

// Define a widget that listens to provider changes
class CategoryNavigator extends ConsumerWidget {
  final String category;

  const CategoryNavigator({Key? key, required this.category}) : super(key: key);

  @override
  Widget build(BuildContext context, WidgetRef ref) {
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
    return const SizedBox.shrink(); // Or any other placeholder widget
  }
}
