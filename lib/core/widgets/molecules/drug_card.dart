import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:medifirst/core/constants/data.dart';
import 'package:medifirst/core/theming/palette.dart';
import 'package:medifirst/models/drug_info.dart';

import '../../theming/spaces.dart';

class DrugCard extends StatelessWidget {
  final DrugInfo drug;
  const DrugCard({super.key, required this.drug});

  @override
  Widget build(BuildContext context) {
    final Size size = MediaQuery.sizeOf(context);
    return Container(
      width: size.width * 114/393,
      height: size.height * 130/852,
      padding: const EdgeInsets.all(2),
      decoration: BoxDecoration(
        color: Palette.whiteColor,
        borderRadius: BorderRadius.circular(5),
      ),
      child: Column(
        mainAxisSize: MainAxisSize.max,
        mainAxisAlignment: MainAxisAlignment.start,
        children: [
          Container(
            width: size.width * 110/393,
            height: size.height * 75/852,
            decoration: BoxDecoration(
              image: DecorationImage(
                image: NetworkImage(drug.drugImageURL),
                fit: BoxFit.fill,
              ),
              borderRadius: BorderRadius.circular(3),
            ),
          ),
          (size.height * 4/852).pv,
          Text(
            drug.drugName,
            style: Palette.lightModeAppTheme.textTheme.bodySmall?.copyWith(
              fontSize: 12,
            ),
          ),
          (size.height * 4/852).pv,
          Row(
            mainAxisSize: MainAxisSize.max,
            children: [
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    drug.brandName,
                    style:
                        Palette.lightModeAppTheme.textTheme.bodySmall?.copyWith(
                      fontSize: 8,
                      color: Palette.redTextColor,
                    ),
                  ),
                  (size.height * 3/852).pv,
                  Text(
                    'N${Data.numberFormat.format(drug.price)}',
                    style: Palette.lightModeAppTheme.textTheme.titleMedium
                        ?.copyWith(
                      fontSize: 12,
                      color: Palette.mainGreen,
                    ),
                  ),
                ],
              ),
              Align(
                alignment: Alignment.bottomRight,
                child: Container(
                  height: size.height * 24/852,
                  width: size.height * 24/852,
                  decoration: const BoxDecoration(
                    color: Palette.mainGreen,
                    borderRadius: BorderRadius.only(
                      bottomRight: Radius.circular(3),
                    ),
                  ),
                  child: Center(
                    child: SvgPicture.asset(
                      'assets/icons/svgs/add.svg',
                      height: size.height * 16/852,
                      width: size.height * 16/852,
                    ),
                  ),
                ),
              ),
            ],
          )
        ],
      ),
    );
  }
}
