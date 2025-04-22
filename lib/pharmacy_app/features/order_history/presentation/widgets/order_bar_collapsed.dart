import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:intl/intl.dart';
import 'package:medifirst/core/theming/palette.dart';
import 'package:medifirst/models/order_info.dart';
import 'package:medifirst/pharmacy_app/features/order_history/presentation/widgets/status_tag.dart';

class OrderBarCollapsed extends StatelessWidget {
  final OrderInfo order;
  const OrderBarCollapsed({super.key, required this.order});

  @override
  Widget build(BuildContext context) {
    final Size s = MediaQuery.sizeOf(context);
    return Container(
      width: double.infinity,
      height: s.height * 79/852,
      padding: EdgeInsets.all(s.height * 16/852),
      decoration: const BoxDecoration(
        color: Palette.whiteColor,
        border: Border(top: BorderSide(color: Palette.dividerGray, width: 1), bottom: BorderSide(color: Palette.dividerGray, width: 1)),
      ),
      child: Row(
        children: [
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text('Order Id', style: Palette.lightModeAppTheme.textTheme.bodyMedium?.copyWith(
                fontSize: 14,
              ),),
              Flexible(child: Container()),
              Text('${DateFormat.yMMMMd().format(order.orderDate.toDate())}, ${DateFormat.jm().format(order.orderDate.toDate())}', style: Palette.lightModeAppTheme.textTheme.bodyMedium?.copyWith(
                fontSize: 10
              ),),
            ],
          ),
          Flexible(child: Container()),
          StatusTag(status: order.orderStatus),
          SvgPicture.asset('assets/icons/svgs/chevron_down.svg', width: 24, height: 24,),
        ],
      ),
    );
  }
}
