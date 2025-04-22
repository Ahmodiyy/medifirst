import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:medifirst/core/theming/palette.dart';
import 'package:medifirst/core/widgets/atoms/drug_order_bar.dart';
import 'package:medifirst/core/widgets/elements/error_text.dart';
import 'package:medifirst/core/widgets/elements/loader.dart';
import 'package:medifirst/features/auth/controller/auth_controller.dart';

import '../../controller/my_orders_controller.dart';

class MyOrdersScreen extends ConsumerStatefulWidget {
  const MyOrdersScreen({super.key});

  @override
  ConsumerState<MyOrdersScreen> createState() => _MyOrdersScreenState();
}

class _MyOrdersScreenState extends ConsumerState<MyOrdersScreen> {
  @override
  Widget build(BuildContext context) {
    final Size size = MediaQuery.sizeOf(context);
    final user = ref.read(userProvider);
    return Scaffold(
      backgroundColor: Palette.backGroundColor,
      appBar: AppBar(
        backgroundColor: Palette.whiteColor,
        centerTitle: true,
        automaticallyImplyLeading: false,
        title: Text(
          'My Orders',
          style: Palette.lightModeAppTheme.textTheme.bodySmall?.copyWith(
            fontSize: 20,
          ),
        ),
      ),
      body: SafeArea(
        child: SizedBox(
          height: size.height * 707 / 852,
          child: ref.watch(getUsersOrdersProvider(user!.uid)).when(
              data: (orders) {
                if(orders.isNotEmpty){
                  return ListView.builder(
                      itemCount: orders.length,
                      itemBuilder: (context, index) {
                        final order = orders[index];
                        return DrugOrderBar(order: order);
                      });
                }else{
                  return Center(child: Text(
                    'No orders placed',
                    style: Palette.lightModeAppTheme.textTheme.titleMedium?.copyWith(
                      color: Palette.blackColor,
                    ),
                  ),);
                }
              },
              error: (error, stackTrace) =>
                  const ErrorText(error: 'No orders placed'),
              loading: () => const Loader()),
        ),
      ),
    );
  }
}
