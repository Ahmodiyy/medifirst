import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:medifirst/models/order_info.dart';

import '../../constants/data.dart';
import '../../theming/palette.dart';
import '../../theming/spaces.dart';
import '../elements/section_container.dart';

class DrugOrderBar extends ConsumerStatefulWidget {
  final OrderInfo order;
  const DrugOrderBar({super.key, required this.order});

  @override
  ConsumerState<DrugOrderBar> createState() => _DrugOrderBarState();
}

class _DrugOrderBarState extends ConsumerState<DrugOrderBar> {

  @override
  Widget build(BuildContext context) {
    return SectionContainer(
      height: 97,
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 20.0),
        child: Row(
          mainAxisSize: MainAxisSize.max,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Container(
              height: 32,
              width: 32,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(5),
                image: DecorationImage(
                  image: NetworkImage(widget.order.drugImageURL),
                  fit: BoxFit.fill,
                ),
              ),
            ),
            12.ph,
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Row(
                  mainAxisSize: MainAxisSize.min,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      widget.order.drugName,
                      style: Palette.lightModeAppTheme.textTheme.bodyMedium
                          ?.copyWith(
                        fontSize: 14,
                      ),
                    ),
                    4.ph,
                    Text(
                      widget.order.dosage,
                      style: Palette.lightModeAppTheme.textTheme.bodySmall
                          ?.copyWith(
                        color: Palette.smallBodyGray,
                        fontSize: 8,
                      ),
                    ),
                  ],
                ),
                Text('N${Data.numberFormat.format(widget.order.price)}', style: Palette.lightModeAppTheme.textTheme.titleMedium?.copyWith(fontSize: 12, color: Palette.mainGreen),),
              ],
            ),
            Flexible(child: Container()),

            Text(widget.order.orderStatus, style: Palette.lightModeAppTheme.textTheme.bodySmall?.copyWith(fontSize: 12, color: Palette.highlightTextGray),),
          ],
        ),
      ),
    );
  }
}
