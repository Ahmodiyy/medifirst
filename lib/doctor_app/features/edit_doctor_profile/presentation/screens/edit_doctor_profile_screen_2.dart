import 'dart:typed_data';

import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:medifirst/core/theming/spaces.dart';
import 'package:medifirst/core/widgets/atoms/underlined_text_field.dart';
import 'package:medifirst/core/widgets/elements/error_text.dart';
import 'package:medifirst/core/widgets/elements/icon_action_button.dart';
import 'package:medifirst/core/widgets/elements/loader.dart';
import 'package:medifirst/doctor_app/features/doctor_settings/controller/doctor_settings_controller.dart';
import 'package:medifirst/doctor_app/features/home/presentation/doctor_home_screen.dart';
import 'package:medifirst/features/auth/controller/auth_controller.dart';
import 'package:medifirst/models/doctor_info.dart';

import '../../../../../core/theming/palette.dart';
import '../../../../../core/widgets/elements/action_button_container.dart';
import '../../../../../core/widgets/molecules/error_modal.dart';
final openProvider = StateProvider<String>((ref) => '');
final closeProvider = StateProvider<String>((ref) => '');

class EditDoctorProfileScreenTwo extends ConsumerStatefulWidget {
  const EditDoctorProfileScreenTwo({super.key});

  @override
  ConsumerState createState() => _EditDoctorProfileScreenTwoState();
}

