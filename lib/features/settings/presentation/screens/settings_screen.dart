import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:medifirst/core/theming/spaces.dart';
import 'package:medifirst/core/widgets/elements/section_heading_text.dart';
import 'package:medifirst/core/widgets/molecules/patient_wallet_balance_card.dart';
import 'package:medifirst/features/auth/controller/auth_controller.dart';
import 'package:medifirst/features/auth/presentation/screens/welcome_screen.dart';
import 'package:medifirst/features/feedback_and_complaints/presentation/screens/report_issue_screen.dart';import 'package:medifirst/features/settings/presentation/screens/edit_profile_screen.dart';
import 'package:medifirst/features/settings/presentation/widgets/setting_button_tile.dart';
import 'package:medifirst/features/transactions/presentation/screens/transaction_history_screen.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:zego_uikit_prebuilt_call/zego_uikit_prebuilt_call.dart';

import '../../../../core/constants/constants.dart';
import '../../../../core/theming/palette.dart';
import '../../../prescriptions/presentation/screens/prescriptions_screen.dart';

class SettingsScreen extends ConsumerStatefulWidget {
  const SettingsScreen({super.key});

  @override
  ConsumerState createState() => _SettingsScreenState();
}

class _SettingsScreenState extends ConsumerState<SettingsScreen> {
  @override
  Widget build(BuildContext context) {
    final Size size = MediaQuery.sizeOf(context);
    final user = ref.watch(userProvider);
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
              (size.height * 24/852).pv,
              //TODO get wallet details
              const PatientWalletBalanceCard().sidePad(16),
              (size.height * 30/852).pv,
              const SectionHeadingText(heading: 'ACCOUNT SETTINGS').sidePad(16).alignLeft(),
              (size.height * 12/852).pv,
              InkWell(
                onTap: () {
                  Navigator.push(context, MaterialPageRoute(builder: (context)=>const EditProfileScreen()));
                },
                child: const SettingButtonTile(label: 'My Profile'),
              ),
              (size.height * 24/852).pv,
              const SectionHeadingText(heading: 'GENERAL').sidePad(16).alignLeft(),
              (size.height * 12/852).pv,
              InkWell(
                onTap: () {
                  Navigator.push(context, MaterialPageRoute(builder: (context)=>const TransactionHistoryScreen()));
                },
                child: const SettingButtonTile(label: 'Transactions'),
              ),
              /**
              InkWell(
                onTap: () {
                  Navigator.push(context, MaterialPageRoute(builder: (context)=>const PrescriptionsScreen()));
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
              (size.height * 24/852).pv,
              InkWell(
                onTap: () {
                  Navigator.push(context, (MaterialPageRoute(builder: (context)=>const ReportIssueScreen())));
                },
                child: const SettingButtonTile(label: 'Report a problem', svg: 'assets/icons/svgs/danger.svg',)
              ),
              (size.height * 24/852).pv,
              InkWell(
                onTap: () async {
                  await ref.read(authControllerProvider.notifier).signOut();
                  final SharedPreferences prefs = await SharedPreferences.getInstance();
                  prefs.clear();
                  ZegoUIKitPrebuiltCallInvitationService().uninit();
                  Navigator.pushReplacement(context, MaterialPageRoute(builder: (context)=>const WelcomeScreen()));
                },
                child: const SettingButtonTile(label: 'Sign Out', svg: 'assets/icons/svgs/logout.svg', color: Palette.logoutRed,),
              ),
              (size.height * 53/852).pv,
            ],
          ),
        ),
      ),
    );
  }
}
