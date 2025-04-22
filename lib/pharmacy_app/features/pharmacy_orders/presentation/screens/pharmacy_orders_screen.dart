import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:medifirst/core/theming/palette.dart';
import 'package:medifirst/core/widgets/elements/error_text.dart';
import 'package:medifirst/core/widgets/elements/loader.dart';
import 'package:medifirst/core/widgets/molecules/order_request_bar.dart';
import 'package:medifirst/features/auth/controller/auth_controller.dart';
import 'package:medifirst/pharmacy_app/features/pharmacy_orders/controller/pharmacy_orders_controller.dart';

class PharmacyOrdersScreen extends ConsumerStatefulWidget {
  const PharmacyOrdersScreen({super.key});

  @override
  ConsumerState createState() => _PharmacyOrdersScreenState();
}

class _PharmacyOrdersScreenState extends ConsumerState<PharmacyOrdersScreen> {
  @override
  Widget build(BuildContext context) {
    final Size size = MediaQuery.sizeOf(context);
    final pharmacy = ref.watch(pharmacyProvider);
    return Scaffold(
      backgroundColor: Palette.backGroundColor,
      appBar: AppBar(
        backgroundColor: Palette.whiteColor,
        title: Text(
          'Orders',
          style: Palette.lightModeAppTheme.textTheme.bodySmall?.copyWith(
            fontSize: 20,
            letterSpacing: -0.4,
          ),
        ),
        centerTitle: true,
        automaticallyImplyLeading: false,
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          child: Column(
            children: [
              SizedBox(
                height: size.height * 707 / 852,
                child: ref.watch(pharmacyOrdersProvider(pharmacy!.pId)).when(
                    data: (orders) {
                      return ListView.builder(
                          itemCount: orders.length,
                          itemBuilder: (context, index) {
                            final order = orders[index];
                            return OrderRequestBar(order: order);
                          });
                    },
                    error: (err, st) =>
                        const ErrorText(error: 'No notifications available'),
                    loading: () => const Loader()),
              )
            ],
          ),
        ),
      ),
    );
  }
}