class _EditDoctorProfileScreenTwoState
    extends ConsumerState<EditDoctorProfileScreenTwo> {
  late TextEditingController _yearsOfExpController;
  late TextEditingController _licenseController;
  late TextEditingController _qualificationsController;
  late TextEditingController _feeController;
  late TextEditingController _openTimeController;
  late TextEditingController _closeTimeController;
  List<Uint8List> certificates = [];
  TimeOfDay initialTime = TimeOfDay.now();
  bool isLoading = false;
  TimeOfDay? openTime;
  TimeOfDay? closeTime;
  List<PlatformFile> _pickedFiles = [];
  bool _isUploading = false;

  Future<void> _pickPDFFiles() async {
    try {
      FilePickerResult? result = await FilePicker.platform.pickFiles(
        type: FileType.custom,
        allowedExtensions: ['pdf'],
        allowMultiple: true,
        withData: true,
      );

      if (result != null) {
       // setState(() {
        _pickedFiles = result.files;
        certificates.clear();
      //});

        for (PlatformFile file in _pickedFiles) {
         // if (file.bytes != null) {
            print('-----pickedFiles----------   ${_pickedFiles.length}');
            certificates.add(file.bytes!);
            print('----------certificate picked is${certificates.length}');
          //}
        }

      } else {
        // User canceled the picker
      }
    } catch (e) {
      print('Error picking files: $e');
    }
  }

  @override
  void initState() {
    super.initState();
    _yearsOfExpController = TextEditingController();
    _licenseController = TextEditingController();
    _qualificationsController = TextEditingController();
    _feeController = TextEditingController();
    _openTimeController = TextEditingController();
    _closeTimeController = TextEditingController();
  }

  @override
  void dispose() {
    _yearsOfExpController.dispose();
    _licenseController.dispose();
    _qualificationsController.dispose();
    _feeController.dispose();
    _openTimeController.dispose();
    _closeTimeController.dispose();
    super.dispose();
  }

  Future<void> saveDetails(
      {required WidgetRef ref,
      required BuildContext context,
      required DoctorInfo doc,
      required String uid}) async {
    try {
      setState(() {
        isLoading = true;
      });
      await ref.read(doctorSettingsControllerProvider).saveSecondPage(
          doc: doc,
          openTime: openTime ?? doc.openingHours,
          closeTime: closeTime ?? doc.closingHours,
          yearsOfExp:
              _yearsOfExpController.text,
          licenseNo: _licenseController.text,
          qualifications: _qualificationsController.text,
          consultationFee:
              _feeController.text,
          certificateImage: certificates);
      await ref.read(authControllerProvider.notifier).updateUserInfo(ref.read(doctorProvider)!.doctorId);
      if (mounted) {
        Navigator.pushReplacement(
            context,
            MaterialPageRoute(
                builder: (context) =>
                const DoctorHomeScreen()));
      }
    } catch (e) {
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
    final doctor = ref.read(doctorProvider);
    return Scaffold(
      backgroundColor: Palette.whiteColor,
      appBar: AppBar(
        backgroundColor: Palette.whiteColor,
        centerTitle: true,
        automaticallyImplyLeading: false,
        title: Text(
          'My Profile',
          style: Palette.lightModeAppTheme.textTheme.bodySmall?.copyWith(
            fontSize: 20,
          ),
        ),
      ),
      body: ref.watch(doctorSettingsInfoProvider(doctor!.doctorId)).when(
          data: (doctorData) {
            _yearsOfExpController.text = (doctorData.yearsOfExperience != 0)?
                doctorData.yearsOfExperience.toString() : '';
            _licenseController.text = doctorData.licenseNumber;
            _qualificationsController.text = doctorData.qualifications;
            _feeController.text = (doctorData.consultationFee!=0)?doctorData.consultationFee.toString():'';
            _openTimeController.text = (doctorData.openingHours.period == DayPeriod.am)?'${doctorData.openingHours.hour}:${doctorData.openingHours.minute.toString().padLeft(2, '0')}am':'${doctorData.openingHours.hour}:${doctorData.openingHours.minute.toString().padLeft(2, '0')}pm';
            _closeTimeController.text = (doctorData.closingHours.period == DayPeriod.am)?'${doctorData.closingHours.hour}:${doctorData.closingHours.minute.toString().padLeft(2, '0')}am':'${doctorData.closingHours.hour}:${doctorData.closingHours.minute.toString().padLeft(2, '0')}pm';
            openTime = doctorData.openingHours;
            closeTime = doctorData.closingHours;

            WidgetsBinding.instance.addPostFrameCallback((timeStamp) {
              ref.read(openProvider.notifier).state =  _openTimeController.text;
              ref.read(closeProvider.notifier).state =  _closeTimeController.text;
            },);
            return SafeArea(
              child: SingleChildScrollView(
                child: Padding(
                  padding:
                      EdgeInsets.symmetric(horizontal: size.width * 16.0 / 393)
                          .copyWith(bottom: size.height * 18 / 852),
                  child: Column(
                    children: [
                      (size.height * 20 / 852).pv,
                      SizedBox(
                        width: size.width * 170 / 393,
                        child: UnderlinedTextField(
                          controller: _yearsOfExpController,
                          hint: 'Years of exp',
                          textInputType: TextInputType.number,
                        ),
                      ).alignLeft(),
                      (size.height * 20 / 852).pv,
                      UnderlinedTextField(
                          controller: _licenseController,
                          hint: 'License number'),
                      (size.height * 20 / 852).pv,
                      UnderlinedTextField(
                          controller: _qualificationsController,
                          hint: 'Qualification(s)'),
                      (size.height * 24 / 852).pv,
                      InkWell(
                        onTap: () {
                         _pickPDFFiles();
                        },
                        child: const IconActionButtonContainer(
                          title: 'Upload Certificate',
                          svgURL: 'assets/icons/svgs/upload.svg',
                          titleColor: Palette.blackColor,
                          backGroundColor: Palette.dividerGray,
                        ),
                      ),
                      (size.height * 7 / 852).pv,
                      Text(
                        'PDF format only',
                        style: Palette.lightModeAppTheme.textTheme.bodySmall
                            ?.copyWith(
                          fontSize: 10,
                        ),
                      ),
                      (size.height * 20 / 852).pv,
                      UnderlinedTextField(
                          controller: _feeController, hint: 'Consultation Fee'),
                      (size.height * 20 / 852).pv,
                      Row(
                        children: [
                          GestureDetector(
                            onTap: () async {
                              TimeOfDay initialTime = TimeOfDay.now(); // Set an initial time
                              TimeOfDay? pickedTime = await showTimePicker(
                                context: context,
                                initialTime: initialTime,
                              );
                              if (pickedTime != null) {

                                  openTime = pickedTime;
                                  _openTimeController.text= pickedTime.format(context);
                                  ref.read(openProvider.notifier).update((state) => _openTimeController.text,);
                              }
                            },
                            child: AbsorbPointer(
                              child: SizedBox(
                                width: size.width * 170 / 393,
                                child: Consumer(
                                  builder: (context, ref, child) {
                                    final message = ref.watch(openProvider);
                                    debugPrint(_openTimeController.text);
                                    return UnderlinedTextField(
                                        controller: _openTimeController,
                                        readOnly: true,
                                        hint: 'Open Time');
                                  },
                                ),
                              ),
                            ),
                          ),
                          Flexible(child: Container()),
                          GestureDetector(
                            onTap: () async {
                              TimeOfDay? pickedTime = await showTimePicker(
                                context: context,
                                initialTime: initialTime,
                              );
                              if (pickedTime != null) {
                                closeTime = pickedTime;
                                _closeTimeController.text = pickedTime.format(context);
                                //'${closeTime!.hour}:${closeTime!.minute} ${closeTime!.period}';
                              }
                            },
                            child: AbsorbPointer(
                              child: SizedBox(
                                width: size.width * 170 / 393,
                                child: Consumer(builder: (context, ref, child) {
                                  final close = ref.watch(closeProvider);
                                  return UnderlinedTextField(
                                      controller: _closeTimeController,
                                      readOnly: true,
                                      hint: 'Close Time');
                                },)
                              ),
                            ),
                          ),
                        ],
                      ),
                      (size.height * 180 / 852).pv,
                      InkWell(
                        onTap: () async {
                          await saveDetails(
                              ref: ref,
                              context: context,
                              doc: doctorData,
                              uid: doctorData.doctorId);
                        },
                        child:  isLoading? const CircularProgressIndicator(color: Palette.mainGreen,): const ActionButtonContainer(title: 'Save'),
                      ),
                    ],
                  ),
                ),
              ),
            );
          },
          error: (err, st) => const ErrorText(error: 'An error occurred'),
          loading: () => const Loader()),
    );
  }
}
