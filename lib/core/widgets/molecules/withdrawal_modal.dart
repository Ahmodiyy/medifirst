import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:medifirst/core/theming/spaces.dart';

import '../../theming/palette.dart';
import '../elements/action_button_container.dart';
import '../elements/amount_textfield.dart';
import '../elements/section_container.dart';
import '../elements/section_heading_text.dart';

class WithdrawalModal extends ConsumerStatefulWidget {
  final String id;
  const WithdrawalModal({super.key, required this.id});

  @override
  ConsumerState createState() => _WithdrawalModalState();
}

class _WithdrawalModalState extends ConsumerState<WithdrawalModal> {
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
    return Container(
      height: size.height * 521 / 852,
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
            Text(
              'WITHDRAWAL AMOUNT',
              style: Palette.lightModeAppTheme.textTheme.bodyLarge?.copyWith(
                fontSize: 10,
                color: Palette.highlightTextGray,
              ),
            ),
            (size.height * 33 / 852).pv,
            AmountTextfield(controller: _controller),
            (size.height * 40 / 852).pv,
            const SectionHeadingText(heading: 'WITHDRAW TO').alignLeft(),
            (size.height * 10).pv,
            SectionContainer(
              height: size.height * 73 / 852,
              child: Padding(
                padding: EdgeInsets.symmetric(
                    horizontal: size.width * 18 / 393,
                    vertical: size.height * 20 / 852),
                child: Row(
                  children: [
                    Text(
                      'Add account',
                      style: Palette.lightModeAppTheme.textTheme.bodyMedium?.copyWith(
                        fontSize: 14,
                        color: Palette.highlightTextGray,
                      ),
                    ),
                    Flexible(child: Container()),
                    InkWell(onTap: (){
                    },child: Icon(Icons.add_rounded, color: Palette.mainGreen, size: size.height*24/393,)),
                  ],
                ),
              ),
            ),
            Flexible(child: Container()),
            InkWell(
              onTap: () {
              },
              child: const ActionButtonContainer(title: 'Withdraw'),
            ),
          ],
        ),
      ),
    );
  }
}
