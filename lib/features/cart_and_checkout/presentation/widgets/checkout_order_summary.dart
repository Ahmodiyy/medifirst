import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:medifirst/core/constants/data.dart';
import 'package:medifirst/core/theming/palette.dart';
import 'package:medifirst/core/theming/spaces.dart';
import 'package:medifirst/core/widgets/elements/loader.dart';
import 'package:medifirst/core/widgets/elements/section_container.dart';

import '../../../auth/controller/auth_controller.dart';
import '../../controller/cart_and_checkout_controller.dart';

class  CheckoutOrderSummary extends ConsumerStatefulWidget {
  const  CheckoutOrderSummary({super.key});

  @override
  ConsumerState createState() => _CheckoutOrderSummaryState();
}

class _CheckoutOrderSummaryState extends ConsumerState< CheckoutOrderSummary> {
  @override
  Widget build(BuildContext context) {
    final user = ref.read(userProvider);
    final noOfItems = ref.watch(getNumberOfCartItemsProvider(user!.uid));
    final price = ref.watch(getCartPriceProvider(user.uid));
    final Size size = MediaQuery.sizeOf(context);
    int total = 0;
    return SectionContainer(
      height: size.height * 141/852,
      child: Padding(
        padding: EdgeInsets.symmetric(vertical: size.height * 20/852, horizontal: size.width * 16/393),
        child: Column(
          children: [
            Row(
              crossAxisAlignment: CrossAxisAlignment.baseline,
              children: [
                noOfItems.when(
                    data: (number) {
                      return Text(
                        '$number items',
                        style: Palette.lightModeAppTheme.textTheme.bodySmall
                            ?.copyWith(fontSize: 12),
                      );
                    },
                    error: (error, stackTrace) => Text(
                      '#',
                      style: Palette.lightModeAppTheme.textTheme.bodySmall
                          ?.copyWith(fontSize: 12),
                    ),
                    loading: () => const Loader()),
                Flexible(child: Container()),
                price.when(data: (price){
                  setState(() {
                    total = price + 2000;
                  });
                  return Text(
                    'N${Data.numberFormat.format(price)}',
                    style: Palette.lightModeAppTheme.textTheme.bodySmall
                        ?.copyWith(fontSize: 12),
                  );
                }, error: (error, stackTrace) => Text(
                  '#',
                  style: Palette.lightModeAppTheme.textTheme.bodySmall
                      ?.copyWith(fontSize: 12),
                ), loading: ()=>const Loader(),),
              ],
            ),
            (size.height * 20/852).pv,
            Row(
              crossAxisAlignment: CrossAxisAlignment.baseline,
              children: [
                Text(
                  'Discount',
                  style: Palette.lightModeAppTheme.textTheme.bodySmall
                      ?.copyWith(fontSize: 12),
                ),
                Flexible(child: Container()),
                Text(
                  'N1000',
                  style: Palette.lightModeAppTheme.textTheme.bodySmall
                      ?.copyWith(fontSize: 12),
                ),
              ],
            ),
            (size.height * 20/852).pv,
            Row(
              crossAxisAlignment: CrossAxisAlignment.baseline,
              children: [
                Text(
                  'Delivery Fee',
                  style: Palette.lightModeAppTheme.textTheme.bodySmall
                      ?.copyWith(fontSize: 12),
                ),
                Flexible(child: Container()),
                Text(
                  'N1000',
                  style: Palette.lightModeAppTheme.textTheme.bodySmall
                      ?.copyWith(fontSize: 12),
                ),
              ],
            ),
            (size.height * 24/852).pv,
            Row(
              crossAxisAlignment: CrossAxisAlignment.baseline,
              children: [
                Text(
                  'Total amount',
                  style: Palette.lightModeAppTheme.textTheme.titleMedium
                      ?.copyWith(fontSize: 12),
                ),
                Flexible(child: Container()),
                Text(
                  'N1000',
                  style: Palette.lightModeAppTheme.textTheme.bodySmall
                      ?.copyWith(fontSize: 12),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}

