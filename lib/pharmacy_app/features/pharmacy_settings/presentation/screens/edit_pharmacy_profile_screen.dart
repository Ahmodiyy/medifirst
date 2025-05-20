import 'dart:typed_data';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_svg/svg.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:google_places_flutter/model/prediction.dart';
import 'package:medifirst/core/theming/spaces.dart';
import 'package:medifirst/core/widgets/atoms/address_underlined_text_field.dart';
import 'package:medifirst/core/widgets/molecules/error_modal.dart';
import 'package:medifirst/features/auth/controller/auth_controller.dart';
import 'package:medifirst/models/healthcare_centre_info.dart';
import 'package:medifirst/pharmacy_app/features/pharmacy_settings/controller/pharmacy_settings_controller.dart';
import 'package:nigerian_states_and_lga/nigerian_states_and_lga.dart';

import '../../../../../core/theming/palette.dart';
import '../../../../../core/utils/utils.dart';
import '../../../../../core/widgets/atoms/phone_text_field.dart';
import '../../../../../core/widgets/atoms/underlined_text_field.dart';
import '../../../../../core/widgets/elements/action_button_container.dart';
import '../../../../../core/widgets/elements/error_text.dart';
import '../../../../../core/widgets/elements/loader.dart';
import '../../../../../core/widgets/elements/section_heading_text.dart';

class EditPharmacyProfileScreen extends ConsumerStatefulWidget {
  const EditPharmacyProfileScreen({super.key});

  @override
  ConsumerState createState() => _EditPharmacyProfileScreenState();
}

