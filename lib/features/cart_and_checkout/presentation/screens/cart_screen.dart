import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter/material.dart';
import 'package:medifirst/core/theming/palette.dart';
import 'package:medifirst/core/theming/spaces.dart';
import 'package:medifirst/core/widgets/elements/action_button_container.dart';
import 'package:medifirst/core/widgets/elements/error_text.dart';
import 'package:medifirst/core/widgets/elements/loader.dart';
import 'package:medifirst/core/widgets/molecules/drug_checkout_info_card.dart';
import 'package:medifirst/features/auth/controller/auth_controller.dart';
import 'package:medifirst/features/cart_and_checkout/controller/cart_and_checkout_controller.dart';
import 'package:medifirst/features/cart_and_checkout/presentation/widgets/cart_order_summary.dart';
import 'package:medifirst/models/cart_item.dart';

import '../../../../core/widgets/elements/section_heading_text.dart';

class CartScreen extends ConsumerStatefulWidget {
  const CartScreen({super.key});

  @override
  ConsumerState createState() => _CartScreenState();
}

class _CartScreenState extends ConsumerState<CartScreen> {
  @override
  Widget build(BuildContext context) {
    final user = ref.read(userProvider);
    final Size size = MediaQuery.sizeOf(context);
    return Scaffold(
      backgroundColor: Palette.backGroundColor,
      appBar: AppBar(
        backgroundColor: Palette.whiteColor,
        centerTitle: true,
        automaticallyImplyLeading: false,
        title: Text(
          'Cart',
          style: Palette.lightModeAppTheme.textTheme.bodySmall?.copyWith(
            fontSize: 20,
          ),
        ),
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          child: Column(
            children: [
              SizedBox(
                height: size.height * 291/393,
                child: ref.watch(getUserCartProvider(user!.uid)).when(
                      data: (data) {
                        return ListView.builder(
                          itemCount: data.length,
                          itemBuilder: (context, index) {
                            final CartItem order = data[index];
                            return DrugCheckoutInfoCard(order: order);
                          },
                        );
                      },
                      error: (error, stackTrace) =>
                          const ErrorText(error: 'An error occurred'),
                      loading: () => const Loader(),
                    ),
              ),
              const SectionHeadingText(heading: 'ORDER SUMMARY').sidePad(16),
              (size.height * 12/852).pv,
              const CartOrderSummary(),
              Flexible(child: Container()),
              //TODO add function
              InkWell(onTap: (){},child: const ActionButtonContainer(title: 'Checkout')),
            ],
          ),
        ),
      ),
    );
  }
}
