import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:medifirst/core/constants/data.dart';
import 'package:medifirst/core/theming/palette.dart';

class StatusTag extends StatelessWidget {
  final String status;
  const StatusTag({super.key, required this.status});

  Color getBGColor(){
    if(status == Data.orderStatus[1]){
      return Palette.orderProcessingBlueBg;
    }
    if(status == Data.orderStatus[2]){
      return Palette.orderDeliveredGreenBg;
    }
    return Palette.orderCancelledRedBg;
  }

  Color getTextColor(){
    if(status == Data.orderStatus[1]){
      return Palette.orderProcessingBlueText;
    }
    if(status == Data.orderStatus[2]){
      return Palette.orderDeliveredGreenText;
    }
    return Palette.orderCancelledRedText;
  }

  Widget getIcon(){
    if(status == Data.orderStatus[1]){
      return SvgPicture.asset('assets/icons/svgs/process_blue.svg', width: 14, height: 14,);
    }
    if(status == Data.orderStatus[2]){
      return SvgPicture.asset('assets/icons/svgs/tick_green.svg', width: 14, height: 14,);
    }
    return SvgPicture.asset('assets/icons/svgs/close_red.svg', width: 14, height: 14,);
  }

  @override
  Widget build(BuildContext context) {
    final Size size = MediaQuery.sizeOf(context);
    return Container(
      height: size.height * 26/852,
      width: size.width * 95/393,
      padding: EdgeInsets.symmetric(vertical: size.height * 3/852, horizontal: size.width * 12/393),
      decoration: BoxDecoration(
        color: getBGColor(),
        borderRadius: BorderRadius.circular(100),
      ),
      child: Center(
        child: Row(
          children: [
            Text(status, style: Palette.lightModeAppTheme.textTheme.bodySmall?.copyWith(
              fontSize: 10,
              color: getTextColor(),
            ),),
            Flexible(child: Container()),
            getIcon(),
          ],
        ),
      ),
    );
  }
}
