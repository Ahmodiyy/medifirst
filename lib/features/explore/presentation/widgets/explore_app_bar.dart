import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:medifirst/core/theming/palette.dart';
import 'package:medifirst/features/auth/controller/auth_controller.dart';
import 'package:medifirst/features/settings/presentation/screens/edit_profile_screen.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../../models/user_info.dart';
final firestoreInstance = FirebaseFirestore.instance;

// Provider to fetch a UserInfoModel document by document ID
final userInfoProvider = StreamProvider.family<UserInfoModel, String>((ref, docId) {
  return firestoreInstance
      .collection('users') // Replace 'users' with your collection name
      .doc(docId)
      .snapshots()
      .map((snapshot) {
    if (snapshot.exists) {
      return UserInfoModel.fromMap(snapshot.data() as Map<String, dynamic>);
    } else {
      throw Exception("Document with ID $docId does not exist");
    }
  });
});

class ExploreAppBar extends ConsumerStatefulWidget {
  final String uid;
  final String name;
  final String profilePic;
  const ExploreAppBar({required this.uid,required this.name, required this.profilePic, super.key});

  @override
  ConsumerState createState() => _ExploreAppBarState();
}

class _ExploreAppBarState extends ConsumerState<ExploreAppBar> {
  @override
  Widget build(BuildContext context) {
    final Size size = MediaQuery.sizeOf(context);
    return SizedBox(
      height: size.height * 60/852,
      width: double.infinity,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'Hi, ${widget.name}',
                style:
                Palette.lightModeAppTheme.textTheme.titleSmall,
              ),
              Text(
                'Find your doctor',
                style:
                Palette.lightModeAppTheme.textTheme.titleMedium,
              ),
            ],
          ),
          InkWell(
            onTap: (){
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => const EditProfileScreen()),
              );
            },
            child: CircleAvatar(
              backgroundImage: NetworkImage(widget.profilePic),
              radius: 24,
            ),
          ),
        ],
      ),
    );
  }
}
