import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:medifirst/core/theming/palette.dart';
import 'package:medifirst/core/theming/spaces.dart';
import 'package:medifirst/core/widgets/molecules/error_modal.dart';
import 'package:medifirst/core/widgets/molecules/pay_with_medifirst_tile.dart';
import 'package:medifirst/features/cart_and_checkout/presentation/widgets/cart_order_summary.dart';
import 'package:medifirst/models/cart_item.dart';
import 'package:medifirst/models/user_info.dart';

//import 'package:pay_with_paystack/pay_with_paystack.dart';

import '../../../../core/constants/data.dart';
import '../../../../core/widgets/elements/error_text.dart';
import '../../../../core/widgets/elements/loader.dart';
import '../../../../core/widgets/elements/section_heading_text.dart';
import '../../../auth/controller/auth_controller.dart';
import '../../controller/cart_and_checkout_controller.dart';
import '../widgets/my_cart_bar.dart';

class CartPaymentPage extends ConsumerStatefulWidget {
  const CartPaymentPage({super.key});

  @override
  ConsumerState createState() => _CartPaymentPageState();
}

class _CartPaymentPageState extends ConsumerState<CartPaymentPage> {
  Future<void> payForCart(UserInfoModel user, WidgetRef ref) async {
    final controller = ref.read(cartAndCheckoutControllerProvider);
    try {
      final cart = ref.watch(getUserCartProvider(user.uid)).when(
            data: (items) async {
              for (CartItem item in items) {
                await controller.orderItem(item, user, item.deliveryAddress,
                    LatLng(item.latitude, item.longitude));
              }
            },
            error: (err, st) {
              throw Exception(err.toString());
            },
            loading: () {},
          );
    } catch (e) {
      showModalBottomSheet(
          context: context,
          builder: (context) => ErrorModal(message: 'An error occurred'));
    }
  }

  @override
  Widget build(BuildContext context) {
    final user = ref.watch(userProvider);
    final cartValue = ref.watch(getCartPriceProvider(user!.uid));
    final numberOfItems = ref.watch(getNumberOfCartItemsProvider(user.uid));
    final Size size = MediaQuery.sizeOf(context);
    int price = 0;
    return Scaffold(
      backgroundColor: Palette.backGroundColor,
      appBar: AppBar(
        backgroundColor: Palette.whiteColor,
        centerTitle: true,
        automaticallyImplyLeading: false,
        title: Text(
          'Checkout',
          style: Palette.lightModeAppTheme.textTheme.bodySmall?.copyWith(
            fontSize: 20,
          ),
        ),
      ),
      body: SafeArea(
        child: Column(
          children: [
            (size.height * 28 / 852).pv,
            cartValue.when(
              data: (value) {
                price = value;
                return Text(
                  'N${Data.numberFormat.format(value)}',
                  style:
                      Palette.lightModeAppTheme.textTheme.titleMedium?.copyWith(
                    fontSize: 32,
                  ),
                );
              },
              error: (error, stackTrace) =>
                  const ErrorText(error: 'An error occurred'),
              loading: () => const Loader(),
            ),
            (size.height * 16 / 852).pv,
            //what is the tax rate?
            Text(
              '30% Tax Included',
              style: Palette.lightModeAppTheme.textTheme.bodyMedium?.copyWith(
                fontSize: 10,
                color: Palette.discountGreen,
              ),
            ),
            (size.height * 16 / 852).pv,
            Text(
              'Delivery in 20 - 45 mins',
              style: Palette.lightModeAppTheme.textTheme.bodyMedium?.copyWith(
                fontSize: 10,
                color: Palette.redTextColor,
              ),
            ),
            (size.height * 40 / 852).pv,
            const SectionHeadingText(heading: 'MY CART'),
            (size.height * 12 / 852).pv,
            const MyCartBar(),
            (size.height * 40 / 852).pv,
            const SectionHeadingText(heading: 'ORDER SUMMARY'),
            (size.height * 12 / 852).pv,
            CartOrderSummary(),
            (size.height * 40 / 852).pv,
            const SectionHeadingText(heading: 'PAYMENT METHOD'),
            (size.height * 12 / 852).pv,
            InkWell(
              onTap: () {
                //TODO transfer funds
              },
              child: const PayWithMedifirstTile(),
            ),
          ],
        ),
      ),
    );
  }
}
