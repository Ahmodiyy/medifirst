import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_svg/svg.dart';
import 'package:medifirst/core/constants/data.dart';
import 'package:medifirst/core/theming/palette.dart';
import 'package:medifirst/core/theming/spaces.dart';
import 'package:medifirst/core/widgets/elements/action_button_container.dart';
import 'package:medifirst/core/widgets/elements/error_text.dart';
import 'package:medifirst/core/widgets/elements/loader.dart';
import 'package:medifirst/core/widgets/molecules/review_card.dart';
import 'package:medifirst/features/auth/controller/auth_controller.dart';
import 'package:medifirst/features/book_doctors/controller/book_doctors_controller.dart';
import 'package:medifirst/features/book_doctors/presentation/screens/book_doctor_page.dart';
import 'package:medifirst/features/book_doctors/presentation/widgets/doctor_page_doctor_info.dart';
import 'package:medifirst/features/book_doctors/presentation/widgets/hours_time_text.dart';
import 'package:medifirst/models/doctor_info.dart';

import '../../../../core/widgets/elements/section_heading_text.dart';
import '../../../settings/controller/settings_controller.dart';

class DoctorDetailsPage extends ConsumerStatefulWidget {
  final DoctorInfo doctorInfo;
  const DoctorDetailsPage({super.key, required this.doctorInfo});

  @override
  ConsumerState createState() => _DoctorDetailsPageState();
}

class _DoctorDetailsPageState extends ConsumerState<DoctorDetailsPage> {
  @override
  Widget build(BuildContext context) {
    final doctor = widget.doctorInfo;
    final user = ref.watch(userProvider);
    final reviews = ref.watch(getDoctorReviewsProvider(doctor.doctorId));
    final Size size = MediaQuery.sizeOf(context);
    return Scaffold(
      backgroundColor: Palette.backGroundColor,
      appBar: AppBar(
        backgroundColor: Palette.whiteColor,
        centerTitle: true,
        automaticallyImplyLeading: false,
        leading: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            IconButton(
              onPressed: () {
                Navigator.pop(context);
              },
              padding: const EdgeInsets.only(right: 1),
              icon: const Icon(
                Icons.chevron_left_sharp,
                color: Palette.blackColor,
              ),
            ),
            // Text(
            //   'List',
            //   style: Palette.lightModeAppTheme.textTheme.bodySmall?.copyWith(
            //     fontSize: 16,
            //     color: Palette.highlightTextGray,
            //   ),
            // ),
          ],
        ),
        title: Text(
          'Dr. ${doctor.name}',
          style: Palette.lightModeAppTheme.textTheme.bodySmall?.copyWith(
            fontSize: 20,
          ),
        ),
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.start,
            children: [
              Container(
                width:  size.width,
                height: size.height * 340/852,
                padding: EdgeInsets.symmetric(vertical: size.height * 20/852, horizontal: size.width * 16/393),
                decoration: BoxDecoration(
                  image: DecorationImage(
                    image: NetworkImage(doctor.doctorImage),
                    fit: BoxFit.fill,
                  ),
                ),
                child: Align(
                  alignment: Alignment.topRight,
                  child:
                  ref.watch(userSettingsInfoProvider(user!.uid)).when(
                    data: (data){
                      return InkWell(
                        onTap: ()async{
                          await ref.watch(bookDoctorsControllerProvider).addDoctorToFavs(data, doctor.doctorId);
                        },
                        child: Container(
                          height: 43,
                          width: 43,
                          decoration: const ShapeDecoration(
                            shape: OvalBorder(),
                            color: Palette.whiteColor,
                          ),
                          child: Center(
                            child: (data.favDoctors.contains(doctor.doctorId))? Icon(Icons.favorite, size: 30, color: Palette.redTextColor,) : Icon(Icons.favorite_outline_rounded, size: 30,),
                          ),
                        ),
                      );
                    },
                    error: (err, stack){
                      return Center(child: CircularProgressIndicator(color: Palette.mainGreen,),);
                    },
                    loading: (){
                      return Center(child: CircularProgressIndicator(color: Palette.mainGreen,),);
                    },
                  )
                ),
              ),
              DoctorPageDoctorInfo(doctor: doctor),
              (size.height * 16/852).pv,
              (size.height * 8/852).pv,
              (doctor.bio == '')? Container() : const SectionHeadingText(heading: 'ABOUT').sidePad(16).alignLeft(),
              (doctor.bio == '')? Container() : (size.height * 16/852).pv,
              (doctor.bio == '')? Container() : Text(
                doctor.bio,
                style: Palette.lightModeAppTheme.textTheme.bodySmall?.copyWith(
                  fontSize: 12,
                ),
              ).sidePad(size.width * 16/393),
              (doctor.bio == '')? Container() : (size.height * 37/852).pv,
              const SectionHeadingText(heading: 'CHARGES').sidePad(16).alignLeft(),
              (size.height * 16/852).pv,
              Row(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Text(
                    'Starting Price',
                    style: Palette.lightModeAppTheme.textTheme.bodySmall
                        ?.copyWith(
                            color: Palette.smallBodyGray,
                            fontSize: 12,
                            height: 0.14),
                  ),
                  Flexible(
                    child: Container(),
                  ),
                  Text(
                    '₦${Data.numberFormat.format(doctor.consultationFee)}',
                    style: Palette.lightModeAppTheme.textTheme.bodyLarge?.copyWith(
                      fontSize: 14,
                      height: 0.14,
                    ),
                  ),
                ],
              ).sidePad(16),
              (size.height * 37/852).pv,
              const SectionHeadingText(heading: 'HOURS').sidePad(16).alignLeft(),
              (size.height * 16/852).pv,
              Row(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  HoursTimeText(label: 'Opens', time: doctor.openingHours),
                  Flexible(child: Container()),
                  HoursTimeText(label: 'Closes', time: doctor.closingHours),
                ],
              ).sidePad(16),
              reviews.when(
                data: (reviews) {
                  if(reviews.isEmpty){
                    return Container();
                  }
                  return Column(
                    children: [
                      (size.height * 37/852).pv,
                      const SectionHeadingText(heading: 'PATIENT REVIEWS').sidePad(16).alignLeft(),
                      (size.height * 16/852).pv,
                      SizedBox(
                        height: (size.height * 186/852),
                        child: ListView.builder(itemCount: reviews.length, itemBuilder: (context, index){
                          final review = reviews[index];
                          return ReviewCard(review: review);
                        }),
                      ),
                    ],
                  );
                },
                error: (error, stackTrace) =>
                    const ErrorText(error: 'An error occurred'),
                loading: () => const Loader(),
              ),
              (size.height * 49/852).pv,
              InkWell(onTap: (){
                Navigator.push(context, MaterialPageRoute(builder: (context)=>BookDoctorPage(doctorInfo: doctor)));
              },child: const ActionButtonContainer(title: 'Book an appointment')).sidePad(size.width*16/393),
              (size.height * 24/852).pv,
            ],
          ),
        ),
      ),
    );
  }
}
