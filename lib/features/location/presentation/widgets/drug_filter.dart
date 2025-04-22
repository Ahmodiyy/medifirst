import 'package:flutter/material.dart';
import 'package:medifirst/core/theming/palette.dart';
import 'package:medifirst/core/theming/spaces.dart';

class DrugFilter extends StatelessWidget {
  final String drug_name;
  const DrugFilter({required this.drug_name, super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(
        horizontal: 3,
        vertical: 10,
      ),
      decoration: BoxDecoration(
        color: Palette.categoryPink,
        borderRadius: BorderRadius.circular(5),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        mainAxisAlignment: MainAxisAlignment.start,
        children: [
          Text(
            drug_name,
            style: Palette.lightModeAppTheme.textTheme.bodyMedium?.copyWith(
              color: Palette.redTextColor,
              fontSize: 10,
            ),
          ),
          3.ph,
          const Icon(Icons.close, color: Palette.redTextColor, size: 20,),
        ],
      ),
    );
  }
}
