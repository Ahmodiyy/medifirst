import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:medifirst/core/theming/palette.dart';
import 'package:medifirst/core/theming/spaces.dart';
import 'package:medifirst/core/widgets/elements/action_button_container.dart';
import 'package:medifirst/features/auth/controller/auth_controller.dart';
import 'package:medifirst/features/settings/controller/settings_controller.dart';
import 'package:medifirst/features/settings/presentation/widgets/deposit_modal.dart';

import '../../constants/data.dart';
import '../elements/error_text.dart';
import '../elements/loader.dart';

class PatientWalletBalanceCard extends ConsumerStatefulWidget {
  const PatientWalletBalanceCard({super.key});

  @override
  ConsumerState createState() => _PatientWalletBalanceCardState();
}

class _PatientWalletBalanceCardState
    extends ConsumerState<PatientWalletBalanceCard> {
  bool visible = true;

  @override
  Widget build(BuildContext context) {
    final Size size = MediaQuery.sizeOf(context);
    final user = ref.watch(userProvider);
    return Container(
      // height: size.height * 190/852,
      width: size.width * 361 / 393,
      padding: EdgeInsets.symmetric(
          horizontal: size.width * 16 / 393, vertical: size.height * 16 / 852),
      decoration: BoxDecoration(
        color: Palette.discountGreen,
        borderRadius: BorderRadius.circular(10),
      ),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.start,
        children: [
          Row(
            children: [
              Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Text(
                    'My Wallet Balance ',
                    style:
                        Palette.lightModeAppTheme.textTheme.bodySmall?.copyWith(
                      color: Palette.whiteColor,
                      height: 0.16,
                    ),
                  ),
                  SvgPicture.asset(
                    'assets/icons/svgs/coin.svg',
                    width: 12,
                    height: 12,
                  ),
                ],
              ),
              Flexible(child: Container()),
              IconButton(
                onPressed: () {
                  setState(() {
                    visible = !visible;
                  });
                },
                padding: EdgeInsets.zero,
                icon: (visible)
                    ? const Icon(
                        Icons.visibility_outlined,
                        color: Palette.whiteColor,
                        size: 16,
                      )
                    : const Icon(
                        Icons.visibility_off_outlined,
                        color: Palette.whiteColor,
                        size: 16,
                      ),
              ),
            ],
          ),
          ref.watch(patientWalletProvider(user!.uid)).when(
                data: (wallet) {
                  return Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      SvgPicture.asset(
                        'assets/icons/svgs/naira.svg',
                        width: 20,
                        height: 20,
                      ),
                      (size.width * 4 / 393).ph,
                      Flexible(
                        child: RichText(
                          text: TextSpan(
                              text: visible
                                  ? '${Data.balanceFormat.format(wallet.balance.truncate())}.'
                                  : '****',
                              style: Palette
                                  .lightModeAppTheme.textTheme.bodyMedium
                                  ?.copyWith(
                                fontSize: 32,
                                color: Palette.whiteColor,
                              ),
                              children: [
                                TextSpan(
                                  text: visible
                                      ? ((wallet.balance -
                                                  wallet.balance.truncate()) *
                                              100)
                                          .truncate()
                                          .toString()
                                          .padLeft(2, '0')
                                      : '**',
                                  style: Palette
                                      .lightModeAppTheme.textTheme.bodyMedium
                                      ?.copyWith(
                                    fontSize: 20,
                                    color: Palette.dividerGray,
                                  ),
                                ),
                              ]),
                        ),
                      ),
                      (size.height * 32 / 852).pv,
                    ],
                  ).alignLeft();
                },
                error: (err, st) {
                  print('$err $st');
                  return const ErrorText(error: 'Error');
                },
                loading: () => const Loader(),
              ),
          (size.height * 16 / 852).pv,
          InkWell(
              onTap: () {
                showModalBottomSheet(
                    context: context,
                    isScrollControlled: true,
                    builder: (context) => const DepositModal());
              },
              child: const ActionButtonContainer(
                title: 'Fund Wallet',
                width: 322,
                backGroundColor: Palette.whiteColor,
                titleColor: Palette.discountGreen,
              )),
        ],
      ),
    );
  }
}
