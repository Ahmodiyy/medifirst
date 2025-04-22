import 'package:flutter/material.dart';
import 'package:medifirst/core/theming/palette.dart';
import 'package:medifirst/core/theming/spaces.dart';
import 'package:medifirst/core/widgets/elements/action_button_container.dart';
import 'package:medifirst/models/order_info.dart';

class UncollapsedOrderInfo extends StatelessWidget {
  final OrderInfo order;
  const UncollapsedOrderInfo({super.key, required this.order});

  @override
  Widget build(BuildContext context) {
    final Size size = MediaQuery.sizeOf(context);
    return Container(
      height: size.height * 95/852,
      width: double.infinity,
      color: Palette.whiteColor,
      padding: EdgeInsets.symmetric(horizontal: size.width * 16/393).copyWith(top: size.height * 11.5/852),
      child: Column(
        children: [
          Row(
            children: [
              Text('Customer', style: Palette.lightModeAppTheme.textTheme.bodyLarge?.copyWith(
                color: Palette.highlightTextGray,
                fontSize: 12,
              ),),
              Flexible(child: Container()),
              Container(
                width: 24,
                height: 24,
                decoration: ShapeDecoration(
                  image: DecorationImage(
                    image: NetworkImage(order.customerImageURL),
                    fit: BoxFit.fill,
                  ),
                  shape: const CircleBorder(),
                ),
              ),
              Text(order.customerName, style: Palette.lightModeAppTheme.textTheme.bodyLarge?.copyWith(
                fontSize: 12,
              ),),
            ],
          ),
          Row(
            children: [
              Text('Order', style: Palette.lightModeAppTheme.textTheme.bodyLarge?.copyWith(
                color: Palette.highlightTextGray,
                fontSize: 12,
              ),),
              Flexible(child: Container()),
              Text('Details', style: Palette.lightModeAppTheme.textTheme.bodyLarge?.copyWith(
                color: Palette.highlightTextGray,
                fontSize: 12,
              ),),
            ],
          ),
          Row(
            children: [
              Text('Price', style: Palette.lightModeAppTheme.textTheme.bodyLarge?.copyWith(
                color: Palette.highlightTextGray,
                fontSize: 12,
              ),),
              Flexible(child: Container()),
              Text('\$${order.price}', style: Palette.lightModeAppTheme.textTheme.bodyLarge?.copyWith(
                color: Palette.highlightTextGray,
                fontSize: 12,
              ),),
            ],
          ),
          const Divider(color: Palette.dividerGray,),
          (size.height * 9/852).pv,
          InkWell(
            onTap: (){
              //TODO add request rider function
            },
            child: Text('Request a rider', style: Palette.lightModeAppTheme.textTheme.bodyLarge!.copyWith(
              color: Palette.blueText,
              fontSize: 12
            ),),
          ),
          (size.height * 10/852).pv,
          Row(
            children: [
              InkWell(onTap: (){},child: ActionButtonContainer(title: 'Confirm Delivered', width: size.width * 262/393,)),
              (size.width * 22/393).ph,
              Text('Cancel', style: Palette.lightModeAppTheme.textTheme.bodyLarge?.copyWith(
                fontSize: 16,
                color: Palette.redTextColor,
              ),)
            ],
          ),
          (size.height * 20/852).pv,
          const Divider(color: Palette.dividerGray,),
        ],
      ),
    );
  }
}
