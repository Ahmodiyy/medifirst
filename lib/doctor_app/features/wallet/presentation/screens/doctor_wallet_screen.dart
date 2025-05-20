import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:medifirst/core/theming/spaces.dart';
import 'package:medifirst/core/widgets/elements/section_heading_text.dart';
import 'package:medifirst/core/widgets/molecules/doctor_wallet_balance_card.dart';
import 'package:medifirst/core/widgets/molecules/patient_wallet_balance_card.dart';
import 'package:medifirst/doctor_app/features/transactions/presentation/screens/doctor_transactions_history_screen.dart';
import 'package:medifirst/features/auth/controller/auth_controller.dart';
import 'package:medifirst/features/feedback_and_complaints/presentation/screens/report_issue_screen.dart';
import 'package:medifirst/features/settings/presentation/widgets/setting_button_tile.dart';
import 'package:medifirst/features/transactions/presentation/screens/transaction_history_screen.dart';

import '../../../../../core/theming/palette.dart';


class DoctorWalletScreen extends ConsumerStatefulWidget {
  const DoctorWalletScreen({super.key});

  @override
  ConsumerState createState() => _DoctorWalletScreenState();
}

class _DoctorWalletScreenState extends ConsumerState<DoctorWalletScreen> {
  @override
  Widget build(BuildContext context) {
    final Size size = MediaQuery.sizeOf(context);
    final doctor = ref.watch(doctorProvider);
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
              const DoctorWalletBalanceCard().sidePad(16),
              (size.height * 30/852).pv,
              const SectionHeadingText(heading: 'SETTINGS').sidePad(16).alignLeft(),
              (size.height * 12/852).pv,
              InkWell(
                onTap: () {
                  Navigator.push(context, MaterialPageRoute(builder: (context)=>const DoctorTransactionHistoryScreen()));
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
