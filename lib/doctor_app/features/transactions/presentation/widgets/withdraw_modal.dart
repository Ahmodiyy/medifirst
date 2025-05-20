import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:medifirst/core/theming/spaces.dart';
import 'package:medifirst/core/widgets/elements/action_button_container.dart';
import 'package:medifirst/features/auth/controller/auth_controller.dart';
import 'package:medifirst/features/transactions/controller/transactions_controller.dart';

import '../../../../../core/theming/palette.dart';

class WithdrawalModal extends ConsumerStatefulWidget {
  const WithdrawalModal({super.key});

  @override
  ConsumerState createState() => _WithdrawalModalState();
}

class _WithdrawalModalState extends ConsumerState<WithdrawalModal> {
  late TextEditingController _amountController;
  late TextEditingController _bankController;
  late TextEditingController _accountController;
  bool _isLoading = false;

  @override
  void initState() {
    super.initState();
    _bankController = TextEditingController();
    _accountController = TextEditingController();
  }

  @override
  void dispose() {
    _bankController.dispose();
    _accountController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final Size size = MediaQuery.sizeOf(context);
    final doctor = ref.watch(doctorProvider);
    return Container(
      height: size.height * 0.9,
      width: double.infinity,
      padding:
          EdgeInsets.only(bottom: MediaQuery.of(context).viewInsets.bottom),
      color: Palette.smallBodyGray,
      child: Container(
        width: double.infinity,
        padding: EdgeInsets.all(size.width * 18 / 393),
        decoration: const BoxDecoration(
          borderRadius: BorderRadius.only(
              topRight: Radius.circular(20), topLeft: Radius.circular(20)),
          color: Palette.whiteColor,
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            InkWell(
              onTap: () {
                Navigator.pop(context);
              },
              child: Icon(
                Icons.close_rounded,
                color: Palette.errorBorderGray,
                size: size.height * 24 / 852,
              ),
            ).alignLeft(),
            (size.height * 20 / 852).pv,
            Text(
              'BANK NAME',
              style: Palette.lightModeAppTheme.textTheme.bodyLarge?.copyWith(
                fontSize: 10,
                color: Palette.highlightTextGray,
              ),
            ).alignLeft(),
            (size.height * 12 / 852).pv,
            TextField(
              controller: _bankController,
              keyboardType: TextInputType.name,
              style: Palette.lightModeAppTheme.textTheme.bodyMedium?.copyWith(
                fontSize: 16,
              ),
              decoration: const InputDecoration(
                enabledBorder: UnderlineInputBorder(
                  borderSide: BorderSide(color: Palette.avatarGray),
                ),
                focusedBorder: UnderlineInputBorder(
                  borderSide: BorderSide(color: Palette.mainGreen),
                ),
              ),
            ),
            (size.height * 20 / 852).pv,
            Text(
              'ACCOUNT NUMBER',
              style: Palette.lightModeAppTheme.textTheme.bodyLarge?.copyWith(
                fontSize: 10,
                color: Palette.highlightTextGray,
              ),
            ).alignLeft(),
            (size.height * 12 / 852).pv,
            TextField(
              controller: _accountController,
              keyboardType: TextInputType.number,
              style: Palette.lightModeAppTheme.textTheme.bodyMedium?.copyWith(
                fontSize: 16,
              ),
              decoration: const InputDecoration(
                enabledBorder: UnderlineInputBorder(
                  borderSide: BorderSide(color: Palette.avatarGray),
                ),
                focusedBorder: UnderlineInputBorder(
                  borderSide: BorderSide(color: Palette.mainGreen),
                ),
              ),
            ),
            Flexible(child: Container()),
            InkWell(
              onTap: () async {
                _isLoading = true;
                await ref.read(transactionsControllerProvider).logWithdrawal(
                    context,
                    double.parse(_accountController.text.trim()),
                    doctor!.doctorId,
                    _bankController.text);
                _isLoading = false;
              },
              child: _isLoading
                  ? const ActionButtonContainer(title: 'Loading...')
                  : const ActionButtonContainer(title: 'Save Account'),
            ),
          ],
        ),
      ),
    );
  }
}
