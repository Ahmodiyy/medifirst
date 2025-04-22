import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:medifirst/core/constants/data.dart';
import 'package:medifirst/core/theming/palette.dart';
import 'package:medifirst/core/theming/spaces.dart';
import 'package:medifirst/core/widgets/elements/card_53_image.dart';
import 'package:medifirst/core/widgets/elements/dropdown_button.dart';
import 'package:medifirst/core/widgets/elements/section_container.dart';
import 'package:medifirst/core/widgets/elements/unit_adjuster.dart';
import 'package:medifirst/features/auth/controller/auth_controller.dart';
import 'package:medifirst/models/cart_item.dart';

import '../../../features/cart_and_checkout/controller/cart_and_checkout_controller.dart';

class DrugCheckoutInfoCard extends ConsumerStatefulWidget {
  final CartItem order;
  const DrugCheckoutInfoCard({super.key, required this.order});

  @override
  ConsumerState<DrugCheckoutInfoCard> createState() =>
      _DrugCheckoutInfoCardState();
}

class _DrugCheckoutInfoCardState extends ConsumerState<DrugCheckoutInfoCard> {
  late TextEditingController dropdownController;
  late TextEditingController unitController;

  @override
  void initState() {
    super.initState();
    dropdownController = TextEditingController(text: Data.pkgUnits[0]);
    unitController = TextEditingController();
  }

  @override
  void dispose() {
    dropdownController.dispose();
    unitController.dispose();
    super.dispose();
  }

  void editSelectionStatus(WidgetRef ref, String userId) {
    ref
        .watch(cartAndCheckoutControllerProvider)
        .editInCartStatus(widget.order, userId);
  }

  @override
  Widget build(BuildContext context) {
    final order = widget.order;
    final user = ref.watch(userProvider);
    unitController.text = '${order.quantity}';
    dropdownController.addListener(() {
      ref
          .watch(cartAndCheckoutControllerProvider)
          .changePackageUnit(order.orderId, user!.uid, dropdownController.text);
    });
    return SectionContainer(
      height: 97,
      backgroundColor: (order.inCart) ? Palette.mainGreen : null,
      child: Padding(
        padding: const EdgeInsets.all(20.0),
        child: Row(
          mainAxisSize: MainAxisSize.max,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            InkWell(
              onTap: () => editSelectionStatus(ref, user!.uid),
              child: Card53Image(imgUrl: order.drugImageURL),
            ),
            12.ph,
            Column(
              mainAxisSize: MainAxisSize.max,
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  mainAxisSize: MainAxisSize.min,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      order.drugName,
                      style: Palette.lightModeAppTheme.textTheme.bodyMedium
                          ?.copyWith(
                        color: (order.inCart)
                            ? Palette.whiteColor
                            : Palette.blackColor,
                        fontSize: 14,
                      ),
                    ),
                    4.ph,
                    Text(
                      order.dosage,
                      style: Palette.lightModeAppTheme.textTheme.bodySmall
                          ?.copyWith(
                        color: Palette.dividerGray,
                        fontSize: 8,
                      ),
                    ),
                  ],
                ),
                Text(
                  order.brand,
                  style:
                      Palette.lightModeAppTheme.textTheme.bodySmall?.copyWith(
                    color: (order.inCart)
                        ? Palette.dividerGray
                        : Palette.blackColor,
                    fontSize: 8,
                  ),
                ),
                Text(
                  order.pharmacyName,
                  style:
                      Palette.lightModeAppTheme.textTheme.bodySmall?.copyWith(
                    color: (order.inCart)
                        ? Palette.dividerGray
                        : Palette.blackColor,
                  ),
                ),
                Text(
                  'N${Data.numberFormat.format(order.price)}',
                  style:
                      Palette.lightModeAppTheme.textTheme.titleMedium?.copyWith(
                    color:
                        (order.inCart) ? Palette.whiteColor : Palette.mainGreen,
                    fontSize: 12,
                  ),
                ),
              ],
            ),
            Align(
              alignment: Alignment.centerRight,
              child: Column(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                mainAxisSize: MainAxisSize.max,
                crossAxisAlignment: CrossAxisAlignment.end,
                children: [
                  CustomDropdownButton(
                      list: Data.pkgUnits, controller: dropdownController),
                  UnitAdjuster(
                    controller: unitController,
                    userId: user!.uid,
                    orderId: order.orderId,
                  ),
                ],
              ),
            )
          ],
        ),
      ),
    );
  }
}
