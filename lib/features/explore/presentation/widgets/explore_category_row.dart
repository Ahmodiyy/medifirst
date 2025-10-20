import 'package:flutter/material.dart';
import 'package:medifirst/core/theming/palette.dart';
import 'package:medifirst/core/widgets/molecules/oops_dialog.dart';
import 'package:medifirst/features/location/presentation/screens/doctor_list_screen.dart';

import 'explore_category_item.dart';

class ExploreCategoryRow extends StatefulWidget {
  const ExploreCategoryRow({super.key});

  @override
  State<ExploreCategoryRow> createState() => _ExploreCategoryRowState();
}

class _ExploreCategoryRowState extends State<ExploreCategoryRow> {
  showOopsDialog(BuildContext context) {
    showDialog(context: context, builder: (context) => const OopsDialog());
  }

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        InkWell(
            onTap: () {
              Navigator.push(context,
                  MaterialPageRoute(builder: (context) => DoctorListScreen()));
            },
            child: const ExploreCategoryItem(
              svg: 'assets/icons/explore/consultant.png',
              title: 'Consultation',
              topColor: Palette.consultationGreen,
              bottomColor: Palette.consultationDarkGreen,
            )),
        //InkWell(onTap: ()=>showOopsDialog(context), child: const ExploreCategoryItem(svg: 'assets/icons/explore/drugs.png', title: 'Medicine', topColor: Palette.medicineBlue, bottomColor: Palette.medicineDarkBlue,)),
        //InkWell(onTap: () => showOopsDialog(context),child: const ExploreCategoryItem(svg: 'assets/icons/explore/emergency.png',title: 'Emergency',topColor: Palette.emergencyRed,bottomColor: Palette.emergencyDarkRed,)),
        //InkWell(onTap: ()=>showOopsDialog(context), child: const ExploreCategoryItem(svg: 'assets/icons/explore/healthcare.png', title: 'Healthcare', topColor: Palette.healthcarePurple, bottomColor: Palette.healthcareDarkPurple,)),
      ],
    );
  }
}
