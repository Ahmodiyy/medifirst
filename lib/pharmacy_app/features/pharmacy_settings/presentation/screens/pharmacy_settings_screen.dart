import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:medifirst/core/theming/spaces.dart';
import 'package:medifirst/core/widgets/elements/section_heading_text.dart';
import 'package:medifirst/core/widgets/molecules/pharmacy_wallet_balance_card.dart';
import 'package:medifirst/features/auth/controller/auth_controller.dart';
import 'package:medifirst/features/auth/presentation/screens/welcome_screen.dart';
import 'package:medifirst/features/feedback_and_complaints/presentation/screens/report_issue_screen.dart';
import 'package:medifirst/features/settings/presentation/widgets/setting_button_tile.dart';
import 'package:medifirst/pharmacy_app/features/pharmacy_orders/presentation/screens/pharmacy_orders_screen.dart';
import 'package:medifirst/pharmacy_app/features/pharmacy_settings/presentation/screens/edit_pharmacy_profile_screen.dart';

import '../../../../../core/theming/palette.dart';

class PharmacySettingsScreen extends ConsumerStatefulWidget {
  const PharmacySettingsScreen({super.key});

  @override
  ConsumerState createState() => _PharmacySettingsScreenState();
}

class _PharmacySettingsScreenState extends ConsumerState<PharmacySettingsScreen> {
  @override
  Widget build(BuildContext context) {
    final Size size = MediaQuery.sizeOf(context);
    final pharmacy = ref.watch(pharmacyProvider);
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
              const PharmacyWalletBalanceCard().sidePad(16),
              (size.height * 30/852).pv,
              const SectionHeadingText(heading: 'ACCOUNT SETTINGS').sidePad(16).alignLeft(),
              (size.height * 12/852).pv,
              InkWell(
                onTap: () {
                  Navigator.push(context, MaterialPageRoute(builder: (context)=>const EditPharmacyProfileScreen()));
                },
                child: const SettingButtonTile(label: 'My Profile'),
              ),
              (size.height * 24/852).pv,
              const SectionHeadingText(heading: 'GENERAL').sidePad(16).alignLeft(),
              (size.height * 12/852).pv,
              InkWell(
                onTap: () {
                  //TODO add correct function
                },
                child: const SettingButtonTile(label: 'Transactions'),
              ),
              InkWell(
                onTap: () {
                  Navigator.push(context, MaterialPageRoute(builder: (context)=> const PharmacyOrdersScreen()));
                },
                child: const SettingButtonTile(label: 'Orders'),
              ),
              (size.height * 24/852).pv,
              InkWell(
                onTap: () {
                  //TODO add correct function
                },
                child: const SettingButtonTile(label: 'Location'),
              ),
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