class _EditPharmacyProfileScreenState
    extends ConsumerState<EditPharmacyProfileScreen> {
  late TextEditingController _nameController;
  late TextEditingController _phoneController;
  late TextEditingController _codeController;
  late TextEditingController _addressController;
  late TextEditingController _stateController;
  late TextEditingController _lgaController;
  late TextEditingController _emergencyController;
  late FocusNode _focus;
  LatLng latLng = const LatLng(0, 0);
  Uint8List? profilePic;

  Future<void> updateProfile(
      {required WidgetRef ref,
      required BuildContext context,
      required HealthcareCentreInfo pharmacy}) async {
    try {
      final controller = ref.read(pharmacySettingsControllerProvider);
      await controller.updateProfile(
          _nameController.text,
          _phoneController.text,
          _addressController.text,
          _stateController.text,
          _lgaController.text,
          _emergencyController.text,
          profilePic,
          pharmacy, latLng);
    } catch (e) {
      if (mounted) {
        showModalBottomSheet(
            context: context,
            builder: (context) =>
                const ErrorModal(message: 'An error occurred'));
      }
    }
  }

  @override
  void initState() {
    super.initState();
    _nameController = TextEditingController();
    _phoneController = TextEditingController();
    _codeController = TextEditingController();
    _addressController = TextEditingController();
    _stateController = TextEditingController();
    _lgaController = TextEditingController();
    _emergencyController = TextEditingController();
    _focus = FocusNode();
  }

  @override
  void dispose() {
    _nameController.dispose();
    _phoneController.dispose();
    _codeController.dispose();
    _addressController.dispose();
    _stateController.dispose();
    _lgaController.dispose();
    _emergencyController.dispose();
    _focus.dispose();
    super.dispose();
  }

  void selectProfileImage() async {
    profilePic = await pickOneImage();
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    final pharmacy = ref.read(pharmacyProvider);
    final Size size = MediaQuery.sizeOf(context);
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
      body: ref.watch(getPharmacyDetailsProvider(pharmacy!.pId)).when(
          data: (pharmacyInfo) {
            _nameController.text = pharmacyInfo.name;
            _phoneController.text = pharmacyInfo.number;
            _addressController.text = pharmacyInfo.address;
            _stateController.text = pharmacyInfo.state==''? 'Lagos': pharmacyInfo.state;
            _lgaController.text = pharmacyInfo.lga==''? 'Shomolu': pharmacyInfo.lga;
            _emergencyController.text = pharmacyInfo.emergencyContact;
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
                                            pharmacyInfo.pharmacyImgUrl),
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
                      UnderlinedTextField(
                          controller: _nameController, hint: 'Name'),
                      (size.height * 20 / 852).pv,
                      PhoneTextField(
                          codeController: _codeController,
                          phoneController: _phoneController),
                      (size.height * 20 / 852).pv,
                      AddressUnderlinedTextField(
                        controller: _addressController,
                        latLngCallback: (Prediction prediction) {
                          latLng = LatLng(double.parse(prediction.lat!),
                              double.parse(prediction.lng!));
                        },
                        clickCallback: (Prediction prediction){
                          _addressController.text = prediction.description!;
                          _addressController.selection = TextSelection.fromPosition(TextPosition(offset: prediction.description!.length));
                        }, focus: _focus,
                      ),
                      (size.height * 20 / 852).pv,
                      Row(
                        children: [
                          SizedBox(
                              width: size.width * 170 / 393,
                              child: FormField<String>(
                                builder: (FormFieldState<String> state) {
                                  return InputDecorator(
                                    decoration: InputDecoration(
                                      hintStyle: Palette
                                          .lightModeAppTheme.textTheme.bodySmall
                                          ?.copyWith(
                                        fontSize: 16,
                                        color: Palette.hintTextGray,
                                      ),
                                      hintText: 'State',
                                      filled: true,
                                      fillColor: Palette.whiteColor,
                                      enabledBorder: const UnderlineInputBorder(
                                        borderSide: BorderSide(
                                            color: Palette.hintTextGray,
                                            width: 1),
                                      ),
                                      focusedBorder: const UnderlineInputBorder(
                                        borderSide: BorderSide(
                                            color: Palette.mainGreen, width: 1),
                                      ),
                                    ),
                                    child: DropdownButtonHideUnderline(
                                      child: Theme(
                                        data: Theme.of(context).copyWith(
                                          canvasColor: Palette.whiteColor,
                                        ),
                                        child: DropdownButton<String>(
                                          dropdownColor: Palette.whiteColor,
                                          isDense: true,
                                          isExpanded: true,
                                          value: _stateController.text,
                                          onChanged: (value) {
                                            setState(() {
                                              _stateController.text =
                                                  value ?? 'Lagos';
                                            });
                                          },
                                          items: NigerianStatesAndLGA.allStates
                                              .map<DropdownMenuItem<String>>(
                                                  (String value) {
                                            return DropdownMenuItem<String>(
                                              value: value,
                                              child: Text(
                                                value,
                                                style: Palette.lightModeAppTheme
                                                    .textTheme.bodySmall
                                                    ?.copyWith(
                                                  fontSize: 16,
                                                  color: Palette.blackColor,
                                                ),
                                              ),
                                            );
                                          }).toList(),
                                        ),
                                      ),
                                    ),
                                  );
                                },
                              )),
                          Flexible(child: Container()),
                          SizedBox(
                            width: size.width * 170 / 393,
                            child: FormField<String>(
                              builder: (FormFieldState<String> state) {
                                return InputDecorator(
                                  decoration: InputDecoration(
                                    hintStyle: Palette
                                        .lightModeAppTheme.textTheme.bodySmall
                                        ?.copyWith(
                                      fontSize: 16,
                                      color: Palette.hintTextGray,
                                    ),
                                    hintText: 'LGA',
                                    filled: true,
                                    fillColor: Palette.whiteColor,
                                    enabledBorder: const UnderlineInputBorder(
                                      borderSide: BorderSide(
                                          color: Palette.hintTextGray,
                                          width: 1),
                                    ),
                                    focusedBorder: const UnderlineInputBorder(
                                      borderSide: BorderSide(
                                          color: Palette.mainGreen, width: 1),
                                    ),
                                  ),
                                  child: DropdownButtonHideUnderline(
                                    child: Theme(
                                      data: Theme.of(context).copyWith(
                                        canvasColor: Palette.whiteColor,
                                      ),
                                      child: DropdownButton<String>(
                                        dropdownColor: Palette.whiteColor,
                                        isDense: true,
                                        isExpanded: true,
                                        value: _lgaController.text,
                                        onChanged: (value) {
                                          setState(() {
                                            _lgaController.text = value ??
                                                NigerianStatesAndLGA
                                                    .getStateLGAs(
                                                        _stateController
                                                            .text)[0];
                                          });
                                        },
                                        items:
                                            NigerianStatesAndLGA.getStateLGAs(
                                                    _stateController.text)
                                                .map<DropdownMenuItem<String>>(
                                                    (String value) {
                                          return DropdownMenuItem<String>(
                                            value: value,
                                            child: Text(
                                              value,
                                              style: Palette.lightModeAppTheme
                                                  .textTheme.bodySmall
                                                  ?.copyWith(
                                                fontSize: 16,
                                                color: Palette.blackColor,
                                              ),
                                            ),
                                          );
                                        }).toList(),
                                      ),
                                    ),
                                  ),
                                );
                              },
                            ),
                          ),
                        ],
                      ),
                      (size.height * 20 / 852).pv,
                      UnderlinedTextField(
                          controller: _emergencyController,
                          hint: 'EmergencyContact'),
                      (size.height * 24 / 852).pv,
                      InkWell(
                        onTap: () async {
                          await updateProfile(
                              ref: ref,
                              context: context,
                              pharmacy: pharmacyInfo);
                          if (mounted) {
                            Navigator.pop(context);
                          }
                        },
                        child: const ActionButtonContainer(title: 'Continue'),
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
