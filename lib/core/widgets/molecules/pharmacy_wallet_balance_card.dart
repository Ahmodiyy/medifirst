import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:medifirst/core/theming/palette.dart';
import 'package:medifirst/core/theming/spaces.dart';
import 'package:medifirst/core/widgets/elements/action_button_container.dart';
import 'package:medifirst/features/auth/controller/auth_controller.dart';
import 'package:medifirst/pharmacy_app/features/pharmacy_settings/controller/pharmacy_settings_controller.dart';

import '../elements/error_text.dart';
import '../elements/loader.dart';

class PharmacyWalletBalanceCard extends ConsumerStatefulWidget {
  const PharmacyWalletBalanceCard({super.key});

  @override
  ConsumerState createState() => _PharmacyWalletBalanceCardState();
}

class _PharmacyWalletBalanceCardState extends ConsumerState<PharmacyWalletBalanceCard> {
  bool visible = true;

  //TODO add withdraw function

  @override
  Widget build(BuildContext context) {
    final Size size = MediaQuery.sizeOf(context);
    final pharmacy = ref.watch(pharmacyProvider);
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
                    'Earnings ',
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
          ref.watch(getPharmacyWalletProvider(pharmacy!.pId)).when(
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
                  RichText(
                    text: TextSpan(
                        text: visible ? '${wallet.balance.truncate().toString()}.' : '****',
                        style: Palette.lightModeAppTheme.textTheme.bodyMedium
                            ?.copyWith(
                          fontSize: 32,
                          color: Palette.whiteColor,
                        ),
                        children: [
                          TextSpan(
                            text: visible
                                ? ((wallet.balance - wallet.balance.truncate()) * 100)
                                .truncate()
                                .toString()
                                : '**',
                            style: Palette.lightModeAppTheme.textTheme.bodyMedium
                                ?.copyWith(
                              fontSize: 20,
                              color: Palette.dividerGray,
                            ),
                          ),
                        ]),
                  ),
                  (size.height * 32 / 852).pv,
                ],
              ).alignLeft();
            },
            error: (err, st) => const ErrorText(error: 'Error'),
            loading: () => const Loader(),
          ),
          (size.height * 16 / 852).pv,
          InkWell(
              onTap: () {
                //TODO add correct function
              },
              child: const ActionButtonContainer(
                title: 'Withdraw',
                width: 322,
                backGroundColor: Palette.whiteColor,
                titleColor: Palette.discountGreen,
              )),
        ],
      ),
    );
  }
}
