import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:medifirst/core/theming/spaces.dart';
import 'package:medifirst/core/widgets/elements/section_heading_text.dart';
import 'package:medifirst/core/widgets/molecules/doctor_wallet_balance_card.dart';
import 'package:medifirst/doctor_app/features/edit_doctor_profile/presentation/screens/edit_doctor_profile_screen.dart';
import 'package:medifirst/features/auth/controller/auth_controller.dart';
import 'package:medifirst/features/auth/presentation/screens/welcome_screen.dart';
import 'package:medifirst/features/feedback_and_complaints/presentation/screens/report_issue_screen.dart';
import 'package:medifirst/features/settings/presentation/widgets/setting_button_tile.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:zego_uikit_prebuilt_call/zego_uikit_prebuilt_call.dart';

import '../../../../../core/theming/palette.dart';
import '../../../wallet/presentation/screens/doctor_wallet_screen.dart';

class DoctorSettingsScreen extends ConsumerStatefulWidget {
  const DoctorSettingsScreen({super.key});

  @override
  ConsumerState createState() => _SettingsScreenState();
}

class _SettingsScreenState extends ConsumerState<DoctorSettingsScreen> {
  @override
  Widget build(BuildContext context) {
    final Size size = MediaQuery.sizeOf(context);
    final doctor = ref.watch(doctorProvider);
    // final user = UserInfoModel(
    //     name: 'Mayo',
    //     surname: 'Odukoya',
    //     uid: '68f56',
    //     profilePicture:
    //         'https://t4.ftcdn.net/jpg/00/64/67/63/360_F_64676383_LdbmhiNM6Ypzb3FM4PPuFP9rHe7ri8Ju.jpg');
    return Scaffold(
      backgroundColor: Palette.backGroundColor,
      appBar: AppBar(
        backgroundColor: Palette.whiteColor,
        centerTitle: true,
        automaticallyImplyLeading: false,
        title: Text(
          'Settings',
          style: Palette.lightModeAppTheme.textTheme.bodySmall?.copyWith(
            fontSize: 20,
          ),
        ),
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          child: Column(
            children: [
              (size.height * 24 / 852).pv,
              const DoctorWalletBalanceCard().sidePad(16),
              (size.height * 30 / 852).pv,
              const SectionHeadingText(heading: 'ACCOUNT SETTINGS')
                  .sidePad(16)
                  .alignLeft(),
              (size.height * 12 / 852).pv,
              InkWell(
                onTap: () {
                  Navigator.push(
                      context,
                      MaterialPageRoute(
                          builder: (context) =>
                              const EditDoctorProfileScreen()));
                },
                child: const SettingButtonTile(label: 'My Profile'),
              ),
              (size.height * 24 / 852).pv,
              const SectionHeadingText(heading: 'GENERAL')
                  .sidePad(16)
                  .alignLeft(),
              (size.height * 12 / 852).pv,
              InkWell(
                onTap: () {
                  Navigator.push(
                      context,
                      MaterialPageRoute(
                          builder: (context) => const DoctorWalletScreen()));
                },
                child: const SettingButtonTile(label: 'Transactions'),
              ),
              /**
                  InkWell(
                  onTap: () {
                  //TODO get doctors prescriptions screen
                  Navigator.push(context, MaterialPageRoute(builder: (context)=>const Placeholder()));
                  },
                  child: const SettingButtonTile(label: 'Prescriptions'),
                  ),
                  (size.height * 24/852).pv,
                  InkWell(
                  onTap: () {
                  //TODO add correct function
                  },
                  child: const SettingButtonTile(label: 'Location'),
                  ),
               **/
              (size.height * 24 / 852).pv,
              InkWell(
                  onTap: () {
                    Navigator.push(
                        context,
                        (MaterialPageRoute(
                            builder: (context) => const ReportIssueScreen())));
                  },
                  child: const SettingButtonTile(
                    label: 'Report a problem',
                    svg: 'assets/icons/svgs/danger.svg',
                  )),
              (size.height * 24 / 852).pv,
              InkWell(
                onTap: () async {
                  await ref.read(authControllerProvider.notifier).signOut();
                  final SharedPreferences prefs =
                      await SharedPreferences.getInstance();
                  prefs.clear();
                  ZegoUIKitPrebuiltCallInvitationService().uninit();
                  Navigator.pushReplacement(
                      context,
                      MaterialPageRoute(
                          builder: (context) => const WelcomeScreen()));
                },
                child: const SettingButtonTile(
                  label: 'Sign Out',
                  svg: 'assets/icons/svgs/logout.svg',
                  color: Palette.logoutRed,
                ),
              ),
              (size.height * 53 / 852).pv,
            ],
          ),
        ),
      ),
    );
  }
}
