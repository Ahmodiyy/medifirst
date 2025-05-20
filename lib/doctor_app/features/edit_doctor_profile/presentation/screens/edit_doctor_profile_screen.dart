import 'dart:typed_data';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_svg/svg.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:google_places_flutter/model/prediction.dart';
import 'package:medifirst/core/theming/spaces.dart';
import 'package:medifirst/core/widgets/elements/error_text.dart';
import 'package:medifirst/core/widgets/elements/loader.dart';
import 'package:medifirst/doctor_app/features/doctor_settings/controller/doctor_settings_controller.dart';
import 'package:medifirst/doctor_app/features/edit_doctor_profile/presentation/screens/edit_doctor_profile_screen_2.dart';
import 'package:medifirst/features/auth/controller/auth_controller.dart';
import 'package:medifirst/models/doctor_info.dart';

import '../../../../../core/theming/palette.dart';
import '../../../../../core/utils/utils.dart';
import '../../../../../core/widgets/atoms/address_underlined_text_field.dart';
import '../../../../../core/widgets/atoms/phone_text_field.dart';
import '../../../../../core/widgets/atoms/underlined_text_field.dart';
import '../../../../../core/widgets/elements/action_button_container.dart';
import '../../../../../core/widgets/elements/section_heading_text.dart';
import '../../../../../core/widgets/elements/state_and_lga_dropdown.dart';
import '../../../../../core/widgets/molecules/error_modal.dart';

class FirebaseService {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  Future<List<String>> fetchSpecialties() async {
    try {
      QuerySnapshot querySnapshot =
          await _firestore.collection('specialties').get();
      return querySnapshot.docs.map((doc) => doc['name'] as String).toList();
    } catch (e) {
      print('Error fetching specialties: $e');
      throw Exception('Failed to fetch specialties');
    }
  }
}

final firebaseServiceProvider = Provider((ref) => FirebaseService());

final specialtiesProvider =
    FutureProvider.autoDispose<List<String>>((ref) async {
  final firebaseService = ref.watch(firebaseServiceProvider);
  return await firebaseService.fetchSpecialties();
});

class EditDoctorProfileScreen extends ConsumerStatefulWidget {
  const EditDoctorProfileScreen({super.key});

  @override
  ConsumerState createState() => _EditDoctorProfileState();
}

class _EditDoctorProfileState extends ConsumerState<EditDoctorProfileScreen> {
  late TextEditingController _nameController;
  late TextEditingController _surnameController;
  late TextEditingController _ageController;
  late TextEditingController _phoneController;
  late TextEditingController _codeController;
  late TextEditingController _addressController;
  late TextEditingController _stateController;
  late TextEditingController _lgaController;
  late TextEditingController _bioController;
  late TextEditingController _expertiseController;
  late FocusNode _focus;
  bool isLoading = false;
  LatLng latLng = const LatLng(0, 0);
  Uint8List? profilePic;

  @override
  void initState() {
    super.initState();
    _nameController = TextEditingController();
    _surnameController = TextEditingController();
    _ageController = TextEditingController();
    _phoneController = TextEditingController();
    _codeController = TextEditingController();
    _addressController = TextEditingController();
    _stateController = TextEditingController();
    _lgaController = TextEditingController();
    _bioController = TextEditingController();
    _focus = FocusNode();
    _expertiseController = TextEditingController();
  }

  @override
  void dispose() {
    _nameController.dispose();
    _surnameController.dispose();
    _ageController.dispose();
    _phoneController.dispose();
    _codeController.dispose();
    _addressController.dispose();
    _stateController.dispose();
    _lgaController.dispose();
    _bioController.dispose();
    _expertiseController.dispose();
    _focus.dispose();
    super.dispose();
  }

  void selectProfileImage() async {
    profilePic = await pickOneImage();
    debugPrint('------selected doctor picture-----------------');
    setState(() {});
  }

