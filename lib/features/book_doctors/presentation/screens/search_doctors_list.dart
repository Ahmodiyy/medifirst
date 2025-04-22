import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:medifirst/core/theming/palette.dart';
import 'package:medifirst/core/theming/spaces.dart';
import 'package:medifirst/core/widgets/atoms/location_search_bar.dart';
import 'package:medifirst/core/widgets/atoms/top_rated_doctor_bar.dart';
import 'package:medifirst/core/widgets/elements/loader.dart';
import 'package:medifirst/features/auth/controller/auth_controller.dart';
import 'package:medifirst/features/book_doctors/controller/book_doctors_controller.dart';
import 'package:medifirst/features/book_doctors/presentation/screens/doctor_details_page.dart';
import 'package:medifirst/models/doctor_info.dart';

import '../../../../core/widgets/elements/error_text.dart';

class SearchDoctorsList extends ConsumerStatefulWidget {
  const SearchDoctorsList({super.key});

  @override
  ConsumerState createState() => _SearchDoctorsListState();
}

class _SearchDoctorsListState extends ConsumerState<SearchDoctorsList> {
  late TextEditingController _controller;
  int selectedTab = 0;

  @override
  void initState() {
    super.initState();
    _controller = TextEditingController();
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  void goToDetailsPage(BuildContext context, DoctorInfo doctor){
    Navigator.push(context, MaterialPageRoute(builder: (context)=>DoctorDetailsPage(doctorInfo: doctor,)));
  }
  
  Widget _getListView(WidgetRef ref, BuildContext context, String uid){
    switch(selectedTab){
      case 1:
        return ref.watch(getDoctorListProvider).when(data: (doctors){
          return ListView.builder(itemBuilder: (context, index){
            final doctor = doctors[index];
            return InkWell(onTap: ()=>goToDetailsPage(context, doctor),child: TopRatedDoctorBar(doctor: doctor));
          });
        }, error: (error, stackTrace)=>const ErrorText(error: 'An error occurred'), loading: ()=>const Loader());
      default:
        return ref.watch(getFavDoctorsListProvider(uid)).when(data: (doctors){
          return ListView.builder(itemBuilder: (context, index){
            final doctor = doctors[index];
            return InkWell(onTap: ()=>goToDetailsPage(context, doctor),child: TopRatedDoctorBar(doctor: doctor));
          });
        }, error: (error, stackTrace)=>const ErrorText(error: 'An error occurred'), loading: ()=>const Loader());
    }
  }

  @override
  Widget build(BuildContext context) {
    final user = ref.watch(userProvider);
    final Size size = MediaQuery.sizeOf(context);
    return Scaffold(
      backgroundColor: Palette.backGroundColor,
      appBar: AppBar(
        backgroundColor: Palette.whiteColor,
        centerTitle: true,
        automaticallyImplyLeading: false,
        title: Text(
          'List',
          style: Palette.lightModeAppTheme.textTheme.bodySmall?.copyWith(
            fontSize: 20,
          ),
        ),
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          child: Column(
            children: [
              (size.height * 3/852).pv,
              LocationSearchBar(controller: _controller),
              (size.height*20/852).pv,
              //TODO add doctor types
              // ListView(
              //   scrollDirection: Axis.horizontal,
              //   children: searchTags.map((e) {
              //     return Padding(
              //       padding: const EdgeInsets.only(right: 4.0),
              //       child: FilterTag(
              //         label: e,
              //       ),
              //     );
              //   }).toList(),
              // ),
              (size.height*20/852).pv,
              Text(
                'Doctors',
                style: Palette.lightModeAppTheme.textTheme.titleSmall?.copyWith(
                  fontSize: 36,
                ),
              ),
              (size.height*20/852).pv,
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                crossAxisAlignment: CrossAxisAlignment.baseline,
                textBaseline: TextBaseline.alphabetic,
                children: [
                  Text('Nearby', style: Palette.lightModeAppTheme.textTheme.bodyMedium?.copyWith(
                    fontSize: 14,
                    color: (selectedTab == 0)? Palette.blackColor : Palette.highlightTextGray,
                  ),),
                  Text('Favorites', style: Palette.lightModeAppTheme.textTheme.bodyMedium?.copyWith(
                    fontSize: 14,
                    color: (selectedTab == 1)? Palette.blackColor : Palette.highlightTextGray,
                  ),),
                  Text('Open', style: Palette.lightModeAppTheme.textTheme.bodyMedium?.copyWith(
                    fontSize: 14,
                    color: (selectedTab == 2)? Palette.blackColor : Palette.highlightTextGray,
                  ),),
                ],
              ),
              (size.height*12/852).pv,
              SizedBox(
                height: (size.height*465/852),
                child: _getListView(ref, context, user!.uid),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
