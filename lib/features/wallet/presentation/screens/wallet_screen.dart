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

import '../../../../core/theming/palette.dart';
import '../../../prescriptions/presentation/screens/prescriptions_screen.dart';

class WalletScreen extends ConsumerStatefulWidget {
  const WalletScreen({super.key});

  @override
  ConsumerState createState() => _WalletScreenState();
}

class _WalletScreenState extends ConsumerState<WalletScreen> {
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
          'Wallet',
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
              const PatientWalletBalanceCard().sidePad(16),
              (size.height * 30/852).pv,
              const SectionHeadingText(heading: 'SETTINGS').sidePad(16).alignLeft(),
              (size.height * 12/852).pv,
              InkWell(
                onTap: () {
                  Navigator.push(context, MaterialPageRoute(builder: (context)=>const TransactionHistoryScreen()));
                },
                child: const SettingButtonTile(label: 'Transaction History'),
              ),
              InkWell(
                  onTap: () {
                    Navigator.push(context, (MaterialPageRoute(builder: (context)=>const ReportIssueScreen())));
                  },
                  child: const SettingButtonTile(label: 'Report a problem', svg: 'assets/icons/svgs/danger.svg', color: Palette.redTextColor,)
              ),
            ],
          ),
        ),
      ),
    );
  }
}
