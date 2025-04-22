import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:medifirst/core/theming/spaces.dart';
import 'package:medifirst/core/widgets/elements/error_text.dart';
import 'package:medifirst/core/widgets/elements/loader.dart';
import 'package:medifirst/features/auth/repository/auth_repository.dart';
import 'package:medifirst/features/home/presentation/screens/home_screen.dart';
import 'package:medifirst/features/settings/controller/settings_controller.dart';
import 'package:medifirst/models/user_info.dart';

import '../../../../core/theming/palette.dart';
import '../../../../core/widgets/atoms/underlined_text_field.dart';
import '../../../../core/widgets/elements/action_button_container.dart';
import '../../../../core/widgets/molecules/error_modal.dart';
import '../../../auth/controller/auth_controller.dart';

class EditProfileScreenTwo extends ConsumerStatefulWidget {
  const EditProfileScreenTwo({super.key});

  @override
  ConsumerState createState() => _EditProfileScreenTwoState();
}

class _EditProfileScreenTwoState extends ConsumerState<EditProfileScreenTwo> {
  late TextEditingController _bpController;
  late TextEditingController _weightController;
  late TextEditingController _heightController;
  late TextEditingController _bmiController;
  late TextEditingController _genotypeController;
  late TextEditingController _bloodGroupController;
  late TextEditingController _historyController;
  late TextEditingController _diseaseController;
  late TextEditingController _medicalDisorderController;
  bool isLoading = false;

  @override
  void initState() {
    super.initState();
    _bpController = TextEditingController();
    _weightController = TextEditingController();
    _heightController = TextEditingController();
    _bmiController = TextEditingController();
    _genotypeController = TextEditingController();
    _bloodGroupController = TextEditingController();
    _historyController = TextEditingController();
    _diseaseController = TextEditingController();
    _medicalDisorderController = TextEditingController();
  }

  @override
  void dispose() {
    _bpController.dispose();
    _weightController.dispose();
    _heightController.dispose();
    _bmiController.dispose();
    _genotypeController.dispose();
    _bloodGroupController.dispose();
    _historyController.dispose();
    _diseaseController.dispose();
    _medicalDisorderController.dispose();
    super.dispose();
  }

  void saveDetails(
      {required WidgetRef ref,
        required UserInfoModel user,
        required String uid,
      required BuildContext context,}) async {
    try {
      setState(() {
        isLoading = true;
      });
      final controller = ref.read(settingsControllerProvider);
      await controller.saveSecondPage(
        user: user,
        uid: uid,
        bp: _bpController.text,
        weight: _weightController.text,
        height: _heightController.text,
        bmi: _bmiController.text,
        surgicalHistory: _historyController.text,
        genotype: _genotypeController.text,
        bloodGroup: _bloodGroupController.text,
        geneticDisorder: _diseaseController.text,
        medicalDisorder: _medicalDisorderController.text,
      );
      await ref.read(authControllerProvider.notifier).updateUserInfo(ref.read(userProvider)!.uid);
      Navigator.pushReplacement(context, MaterialPageRoute(builder: (context)=>const HomeScreen()));

    } catch (e, st) {
      print('${e.toString()} ${st.toString()}');
      showModalBottomSheet(
          context: context,
          builder: (context) => const ErrorModal(message: 'An error occurred'));
    }
    setState(() {
      isLoading = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    final Size size = MediaQuery.sizeOf(context);
    final user = ref.watch(userProvider);
    return ref.watch(userSettingsInfoProvider(user!.uid)).when(
          data: (userData) {
            _bpController.text = userData.bloodPressure;
            _weightController.text = userData.weight == 0? '' : userData.weight.toString();
            _heightController.text = userData.height == 0? '' : userData.height.toString();
            _bmiController.text =userData.bmi == 0? '' :  userData.bmi.toString();
            _genotypeController.text = userData.genotype;
            _bloodGroupController.text = userData.bloodGroup;
            _historyController.text = userData.surgicalHist;
            _diseaseController.text = userData.geneticDisorder;
            _medicalDisorderController.text = userData.medicalDisorder;
            return Scaffold(
              backgroundColor: Palette.whiteColor,
              appBar: AppBar(
                backgroundColor: Palette.whiteColor,
                centerTitle: true,
                automaticallyImplyLeading: false,
                title: Text(
                  'My Profile',
                  style:
                      Palette.lightModeAppTheme.textTheme.bodySmall?.copyWith(
                    fontSize: 20,
                  ),
                ),
              ),
              body: SafeArea(
                  child: SingleChildScrollView(
                child: Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 16.0),
                  child: Column(
                    children: [
                      (size.height * 43 / 852).pv,
                      Row(
                        children: [
                          SizedBox(
                            width: 156,
                            child: UnderlinedTextField(
                              controller: _bpController,
                              hint: 'Blood Pressure',
                            ),
                          ),
                          Flexible(child: Container()),
                          SizedBox(
                            width: 156,
                            child: UnderlinedTextField(
                                controller: _weightController,
                                textInputType: TextInputType.number,
                                hint: 'Body Weight'),
                          ),
                        ],
                      ),
                      (size.height * 20 / 852).pv,
                      Row(
                        children: [
                          SizedBox(
                            width: (size.width * 170 / 393),
                            child: UnderlinedTextField(
                              controller: _heightController,
                              hint: 'Height',
                              textInputType: TextInputType.number,
                              suffix: Text(
                                'cm',
                                style: Palette
                                    .lightModeAppTheme.textTheme.bodySmall
                                    ?.copyWith(
                                  color: Palette.hintTextGray,
                                  fontSize: 14,
                                ),
                              ),
                            ),
                          ),
                          Flexible(child: Container()),
                          SizedBox(
                            width: (size.width * 170 / 393),
                            child: UnderlinedTextField(
                                controller: _bmiController,
                                textInputType: TextInputType.number,
                                hint: 'Body Mass Index'),
                          ),
                        ],
                      ),
                      (size.height * 20 / 852).pv,
                      UnderlinedTextField(
                          controller: _historyController,
                          hint: 'Surgical History'),
                      (size.height * 20 / 852).pv,
                      //TODO add suffix icons
                      Row(
                        children: [
                          SizedBox(
                            width: size.width * 170 / 393,
                            child: UnderlinedTextField(
                              controller: _genotypeController,
                              hint: 'Genotype',
                              cap: TextCapitalization.characters,
                            ),
                          ),
                          Flexible(child: Container()),
                          SizedBox(
                            width: size.width * 170 / 393,
                            child: UnderlinedTextField(
                                controller: _bloodGroupController,
                                hint: 'Blood Group'),
                          ),
                        ],
                      ),
                      (size.height * 20 / 852).pv,
                      UnderlinedTextField(
                          controller: _diseaseController,
                          hint: 'Any Congenital Disease'),
                      (size.height * 20 / 852).pv,
                      UnderlinedTextField(
                        controller: _medicalDisorderController,
                        hint: 'Any Medical Disorder',
                      ),
                      (size.height * 20 / 852).pv,
                      Align(
                        alignment: Alignment.bottomCenter,
                        child: InkWell(
                          onTap: () {
                            saveDetails(ref: ref,
                                context: context,
                                user: user,
                                uid: user.uid);
                          },
                          child: isLoading? CircularProgressIndicator(color: Palette.mainGreen,): const ActionButtonContainer(title: 'Save'),
                        ),
                      ),
                    ],
                  ),
                ),
              )),
            );
          },
          error: (er, st) {
            print('$er => $st');
            return const ErrorText(error: 'An error occurred loading this page');
          },
          loading: () => const Loader(),
        );
  }
}
