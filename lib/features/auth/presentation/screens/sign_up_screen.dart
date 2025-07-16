import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:intl/intl.dart';
import 'package:medifirst/core/theming/palette.dart';
import 'package:medifirst/core/theming/spaces.dart';
import 'package:medifirst/core/widgets/atoms/underlined_text_field.dart';
import 'package:medifirst/features/auth/controller/auth_controller.dart';
import 'package:medifirst/features/auth/presentation/screens/login_screen.dart';
import 'package:medifirst/features/auth/presentation/screens/privacy_terms_screen.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../../../../core/constants/constants.dart';
import '../../../../core/widgets/atoms/phone_text_field.dart';
import '../../../../core/widgets/elements/action_button_container.dart';
import '../../../../core/widgets/molecules/error_modal.dart';
import '../../../../doctor_app/features/edit_doctor_profile/presentation/screens/edit_doctor_profile_screen.dart';
import '../../../../doctor_app/features/home/presentation/doctor_home_screen.dart';
import '../../../home/presentation/screens/home_screen.dart';

final signUpLoadingProvider = StateProvider<bool>((ref) {
  return false;
});

class SignUpScreen extends ConsumerStatefulWidget {
  const SignUpScreen({super.key});

  @override
  ConsumerState createState() => _SignUpScreenState();
}

class _SignUpScreenState extends ConsumerState<SignUpScreen> {
  late TextEditingController _nameController;
  late TextEditingController _surnameController;
  late TextEditingController _emailController;
  late TextEditingController _phoneController;
  late TextEditingController _codeController;
  late TextEditingController _pwController;
  late TextEditingController _licenseController;
  late TextEditingController _experienceController;
  late TextEditingController _expertiseController;
  String category = '';
  DateTime? _selectedDate = DateTime.now();
  bool useEmail = true;
  bool obscured = true;
  bool isLoading = false;

