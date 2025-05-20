import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:google_places_flutter/model/prediction.dart';
import 'package:medifirst/core/theming/spaces.dart';
import 'package:medifirst/core/widgets/atoms/address_underlined_text_field.dart';
import 'package:medifirst/core/widgets/elements/action_button_container.dart';
import 'package:medifirst/core/widgets/elements/error_text.dart';
import 'package:medifirst/core/widgets/elements/loader.dart';
import 'package:medifirst/core/widgets/elements/section_container.dart';
import 'package:medifirst/core/widgets/elements/section_heading_text.dart';
import 'package:medifirst/core/widgets/molecules/error_modal.dart';
import 'package:medifirst/features/auth/controller/auth_controller.dart';
import 'package:medifirst/features/cart_and_checkout/controller/cart_and_checkout_controller.dart';
import 'package:medifirst/features/cart_and_checkout/presentation/screens/cart_payment_page.dart';
import 'package:medifirst/features/cart_and_checkout/presentation/widgets/my_cart_bar.dart';
import 'package:medifirst/models/user_info.dart';

import '../../../../core/constants/data.dart';
import '../../../../core/theming/palette.dart';

enum Delivery { store, delivery, neither }

class CheckOutDeliveryScreen extends ConsumerStatefulWidget {
  const CheckOutDeliveryScreen({super.key});

  @override
  ConsumerState createState() => _CheckOutDeliveryScreenState();
}

class _CheckOutDeliveryScreenState
    extends ConsumerState<CheckOutDeliveryScreen> {
  Delivery? _deliveryOption = Delivery.store;
  late TextEditingController _controller;
  late FocusNode _focus;
  LatLng latLng = const LatLng(0, 0);

  @override
  void initState() {
    super.initState();
    _controller = TextEditingController();
    _focus = FocusNode();
  }

  @override
  void dispose() {
    _controller.dispose();
    _focus.dispose();
    super.dispose();
  }

  Future<void> checkout(WidgetRef ref, UserInfoModel user, BuildContext context) async {
    final controller = ref.read(cartAndCheckoutControllerProvider);
    final String address = (_deliveryOption == Delivery.store)? 'Pickup': _controller.text;
    ref.watch(getUserCartProvider(user.uid)).when(
        data: (cartItems) async {
          String addAddress = await controller.addDeliveryAddress(cartItems, address, (_deliveryOption == Delivery.store), latLng);
          if(addAddress == 'Success'){
            Navigator.push(context, MaterialPageRoute(builder: (context)=>CartPaymentPage()));
          }
        },
        error: (err, st) {
          showModalBottomSheet(context: context, builder: (context)=>const ErrorModal(message: 'An error occurred'));
        },
        loading: () {
          showDialog(
              context: context,
              builder: (context) => Container(
                    height: double.infinity,
                width: double.infinity,
                color: Palette.whiteColor.withOpacity(0.5),
                child: const Center(child: Loader(),),
                  ),);
        });
  }

  @override
  Widget build(BuildContext context) {
    final user = ref.watch(userProvider);
    final cartValue = ref.watch(getCartPriceProvider(user!.uid));
    final Size size = MediaQuery.sizeOf(context);
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
        child: SingleChildScrollView(
          child: Column(
            children: [
              (size.height * 28 / 852).pv,
              cartValue.when(
                data: (price) {
                  return Text(
                    'N${Data.numberFormat.format(price)}',
                    style: Palette.lightModeAppTheme.textTheme.titleMedium
                        ?.copyWith(
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
              (size.height * 24 / 852).pv,
              const SectionHeadingText(heading: 'Pickup Delivery'),
              (size.height * 22 / 852).pv,
              SectionContainer(
                height: size.height * 58 / 852,
                child: Padding(
                  padding:
                      EdgeInsets.symmetric(horizontal: size.width * 16 / 393),
                  child: Row(
                    children: [
                      Radio(
                        value: Delivery.store,
                        groupValue: _deliveryOption,
                        onChanged: (Delivery? value) {
                          _deliveryOption = value;
                        },
                      ),
                      (size.width * 9 / 393).ph,
                      Text(
                        'Store Pickup',
                        style: Palette.lightModeAppTheme.textTheme.bodySmall
                            ?.copyWith(
                          fontSize: 14,
                        ),
                      )
                    ],
                  ),
                ),
              ),
              (size.height * 24 / 852).pv,
              const SectionHeadingText(heading: 'Delivery Address'),
              (size.height * 22 / 852).pv,
              SectionContainer(
                height: size.height * 67 / 852,
                child: Padding(
                  padding:
                      EdgeInsets.symmetric(horizontal: size.width * 16 / 393),
                  child: Row(
                    children: [
                      Radio(
                        value: Delivery.store,
                        groupValue: _deliveryOption,
                        onChanged: (Delivery? value) {
                          _deliveryOption = value;
                        },
                      ),
                      (size.width * 9 / 393).ph,
                      AddressUnderlinedTextField(
                        controller: _controller,
                        focus: _focus,
                        latLngCallback: (Prediction prediction) {
                          latLng = LatLng(double.parse(prediction.lat!),
                              double.parse(prediction.lng!));
                        },
                        clickCallback: (Prediction prediction) {
                          _controller.text = prediction.description!;
                          _controller.selection = TextSelection.fromPosition(
                              TextPosition(
                                  offset: prediction.description!.length));
                        },
                      ),
                    ],
                  ),
                ),
              ),
              Align(
                alignment: Alignment.bottomCenter,
                child: InkWell(onTap: ()=>checkout(ref, user, context), child: const ActionButtonContainer(title: 'Done').sidePad(size.width * 16/393)),
              ),
              (size.height * 24/852).pv,
            ],
          ),
        ),
      ),
    );
  }
}
