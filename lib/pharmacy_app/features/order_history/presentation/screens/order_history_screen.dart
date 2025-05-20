import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:medifirst/core/theming/palette.dart';
import 'package:medifirst/core/theming/spaces.dart';
import 'package:medifirst/core/widgets/elements/error_text.dart';
import 'package:medifirst/core/widgets/elements/loader.dart';
import 'package:medifirst/features/auth/controller/auth_controller.dart';

import '../../../../../core/widgets/elements/rounded_edge_textfield.dart';
import '../../controller/order_history_controller.dart';
import '../widgets/order_bar_collapsed.dart';
import '../widgets/order_category_button.dart';
import '../widgets/uncollapsed_order_info.dart';

class OrderHistoryScreen extends ConsumerStatefulWidget {
  const OrderHistoryScreen({super.key});

  @override
  ConsumerState createState() => _OrderHistoryScreenState();
}

class _OrderHistoryScreenState extends ConsumerState<OrderHistoryScreen> {
  late TextEditingController _searchController;
  int selectedCategory = 0;


  @override
  void initState() {
    super.initState();
    _searchController = TextEditingController();
  }


  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final Size size = MediaQuery.sizeOf(context);
    final pharmacy = ref.watch(pharmacyProvider);
    return Scaffold(
      backgroundColor: Palette.backGroundColor,
      appBar: AppBar(
        backgroundColor: Palette.whiteColor,
        centerTitle: true,
        automaticallyImplyLeading: false,
        title: Text(
          'Orders History',
          style: Palette.lightModeAppTheme.textTheme.bodySmall?.copyWith(
            fontSize: 20,
          ),
        ),
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          child: Column(
            children: [
              (size.height * 10/852).pv,
              Row(
                children: [
                  SizedBox(
                      width: size.width * 309 / 393,
                      child: RoundedEdgeTextField(
                          controller: _searchController,
                          isReadOnly: false,
                          prefixIcon: 'assets/icons/svgs/location.svg',
                          hint: 'Search Street, City')),
                  InkWell(
                    onTap: () {
                      //TODO add search
                    },
                    child: Container(
                      height: size.height * 44 / 852,
                      width: size.width * 44 / 393,
                      decoration: BoxDecoration(
                        color: Palette.whiteColor,
                        borderRadius: BorderRadius.circular(50),
                        border: Border.all(color: Palette.dividerGray, width: 1.0),
                      ),
                      child: const Center(
                        child: Icon(Icons.search, size: 24, color: Palette.blackColor,),
                      ),
                    ),
                  ),
                ],
              ),
              (size.height * 20/852).pv,
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Container(
                    height: size.height * 40/852,
                    width: size.width * 100/393,
                    padding: EdgeInsets.symmetric(vertical: size.height * 10/852, horizontal: size.width * 15/393),
                    decoration: BoxDecoration(
                      color: (selectedCategory == 0)? Palette.categoryGreen : Palette.categoryGreen.withOpacity(0.1),
                      borderRadius: BorderRadius.circular(50),
                    ),
                    child: Center(
                      child: Text('All', style: Palette.lightModeAppTheme.textTheme.bodyMedium?.copyWith(
                        fontSize: 12,
                        color: (selectedCategory == 0)? Palette.whiteColor: Palette.categoryGreen,
                      ),),
                    ),
                  ),
                  //TODO add correct number
                  OrderCategoryButton(title: 'PickUp', isSelected: selectedCategory==1, number: 10),
                  OrderCategoryButton(title: 'Delivery', isSelected: selectedCategory==2, number: 10),
                ],
              ),
              (size.height * 32/852).pv,
              ref.watch(getPharmacyOrderHistoryProvider(pharmacy!.pId)).when(data: (orders){
                return ListView.builder(itemBuilder: (context, index){
                  final order = orders[index];
                  bool expanded = false;
                  if(expanded == false){
                    return InkWell(onTap: (){
                      setState(() {
                        expanded = !expanded;
                      });
                    },child: OrderBarCollapsed(order: order));
                  }else{
                    return Column(
                      children: [
                        OrderBarCollapsed(order: order),
                        Divider(color: Palette.dividerGray,),
                        UncollapsedOrderInfo(order: order),
                      ],
                    );
                  }
                });
              }, error: (err, st)=>const ErrorText(error: 'No orders listed'), loading: ()=>const Loader(),),
            ],
          ),
        ),
      ),
    );
  }
}