  Future<void> createAccount(
      {required WidgetRef ref, required BuildContext context}) async {
    final sharedPrefs = await SharedPreferences.getInstance();
    final category = sharedPrefs.getString(Constants.appTypeKey);
    if (category == Constants.doctorCategory) {
      if (_licenseController.text.isEmpty ||
          _experienceController.text.isEmpty ||
          _selectedDate == null ||
          _expertiseController.text.isEmpty) {
        return;
      }
    }
    ref.read(signUpLoadingProvider.notifier).update(
          (state) => true,
        );

    try {
      AuthController controller = ref.read(authControllerProvider.notifier);
      if (useEmail &&
          _emailController.text.isNotEmpty &&
          _pwController.text.isNotEmpty &&
          _nameController.text.isNotEmpty &&
          _surnameController.text.isNotEmpty) {
        if (category == Constants.doctorCategory) {
          await controller.registerWithEmail(
              _nameController.text,
              _surnameController.text,
              _emailController.text,
              _pwController.text,
              license: _licenseController.text,
              experience: int.tryParse(_experienceController.text),
              expertise: _expertiseController.text,
              licenseExpiration: _selectedDate);
          await navigateToHome();
        } else {
          await controller.registerWithEmail(
              _nameController.text,
              _surnameController.text,
              _emailController.text,
              _pwController.text);
          await navigateToHome();
        }
      }
      final SharedPreferences prefs = await SharedPreferences.getInstance();
      prefs.setBool(Constants.isLogin, true);
    } catch (e) {
      debugPrint('.....sign up error.....  ${e.toString()}');
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
    ref.read(signUpLoadingProvider.notifier).update(
          (state) => false,
        );
  }

  Future<void> navigateToHome() async {
    final sharedPrefs = await SharedPreferences.getInstance();
    final category = sharedPrefs.getString(Constants.appTypeKey);

    switch (category) {
      case Constants.patientCategory:
        ref.listenManual(userProvider, (previous, next) {
          Navigator.push(context,
              MaterialPageRoute(builder: (context) => const HomeScreen()));
        }, onError: (er, st) {
          throw Exception('$er $st');
        }, fireImmediately: true);
        break;
      case Constants.doctorCategory:
        ref.listenManual(doctorProvider, (previous, next) {
          Navigator.push(
              context,
              MaterialPageRoute(
                  builder: (context) => const DoctorHomeScreen()));
        }, onError: (er, st) {
          throw Exception('$er $st');
        });
        break;
    }
  }

  void signUpWithGoogle(WidgetRef ref) async {
    ref.read(signUpLoadingProvider.notifier).update(
          (state) => true,
        );
    try {
      if (category == Constants.doctorCategory) {
        await ref.read(authControllerProvider.notifier).registerWithGoogle(
            license: _licenseController.text,
            experience: int.tryParse(_expertiseController.text),
            expertise: _expertiseController.text,
            licenseExpiration: _selectedDate);
        await navigateToHome();
      } else {
        await ref.read(authControllerProvider.notifier).registerWithGoogle();
        await navigateToHome();
      }
    } catch (e) {
      showModalBottomSheet(
        context: context,
        builder: (context) => SingleChildScrollView(
          child: ErrorModal(
            message: e.toString(),
          ),
        ),
      );
    }
    ref.read(signUpLoadingProvider.notifier).update(
          (state) => false,
        );
  }

  void navigateToLoginPage(BuildContext context) {
    Navigator.push(
        context, MaterialPageRoute(builder: (context) => const LoginScreen()));
  }

  @override
  void initState() {
    super.initState();
    getCategory();
    _nameController = TextEditingController();
    _surnameController = TextEditingController();
    _emailController = TextEditingController();
    _pwController = TextEditingController();
    _phoneController = TextEditingController();
    _codeController = TextEditingController(text: '+234');
    _licenseController = TextEditingController();
    _experienceController = TextEditingController();
    _expertiseController = TextEditingController();
  }

  @override
  void dispose() {
    _nameController.dispose();
    _surnameController.dispose();
    _emailController.dispose();
    _phoneController.dispose();
    _codeController.dispose();
    _pwController.dispose();
    _licenseController.dispose();
    _experienceController.dispose();
    _expertiseController.dispose();
    super.dispose();
  }

  void getCategory() async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    setState(() {
      category = prefs.getString(Constants.appTypeKey)!;
    });
  }

