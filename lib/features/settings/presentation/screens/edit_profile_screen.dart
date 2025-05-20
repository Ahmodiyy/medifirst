import 'dart:typed_data';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:google_places_flutter/model/prediction.dart';
import 'package:medifirst/core/theming/palette.dart';
import 'package:medifirst/core/theming/spaces.dart';
import 'package:medifirst/core/widgets/atoms/underlined_text_field.dart';
import 'package:medifirst/core/widgets/elements/action_button_container.dart';
import 'package:medifirst/core/widgets/elements/error_text.dart';
import 'package:medifirst/core/widgets/elements/loader.dart';
import 'package:medifirst/core/widgets/elements/section_heading_text.dart';
import 'package:medifirst/core/widgets/elements/state_and_lga_dropdown.dart';
import 'package:medifirst/core/widgets/molecules/error_modal.dart';
import 'package:medifirst/features/auth/controller/auth_controller.dart';
import 'package:medifirst/features/settings/controller/settings_controller.dart';
import 'package:medifirst/features/settings/presentation/screens/edit_profile_screen_2.dart';
import 'package:medifirst/models/user_info.dart';
import 'package:nigerian_states_and_lga/nigerian_states_and_lga.dart';

import '../../../../core/utils/utils.dart';
import '../../../../core/widgets/atoms/address_underlined_text_field.dart';
import '../../../../core/widgets/atoms/phone_text_field.dart';

class EditProfileScreen extends ConsumerStatefulWidget {
  const EditProfileScreen({super.key});

  @override
  ConsumerState createState() => _EditProfileScreenState();
}

class _EditProfileScreenState extends ConsumerState<EditProfileScreen> {
  late TextEditingController _nameController;
  late TextEditingController _surnameController;
  late TextEditingController _ageController;
  late TextEditingController _phoneController;
  late TextEditingController _codeController;
  late TextEditingController _addressController;
  late TextEditingController _stateController;
  late TextEditingController _lgaController;
  late TextEditingController _emergencyContactController;
  late TextEditingController _occupationController;
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
    _stateController = TextEditingController(text: 'Lagos');
    _lgaController = TextEditingController(text: 'Shomolu');
    _emergencyContactController = TextEditingController();
    _occupationController = TextEditingController();
    _focus = FocusNode();
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
    _emergencyContactController.dispose();
    _occupationController.dispose();
    _focus.dispose();
    super.dispose();
  }

  void selectProfileImage() async {
    profilePic = await pickOneImage();
    setState(() {});
  }

  Future<void> saveDetailsAndContinue(
      {required WidgetRef ref,
        required UserInfoModel user,
      required BuildContext context,
      required String uid,
      required String ogImg}) async {
    try {
      setState(() {
        isLoading = true;
      });
      await ref.read(settingsControllerProvider).saveFirstPage(
          user: user,
          latLng: latLng,
          image: profilePic,
          imageFallback: ogImg,
          firstName: _nameController.text.trim(),
          surname: _surnameController.text.trim(),
          age: _ageController.text.trim(),
          number: '${_codeController.text}${_phoneController.text.trim()}',
          address: _addressController.text,
          state: _stateController.text,
          lga: _lgaController.text,
          occupation: _occupationController.text,
          emergencyContact: _emergencyContactController.text);
      await ref.read(authControllerProvider.notifier).updateUserInfo(ref.read(userProvider)!.uid);
      if(mounted){
        Navigator.push(
            context,
            MaterialPageRoute(
                builder: (context) =>
                const EditProfileScreenTwo()));
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
    final user = ref.watch(userProvider);
    return ref.watch(userSettingsInfoProvider(user!.uid)).when(
          data: (userData) {
            _nameController.text = userData.name;
            _surnameController.text = userData.surname;
            _ageController.text = userData.age.toString();
            _phoneController.text = userData.phone;
            latLng = LatLng(userData.latitude, userData.longitude);
            _addressController.text = userData.address;
            _stateController.text = userData.state;
            _lgaController.text = userData.city;
            _occupationController.text = userData.occupation;
            _emergencyContactController.text = userData.emergencyContact;
            latLng = LatLng(user.latitude, user.longitude);
            return Scaffold(
              backgroundColor: Palette.whiteColor,
              appBar: AppBar(
                backgroundColor: Palette.whiteColor,
                centerTitle: true,
                automaticallyImplyLeading: false,
                leading: IconButton(
                  onPressed: () {
                    Navigator.pop(context);
                  },
                  padding: EdgeInsets.only(right: size.width * 16 / 393),
                  icon: const Icon(
                    Icons.chevron_left_sharp,
                    color: Palette.blackColor,
                  ),
                ),
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
                    padding:
                        EdgeInsets.symmetric(horizontal: size.width * 16 / 393),
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
                                              userData.profilePicture),
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
                        UnderlinedTextField(
                          controller: _ageController,
                          hint: 'Age',
                          textInputType: TextInputType.number,
                        ),
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
                        StateAndLGADropdown(stateController: _stateController, lgaController: _lgaController),
                        (size.height * 20 / 852).pv,
                        UnderlinedTextField(
                            controller: _occupationController,
                            hint: 'Occupation'),
                        (size.height * 20 / 852).pv,
                        UnderlinedTextField(
                          controller: _emergencyContactController,
                          hint: 'Emergency Contact',
                          textInputType: TextInputType.number,
                        ),
                        (size.height * 32 / 852).pv,
                        InkWell(
                          onTap: () async {
                            await saveDetailsAndContinue(
                                ref: ref,
                                context: context,
                                uid: userData.uid,
                                ogImg: userData.profilePicture, user: user);

                          },
                          child: isLoading? CircularProgressIndicator(color: Palette.mainGreen,): const ActionButtonContainer(title: 'Continue'),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            );
          },
          error: (err, st) => const ErrorText(error: 'An error occurred'),
          loading: () => const Loader(),
        );
  }
}
