import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:medifirst/core/theming/spaces.dart';
import 'package:medifirst/core/widgets/elements/action_button_container.dart';
import 'package:medifirst/core/widgets/elements/amount_textfield.dart';
import 'package:medifirst/core/widgets/elements/section_container.dart';
import 'package:medifirst/core/widgets/elements/section_heading_text.dart';
import 'package:medifirst/features/auth/controller/auth_controller.dart';
import 'package:medifirst/features/transactions/controller/transactions_controller.dart';
import 'package:paystack_for_flutter/paystack_for_flutter.dart';
import 'package:uuid/uuid.dart';

import '../../../../core/theming/palette.dart';

class DepositModal extends ConsumerStatefulWidget {
  const DepositModal({super.key});

  @override
  ConsumerState createState() => _DepositModalState();
}

class _DepositModalState extends ConsumerState<DepositModal> {
  late TextEditingController _controller;

  @override
  void initState() {
    super.initState();
    _controller = TextEditingController();
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final Size size = MediaQuery.sizeOf(context);
    final user = ref.watch(userProvider);
    final bottomInset = MediaQuery.of(context).viewInsets.bottom;
    return Scaffold(
      body: SingleChildScrollView(
        child: Container(
          height: size.height * 0.9,
          width: double.infinity,
          padding: EdgeInsets.only(bottom: bottomInset),
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
                  'DEPOSIT AMOUNT',
                  style:
                      Palette.lightModeAppTheme.textTheme.bodyLarge?.copyWith(
                    fontSize: 10,
                    color: Palette.highlightTextGray,
                  ),
                ),
                (size.height * 12 / 852).pv,
                AmountTextfield(controller: _controller),
                (size.height * 33 / 852).pv,
                const SectionHeadingText(heading: 'DEPOSIT WITH').alignLeft(),
                (size.height * 10 / 852).pv,
                SectionContainer(
                  height: size.height * 73 / 852,
                  child: Padding(
                    padding: EdgeInsets.symmetric(
                        // horizontal: size.width * 18 / 393,
                        vertical: size.height * 20 / 852),
                    child: Row(
                      children: [
                        Container(
                          width: size.width * 32 / 393,
                          height: size.width * 32 / 393,
                          decoration: BoxDecoration(
                            shape: BoxShape.circle,
                            border: Border.all(
                                color: Palette.dividerGray, width: 1),
                          ),
                          child: Center(
                            child: SvgPicture.asset(
                              'assets/icons/svgs/paystack.svg',
                              width: size.width * 15 / 393,
                              height: size.width * 15 / 393,
                            ),
                          ),
                        ),
                        (size.width * 8 / 393).ph,
                        Text(
                          'Paystack',
                          style: Palette.lightModeAppTheme.textTheme.bodyMedium
                              ?.copyWith(
                            fontSize: 14,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
                // const Spacer(),
                InkWell(
                  onTap: () async {
                    if (_controller.text.isNotEmpty) {
                      double amount =
                          int.parse(_controller.text.trim()).toDouble();
                      String reference = const Uuid().v4();
                      await PaystackFlutter().pay(
                        context: context,
                        secretKey: const String.fromEnvironment(
                            'paystackSecretLive',
                            defaultValue: ''),
                        showProgressBar: true,
                        email: user!.email,
                        reference: reference,
                        callbackUrl: 'https://medifirsttechnology.com/',
                        currency: Currency.NGN,
                        amount: amount * 100.0,
                        onSuccess: (paymentDate) async {
                          await ref
                              .read(transactionsControllerProvider)
                              .logDeposit(context, amount, user.uid, reference);
                        },
                        onCancelled: (paymentData) async {
                          /**
                              showModalBottomSheet(
                              context: context,
                              builder: (context) => const ErrorModal(
                              message: 'An error occurred'));
                           **/
                        },
                      );
                    }
                  },
                  child: const ActionButtonContainer(title: 'Deposit'),
                ),
                (size.height * 10 / 852).pv,
              ],
            ),
          ),
        ),
      ),
    );
  }
}
