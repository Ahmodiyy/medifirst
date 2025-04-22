import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:medifirst/core/theming/spaces.dart';
import 'package:medifirst/core/widgets/elements/error_text.dart';
import 'package:medifirst/core/widgets/elements/loader.dart';
import 'package:medifirst/core/widgets/elements/section_heading_text.dart';
import 'package:medifirst/features/auth/controller/auth_controller.dart';
import 'package:medifirst/features/prescriptions/controller/prescription_controller.dart';
import 'package:medifirst/features/prescriptions/presentation/widgets/prescription_list_tile.dart';

import '../../../../core/theming/palette.dart';

class PrescriptionsScreen extends ConsumerStatefulWidget {
  const PrescriptionsScreen({super.key});

  @override
  ConsumerState createState() => _PrescriptionsScreenState();
}

class _PrescriptionsScreenState extends ConsumerState<PrescriptionsScreen> {
  late TextEditingController _controller;


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

  @override
  Widget build(BuildContext context) {
    final Size size = MediaQuery.sizeOf(context);
    final user = ref.watch(userProvider);
    return Scaffold(
      backgroundColor: Palette.backGroundColor,
      appBar: AppBar(
        backgroundColor: Palette.whiteColor,
        centerTitle: true,
        automaticallyImplyLeading: false,
        title: Text(
          'My Prescriptions',
          style: Palette.lightModeAppTheme.textTheme.bodySmall?.copyWith(
            fontSize: 20,
          ),
        ),
      ),
      body: SafeArea(child: SingleChildScrollView(
        child: Column(
          children: [
            (size.width * 12/852).pv,
            TextField(
              controller: _controller,
              style: Palette.lightModeAppTheme.textTheme.bodyMedium?.copyWith(
                fontSize: 12,
              ),
              decoration: InputDecoration(
                filled: true,
                fillColor: Palette.whiteColor,
                hintText: 'Search Prescriptions',
                hintStyle: Palette.lightModeAppTheme.textTheme.bodyMedium?.copyWith(
                  fontSize: 12,
                  color: Palette.hintTextGray,
                ),
                enabledBorder: OutlineInputBorder(
                  borderSide: const BorderSide(color: Palette.dividerGray, width: 1),
                  borderRadius: BorderRadius.circular(50),
                ),
                focusedBorder: OutlineInputBorder(
                  borderSide: const BorderSide(color: Palette.mainGreen, width: 1),
                  borderRadius: BorderRadius.circular(50),
                )
              ),
            ).sidePad(size.width * 16/393),
            (size.height * 32/852).pv,
            const SectionHeadingText(heading: 'TODAY').sidePad(size.width * 16/393).alignLeft(),
            (size.height * 15/852).pv,
            SizedBox(
              height: size.height * 70/852,
              child: ref.read(getTodayPrescriptionProvider(user!.uid)).when(data: (prescriptions){
                return ListView.builder(itemBuilder: (context, index){
                  final prescription = prescriptions[index];
                  return PrescriptionListTile(prescription: prescription, isToday: true);
                });
              }, error: (err,st)=>const ErrorText(error: 'No prescriptions due today'), loading: ()=>const Loader(),),
            ),
            (size.height * 40/852).pv,
            const SectionHeadingText(heading: 'SCHEDULED').sidePad(size.width * 16/393).alignLeft(),
            (size.height * 15/852).pv,
            SizedBox(
              height: size.height * 454/852,
              child: ref.read(getScheduledPrescriptionProvider(user.uid)).when(data: (prescriptions){
                return ListView.builder(itemBuilder: (context, index){
                  final prescription = prescriptions[index];
                  return PrescriptionListTile(prescription: prescription, isToday: true);
                });
              }, error: (err,st)=>const ErrorText(error: 'No prescriptions due today'), loading: ()=>const Loader(),),
            )
          ],
        ),
      ),),
    );
  }
}
