import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:medifirst/core/theming/palette.dart';
import 'package:medifirst/doctor_app/features/edit_doctor_profile/presentation/screens/edit_doctor_profile_screen.dart';
import 'package:medifirst/features/settings/presentation/screens/edit_profile_screen.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../../../../../core/constants/constants.dart';

class DoctorExploreAppBar extends ConsumerWidget {
  final String name;
  final String profilePic;
  const DoctorExploreAppBar(
      {required this.name, required this.profilePic, super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final Size size = MediaQuery.sizeOf(context);
    return SizedBox(
      height: size.height * 60 / 852,
      width: double.infinity,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'Hi, $name',
                style: Palette.lightModeAppTheme.textTheme.titleSmall,
              ),
              Text(
                'How can i help you today?',
                style: Palette.lightModeAppTheme.textTheme.titleMedium,
              ),
            ],
          ),
          InkWell(
            onTap: () async {
              final sharedPrefs = await SharedPreferences.getInstance();
              final category = sharedPrefs.getString(Constants.appTypeKey);
              switch (category!) {
                case Constants.patientCategory:
                  Navigator.push(
                      context,
                      MaterialPageRoute(
                          builder: (context) => const EditProfileScreen()));
                  break;
                case Constants.doctorCategory:
                  Navigator.push(
                      context,
                      MaterialPageRoute(
                          builder: (context) =>
                              const EditDoctorProfileScreen()));
                  break;
              }
            },
            child: CircleAvatar(
              backgroundImage: NetworkImage(profilePic),
              radius: 24,
            ),
          ),
        ],
      ),
    );
  }
}
