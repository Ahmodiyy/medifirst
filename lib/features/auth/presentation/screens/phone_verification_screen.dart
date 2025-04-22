import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:medifirst/core/theming/spaces.dart';
import 'package:medifirst/core/widgets/atoms/otp_row.dart';
import 'package:medifirst/features/auth/controller/auth_controller.dart';
import 'package:medifirst/features/auth/presentation/screens/sign_up_screen.dart';

import '../../../../core/theming/palette.dart';
import '../../../../core/widgets/elements/action_button_container.dart';

class PhoneVerificationScreen extends ConsumerStatefulWidget {
  final String otp;
  final String number;
  final bool isFromSignUp;
  final String? name;
  final String? surname;
  const PhoneVerificationScreen({super.key, required this.otp, required this.isFromSignUp, required this.number, this.name, this.surname});

  @override
  ConsumerState createState() => _PhoneVerificationScreenState();
}

class _PhoneVerificationScreenState
    extends ConsumerState<PhoneVerificationScreen> {
  late TextEditingController _controllerOne;
  late TextEditingController _controllerTwo;
  late TextEditingController _controllerThree;
  late TextEditingController _controllerFour;
  late TextEditingController _controllerFive;
  late TextEditingController _controllerSix;
  late FocusNode focusNodeOne;
  late FocusNode focusNodeTwo;
  late FocusNode focusNodeThree;
  late FocusNode focusNodeFour;
  late FocusNode focusNodeFive;
  late FocusNode focusNodeSix;

  bool isLoading = false;
  @override
  void initState() {
    super.initState();
    _controllerOne = TextEditingController();
    _controllerTwo = TextEditingController();
    _controllerThree = TextEditingController();
    _controllerFour = TextEditingController();
    _controllerFive = TextEditingController();
    _controllerSix = TextEditingController();
    focusNodeOne = FocusNode();
    focusNodeTwo = FocusNode();
    focusNodeThree = FocusNode();
    focusNodeFour = FocusNode();
    focusNodeFive = FocusNode();
    focusNodeSix = FocusNode();
  }

  @override
  void dispose() {
    _controllerOne.dispose();
    _controllerTwo.dispose();
    _controllerThree.dispose();
    _controllerFour.dispose();
    _controllerFive.dispose();
    _controllerSix.dispose();
    focusNodeOne.dispose();
    focusNodeTwo.dispose();
    focusNodeThree.dispose();
    focusNodeFour.dispose();
    focusNodeFive.dispose();
    focusNodeSix.dispose();
    super.dispose();
  }
  //TODO add login and register functions and add
  Future<void> verifyCodeFromSignUp(WidgetRef ref, BuildContext context) async{
    if(_controllerOne.text.isNotEmpty &&
        _controllerTwo.text.isNotEmpty &&
        _controllerThree.text.isNotEmpty &&
        _controllerFour.text.isNotEmpty &&
        _controllerFive.text.isNotEmpty &&
        _controllerSix.text.isNotEmpty){
      final String code = _controllerOne.text +
          _controllerTwo.text +
          _controllerThree.text +
          _controllerFour.text +
          _controllerFive.text +
          _controllerSix.text;
      await ref.read(authControllerProvider.notifier).verifyOTPFromSignUp(context,
          widget.otp, code, widget.number, widget.name!, widget.surname!);
    }
  }

  Future<void> verifyCodeFromLogin(WidgetRef ref, BuildContext context)async {
    if(_controllerOne.text.isNotEmpty &&
        _controllerTwo.text.isNotEmpty &&
        _controllerThree.text.isNotEmpty &&
        _controllerFour.text.isNotEmpty &&
        _controllerFive.text.isNotEmpty &&
        _controllerSix.text.isNotEmpty){
      final String code = _controllerOne.text +
          _controllerTwo.text +
          _controllerThree.text +
          _controllerFour.text +
          _controllerFive.text +
          _controllerSix.text;
      await ref.read(authControllerProvider.notifier).verifyOTPFromLogin(context, widget.otp, code, widget.number);
    }
  }

  @override
  Widget build(BuildContext context) {
    WidgetsBinding.instance.addPostFrameCallback((timeStamp) {
      ref.read(signUpLoadingProvider.notifier).update((state) => false,);
    },);

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
            padding: const EdgeInsets.symmetric(horizontal: 16.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                40.pv,
                Text(
                  'Verification',
                  style: Palette.lightModeAppTheme.textTheme.titleMedium?.copyWith(
                    fontSize: 36,
                  ),
                ).alignLeft(),
                16.pv,
                SizedBox(
                  width: 335,
                  child: Text.rich(
                    TextSpan(
                      children: [
                        TextSpan(
                          text: 'Enter the One-Time Password sent to',
                          style: Palette.lightModeAppTheme.textTheme.bodySmall?.copyWith(
                            fontSize: 16,
                          ),
                        ),
                        TextSpan(
                          text: ' ',
                          style: Palette.lightModeAppTheme.textTheme.titleMedium,
                        ),
                        //TODO add correct number
                        TextSpan(
                          text: widget.number,
                          style:Palette.lightModeAppTheme.textTheme.titleLarge?.copyWith(
                            fontSize: 16,
                            decoration: TextDecoration.underline,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
                57.pv,
                OTPRow(controller1: _controllerOne, controller2: _controllerTwo, controller3: _controllerThree, controller4: _controllerFour, controller5: _controllerFive, controller6: _controllerSix, focusNode1: focusNodeOne, focusNode2: focusNodeTwo, focusNode3: focusNodeThree, focusNode4: focusNodeFour, focusNode5: focusNodeFive, focusNode6: focusNodeSix),
                16.pv,
                Text.rich(
                  TextSpan(
                    children: [
                      TextSpan(
                        text: 'Didn’t get the code? ',
                        style: Palette.lightModeAppTheme.textTheme.bodySmall!.copyWith(
                            fontSize: 14,
                          ),
                      ),
                      TextSpan(
                        text: 'Resend code',
                        style: Palette.lightModeAppTheme.textTheme.titleSmall!.copyWith(
                          fontSize: 14,
                          color: Palette.blueText,
                        ),
                      recognizer:   TapGestureRecognizer()
                        ..onTap = () {
                          Navigator.pop(context);
                        },
                      ),
                    ],
                  ),
                ),
                49.pv,
                //TODO add correct function
                InkWell(
                  onTap: () async{
                    setState(() {
                      isLoading = true;
                    });
                    if(widget.isFromSignUp){
                      await verifyCodeFromSignUp(ref, context);
                    }else{
                      await verifyCodeFromLogin(ref, context);
                    }
                    setState(() {
                      isLoading = false;
                    });
                  },
                  child:isLoading
                      ? const CircularProgressIndicator(
                        color: Palette.mainGreen,
                      )
                      :  const ActionButtonContainer(title: 'Continue'),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
