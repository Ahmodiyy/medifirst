import 'package:flutter/material.dart';
import 'package:medifirst/core/theming/palette.dart';

class OrderCategoryButton extends StatelessWidget {
  final String title;
  final int number;
  final bool isSelected;
  const OrderCategoryButton({super.key, required this.title, required this.isSelected, required this.number});

  @override
  Widget build(BuildContext context) {
    final Size size = MediaQuery.sizeOf(context);
    return Container(
      height: size.height * 40/852,
      width: size.width * 100/393,
      padding: EdgeInsets.symmetric(vertical: size.height * 10/852, horizontal: size.width * 15/393),
      decoration: BoxDecoration(
        color: isSelected? Palette.categoryGreen : Palette.categoryGreen.withOpacity(0.1),
        borderRadius: BorderRadius.circular(50),
      ),
      child: Center(
        child: Row(
          children: [
            Text(title, style: Palette.lightModeAppTheme.textTheme.bodyMedium?.copyWith(
              fontSize: 12,
              color: isSelected? Palette.whiteColor: Palette.categoryGreen,
            ),),
            Flexible(child: Container()),
            Container(
              height: size.height * 24/852,
              width: size.height * 24/852,
              decoration: const BoxDecoration(
                shape: BoxShape.circle,
                color: Palette.categoryHighlightGreen,
              ),
              child: Center(
                child: Text(number.toString(), style: Palette.lightModeAppTheme.textTheme.bodyLarge?.copyWith(
                  color: Palette.categoryGreen,
                  fontSize: 12,
                ),),
              ),
            )
          ],
        ),
      ),
    );
  }
}