  @override
  Widget build(BuildContext context) {
    final Size size = MediaQuery.sizeOf(context);
    final isLoading = ref.watch(signUpLoadingProvider);
    return Scaffold(
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
            padding:
                EdgeInsets.symmetric(horizontal: (size.width * 16.0 / 393)),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Text(
                  'Sign Up',
                  style:
                      Palette.lightModeAppTheme.textTheme.titleMedium?.copyWith(
                    fontSize: 36,
                  ),
                ).alignLeft(),
                /**
                    (size.height * 47 / 852).pv,
                    GestureDetector(
                    onTap: () {
                    setState(() {
                    useEmail = !useEmail;
                    });
                    },
                    child: Text(
                    (useEmail)
                    ? 'Sign in with phone number'
                    : 'Sign in with email',
                    style:
                    Palette.lightModeAppTheme.textTheme.bodySmall?.copyWith(
                    fontSize: 14,
                    color: Palette.blueText,
                    ),
                    ),
                    ).alignRight(),
                 **/
                (size.height * 21 / 852).pv,
                Row(
                  children: [
                    SizedBox(
                      width: (size.width * 175 / 393),
                      child: UnderlinedTextField(
                        controller: _nameController,
                        hint: 'First Name',
                        cap: TextCapitalization.words,
                      ),
                    ),
                    Flexible(child: Container()),
                    SizedBox(
                      width: (size.width * 175 / 393),
                      child: UnderlinedTextField(
                        controller: _surnameController,
                        hint: 'Last Name',
                        cap: TextCapitalization.words,
                      ),
                    ),
                  ],
                ),
                (size.height * 30 / 852).pv,
                //more info for doctor
                (category == Constants.doctorCategory)
                    ? Row(
                        children: [
                          SizedBox(
                            width: (size.width * 175 / 393),
                            child: UnderlinedTextField(
                              controller: _licenseController,
                              hint: 'License number',
                              cap: TextCapitalization.words,
                              textInputType: TextInputType.text,
                            ),
                          ),
                          Flexible(child: Container()),
                          SizedBox(
                            width: (size.width * 175 / 393),
                            child: UnderlinedTextField(
                              controller: _experienceController,
                              hint: 'Year of experience',
                              cap: TextCapitalization.words,
                              textInputType: TextInputType.number,
                            ),
                          ),
                        ],
                      )
                    : Container(),
                (category == Constants.doctorCategory)
                    ? (size.height * 30 / 852).pv
                    : Container(),
                (category == Constants.doctorCategory)
                    ? Row(
                        children: [
                          const Flexible(
                              child: Text(
                            "License expiration date",
                            style: TextStyle(
                              color: Palette.hintTextGray,
                            ),
                          )),
                          const Spacer(),
                          InkWell(
                            onTap: () async {
                              DateTime? getDate = await showDatePicker(
                                  context: context,
                                  firstDate: DateTime.now(),
                                  lastDate: DateTime(2030, 12, 31, 24));
                              if (getDate != null) {
                                _selectedDate = getDate;
                                setState(() {});
                              }
                            },
                            child: Row(
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                Text(
                                  DateFormat.yMd().format(_selectedDate!),
                                  style: Palette
                                      .lightModeAppTheme.textTheme.bodySmall
                                      ?.copyWith(
                                    color: Palette.highlightTextGray,
                                    height: 0.15,
                                    fontSize: 14,
                                  ),
                                ),
                                (size.width * 16 / 393).ph,
                                SvgPicture.asset(
                                  'assets/icons/svgs/calendar.svg',
                                  height: 24,
                                  width: 24,
                                ),
                              ],
                            ),
                          ),
                        ],
                      )
                    : Container(),
                (category == Constants.doctorCategory)
                    ? (size.height * 30 / 852).pv
                    : Container(),
                (category == Constants.doctorCategory)
                    ? SpecialtiesDropdown(_expertiseController)
                    : Container(),
                (category == Constants.doctorCategory)
                    ? (size.height * 30 / 852).pv
                    : Container(),
                (useEmail)
                    ? UnderlinedTextField(
                        controller: _emailController,
                        hint: 'Email',
                        textInputType: TextInputType.emailAddress,
                      )
                    : PhoneTextField(
                        codeController: _codeController,
                        phoneController: _phoneController,
                      ),
                (size.height * 30 / 852).pv,
                (useEmail)
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
                (size.height * 36 / 852).pv,
                InkWell(
                  onTap: () async {
                    await createAccount(ref: ref, context: context);
                  },
                  child: isLoading
                      ? const SizedBox(
                          height: 20,
                          child: CircularProgressIndicator(
                            color: Palette.mainGreen,
                          ),
                        )
                      : const ActionButtonContainer(title: 'Register'),
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
                          MaterialPageRoute(
                              builder: (context) => const PrivacyTermsScreen()),
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
                    onTap: () => signUpWithGoogle(ref),
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
                  onTap: () => navigateToLoginPage(context),
                  child: Row(
                    mainAxisSize: MainAxisSize.max,
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text(
                        'Already have an account? ',
                        style: Palette.lightModeAppTheme.textTheme.titleSmall
                            ?.copyWith(
                          fontSize: 16,
                          height: 0,
                          color: Palette.blackColor,
                        ),
                      ),
                      Text(
                        'Log In',
                        style: Palette.lightModeAppTheme.textTheme.titleSmall
                            ?.copyWith(
                          fontSize: 16,
                          height: 0,
                          color: Palette.blueText,
                          decorationColor: Palette.blueText,
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
