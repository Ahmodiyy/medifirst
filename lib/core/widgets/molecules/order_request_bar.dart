import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:medifirst/core/theming/palette.dart';
import 'package:medifirst/core/theming/spaces.dart';
import 'package:medifirst/core/widgets/elements/card_53_image.dart';
import 'package:medifirst/core/widgets/elements/section_container.dart';
import 'package:medifirst/models/order_info.dart';

class OrderRequestBar extends ConsumerStatefulWidget {
  final OrderInfo order;
  const OrderRequestBar({super.key, required this.order});

  @override
  ConsumerState createState() => _OrderRequestBarState();
}

class _OrderRequestBarState extends ConsumerState<OrderRequestBar> {
  @override
  Widget build(BuildContext context) {
    final Size size = MediaQuery.sizeOf(context);
    final order = widget.order;
    return SectionContainer(
      height: size.height * 111/852,
      child: Padding(
        padding: EdgeInsets.symmetric(horizontal: size.width * 16/393, vertical: size.height * 10/852),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Card53Image(imgUrl: order.drugImageURL),
                (size.width * 12/393).ph,
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(order.drugName, style: Palette.lightModeAppTheme.textTheme.bodyMedium?.copyWith(
                      fontSize: 14,
                      letterSpacing: -0.4,
                    ),),
                    Text(order.pharmacyName, style: Palette.lightModeAppTheme.textTheme.bodySmall?.copyWith(
                      letterSpacing: -0.4,
                    ),),
                    Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Text('#${order.price}', style: Palette.lightModeAppTheme.textTheme.bodySmall?.copyWith(
                          letterSpacing: -0.4,
                        ),),
                        //TODO add distance
                      ],
                    )
                  ],
                )
              ],
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                InkWell(
                  onTap: (){
                    //TODO add correct function
                  },
                  child: Text('Accept', style: Palette.lightModeAppTheme.textTheme.bodySmall?.copyWith(
                    fontSize: 14,
                    color: Palette.validationGreen,
                  ),),
                ),
                InkWell(
                  onTap: (){
                    //TODO add correct function
                  },
                  child: Text('Reject', style: Palette.lightModeAppTheme.textTheme.bodySmall?.copyWith(
                    fontSize: 14,
                    color: Palette.redTextColor,
                  ),),
                ),
              ],
            )
          ],
        ),
      ),
    );
  }
}