  Future<void> saveDetailsAndContinue(
      {required WidgetRef ref,
      required BuildContext context,
      required DoctorInfo doc,
      required String ogImg}) async {
    try {
      setState(() {
        isLoading = true;
      });
      await ref.read(doctorSettingsControllerProvider).saveFirstPage(
          doc: doc,
          image: profilePic,
          latLng: latLng,
          imageFallback: ogImg,
          firstName: _nameController.text.trim(),
          surname: _surnameController.text.trim(),
          age: _ageController.text.trim(),
          number: '${_codeController.text}${_phoneController.text.trim()}',
          address: _addressController.text,
          state: _stateController.text,
          lga: _lgaController.text,
          profession: _expertiseController.text,
          bio: _bioController.text);
      await ref
          .read(authControllerProvider.notifier)
          .updateUserInfo(ref.read(doctorProvider)!.doctorId);
      if (mounted) {
        Navigator.push(
            context,
            MaterialPageRoute(
                builder: (context) => const EditDoctorProfileScreenTwo()));
      }
    } catch (e) {
      showModalBottomSheet(
          context: context,
          builder: (context) => ErrorModal(message: e.toString()));
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
          data: (doctorInfo) {
            _nameController.text = doctorInfo.name;
            _surnameController.text = doctorInfo.surname;
            _ageController.text =
                (doctorInfo.age != 0) ? doctorInfo.age.toString() : '';
            _phoneController.text = doctorInfo.number;
            _addressController.text = doctorInfo.address;
            _bioController.text = doctorInfo.bio;
            _stateController.text = doctorInfo.state;
            _lgaController.text = doctorInfo.lga;
            _expertiseController.text = doctorInfo.profession;
            return SafeArea(
              child: SingleChildScrollView(
                child: Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 16.0),
                  child: Column(
                    children: [
                      (size.height * 17 / 852).pv,
                      InkWell(
                        onTap: () => selectProfileImage(),
                        child: SizedBox(
                          height: 100,
                          width: 100,
                          child: Stack(
                            clipBehavior: Clip.none,
                            children: [
                              Positioned.fill(
                                child: (profilePic == null)
                                    ? CircleAvatar(
                                        radius: 62,
                                        backgroundColor: Palette.avatarGray,
                                        backgroundImage: NetworkImage(
                                            doctorInfo.doctorImage),
                                      )
                                    : CircleAvatar(
                                        radius: 62,
                                        backgroundColor: Palette.avatarGray,
                                        backgroundImage: MemoryImage(
                                          profilePic!,
                                        )),
                              ),
                              Align(
                                alignment: AlignmentDirectional.bottomEnd,
                                child: CircleAvatar(
                                  radius: 12.5,
                                  backgroundColor: Palette.whiteColor,
                                  child: Center(
                                    child: SvgPicture.asset(
                                        'assets/icons/svgs/camera.svg'),
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                      (size.height * 23 / 852).pv,
                      const SectionHeadingText(heading: 'SET UP PROFILE')
                          .alignLeft(),
                      Row(
                        children: [
                          SizedBox(
                            width: size.width * 170 / 393,
                            child: UnderlinedTextField(
                                controller: _nameController,
                                hint: 'First Name'),
                          ),
                          Flexible(child: Container()),
                          SizedBox(
                            width: size.width * 170 / 393,
                            child: UnderlinedTextField(
                                controller: _surnameController,
                                hint: 'Last Name'),
                          ),
                        ],
                      ),
                      (size.height * 20 / 852).pv,
                      SizedBox(
                        width: size.width * 170 / 393,
                        child: UnderlinedTextField(
                          controller: _ageController,
                          hint: 'Age',
                          textInputType: TextInputType.number,
                        ),
                      ).alignLeft(),
                      (size.height * 20 / 852).pv,
                      PhoneTextField(
                          codeController: _codeController,
                          phoneController: _phoneController),
                      (size.height * 20 / 852).pv,
                      AddressUnderlinedTextField(
                        controller: _addressController,
                        focus: _focus,
                        latLngCallback: (Prediction prediction) {
                          latLng = LatLng(double.parse(prediction.lat!),
                              double.parse(prediction.lng!));
                        },
                        clickCallback: (Prediction prediction) {
                          _addressController.text = prediction.description!;
                          _addressController.selection =
                              TextSelection.fromPosition(TextPosition(
                                  offset: prediction.description!.length));
                        },
                      ),
                      (size.height * 20 / 852).pv,
                      StateAndLGADropdown(
                          stateController: _stateController,
                          lgaController: _lgaController),
                      (size.height * 20 / 852).pv,
                      //UnderlinedTextField(controller: _expertiseController, hint: 'Area of expertise'),
                      //(size.height * 20 / 852).pv,
                      SpecialtiesDropdown(_expertiseController),
                      (size.height * 20 / 852).pv,
                      UnderlinedTextField(
                        controller: _bioController,
                        hint: 'About you',
                        textInputType: TextInputType.text,
                      ),
                      (size.height * 24 / 852).pv,
                      InkWell(
                        onTap: () async {
                          await saveDetailsAndContinue(
                              ref: ref,
                              context: context,
                              doc: doctorInfo,
                              ogImg: doctorInfo.doctorImage);
                        },
                        child: isLoading
                            ? const CircularProgressIndicator(
                                color: Palette.mainGreen,
                              )
                            : const ActionButtonContainer(title: 'Continue'),
                      ),
                    ],
                  ),
                ),
              ),
            );
          },
          error: (er, st) => const ErrorText(error: 'An error occurred'),
          loading: () => const Loader()),
    );
  }
}

class SpecialtiesDropdown extends ConsumerStatefulWidget {
  final TextEditingController controller;

  const SpecialtiesDropdown(this.controller, {super.key});

  @override
  ConsumerState createState() => _SpecialtiesDropdownState();
}

class _SpecialtiesDropdownState extends ConsumerState<SpecialtiesDropdown> {
  @override
  Widget build(BuildContext context) {
    final specialties = ref.watch(specialtiesProvider);

    return specialties.when(
      data: (specialtiesList) {
        if (specialtiesList.isEmpty) {
          return Center(
            child: ElevatedButton.icon(
              onPressed: () => ref.refresh(specialtiesProvider),
              icon: const Icon(Icons.refresh),
              label: const Text("Retry"),
            ),
          );
        }
        return DropdownButton<String>(
          dropdownColor: Palette.whiteColor,
          value: specialtiesList.contains(widget.controller.text)
              ? widget.controller.text
              : null,
          isExpanded: true,
          hint: const Text('Select a specialty',
              style: TextStyle(
                color: Palette.hintTextGray,
              )),
          items: specialtiesList.toSet().map((String specialty) {
            return DropdownMenuItem<String>(
              value: specialty,
              child: Text(
                specialty,
                style: Palette.lightModeAppTheme.textTheme.bodySmall?.copyWith(
                  fontSize: 16,
                  color: Palette.blackColor,
                ),
              ),
            );
          }).toList(),
          onChanged: (String? newValue) {
            setState(
              () {
                // Handle the selection here
                widget.controller.text = newValue ?? '';
                print('Selected specialty: $newValue');
              },
            );
          },
        );
      },
      loading: () => const CircularProgressIndicator(),
      error: (error, stack) => Center(
        child: ElevatedButton.icon(
          onPressed: () => ref.refresh(specialtiesProvider),
          icon: const Icon(Icons.refresh),
          label: const Text("Retry"),
        ),
      ),
    );
  }
}
