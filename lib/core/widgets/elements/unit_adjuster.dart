import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:medifirst/core/theming/palette.dart';

import '../../../features/cart_and_checkout/controller/cart_and_checkout_controller.dart';

class UnitAdjuster extends ConsumerStatefulWidget {
  final TextEditingController controller;
  final String userId;
  final String orderId;
  final double? height;
  final double? width;
  const UnitAdjuster(
      {required this.controller, this.height = 16, this.width = 61, required this.userId, required this.orderId, super.key});

  @override
  ConsumerState<UnitAdjuster> createState() => _UnitAdjusterState();
}

class _UnitAdjusterState extends ConsumerState<UnitAdjuster> {
  void increment(WidgetRef ref) async {
    ref.watch(cartAndCheckoutControllerProvider).incrementItem(widget.userId, widget.orderId);
  }

  void decrement(WidgetRef ref) async {
    ref.watch(cartAndCheckoutControllerProvider).decrementItem(widget.userId, widget.orderId);
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      height: widget.height,
      width: widget.width,
      padding: const EdgeInsets.symmetric(horizontal: 3.0, vertical: 2.0),
      decoration: BoxDecoration(
        color: Palette.buttonOffWhite,
        borderRadius: BorderRadius.circular(2),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.max,
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          InkWell(
            onTap: (){
              int number = int.parse(widget.controller.text);
              number--;
              widget.controller.text = number.toString();
              increment(ref);
            },
            child: SizedBox(
              width: 12,
              height: 12,
              child: Center(
                child: Text(
                  '-',
                  style: Palette.lightModeAppTheme.textTheme.bodyMedium
                      ?.copyWith(color: Palette.mainGreen, fontSize: 10),
                ),
              ),
            ),
          ),
          Container(
            width: 21,
            height: 13,
            color: Palette.whiteColor,
            child: Center(
              child: Text(
                widget.controller.text,
                style: Palette.lightModeAppTheme.textTheme.bodyMedium
                    ?.copyWith( fontSize: 10),
              ),
            ),
          ),
          InkWell(
            onTap: (){
              int number = int.parse(widget.controller.text);
              number++;
              widget.controller.text = number.toString();
              decrement(ref);
            },
            child: SizedBox(
              width: 12,
              height: 12,
              child: Center(
                child: Text(
                  '+',
                  style: Palette.lightModeAppTheme.textTheme.bodyMedium
                      ?.copyWith(color: Palette.mainGreen, fontSize: 10),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
