import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:medifirst/core/theming/palette.dart';
import 'package:medifirst/core/theming/spaces.dart';
import 'package:medifirst/core/widgets/atoms/drug_order_bar.dart';
import 'package:medifirst/core/widgets/elements/error_text.dart';
import 'package:medifirst/core/widgets/molecules/prescription_download_container.dart';
import 'package:medifirst/doctor_app/features/doctor_explore/presentation/widgets/expandable_section_heading.dart';
import 'package:medifirst/features/auth/controller/auth_controller.dart';
import 'package:medifirst/pharmacy_app/features/pharmacy_catalog/presentation/screens/pharmacy_catalog_screen.dart';
import 'package:medifirst/pharmacy_app/features/pharmacy_explore/controller/pharmacy_explore_controller.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../../../../../core/constants/constants.dart';
import '../../../../../core/widgets/elements/loader.dart';
import '../../../../../core/widgets/molecules/error_modal.dart';
import '../../../pharmacy_settings/presentation/screens/edit_pharmacy_profile_screen.dart';

class PharmacyExploreScreen extends ConsumerStatefulWidget {
  const PharmacyExploreScreen({super.key});

  @override
  ConsumerState createState() => _PharmacyExploreScreenState();
}

class _PharmacyExploreScreenState extends ConsumerState<PharmacyExploreScreen> {
  bool? isObscured;

  void isOrderObscured() async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    isObscured = prefs.getBool(Constants.obscuredPharmaKey);
    if (isObscured == null) {
      prefs.setBool(Constants.obscuredPharmaKey, true);
      isObscured = true;
    }
  }

  void toggleObscured() async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    isObscured = prefs.getBool(Constants.obscuredPharmaKey);
    final newValue = !isObscured!;
    prefs.setBool(Constants.obscuredPharmaKey, newValue);
    isObscured = newValue;
  }

  @override
  void initState() {
    super.initState();
    isOrderObscured();
  }

  @override
  Widget build(BuildContext context) {
    final Size size = MediaQuery.sizeOf(context);
    final pharmacy = ref.watch(pharmacyProvider);
    WidgetsBinding.instance.addPostFrameCallback((_){
      Future.delayed(Duration(seconds: 5), (){
        if(pharmacy == null){
          showModalBottomSheet(context: context, builder: (context)=>const ErrorModal(message: 'Please close the app and sign into the correct category'));
        }
      });
    });
    return Scaffold(
      backgroundColor: Palette.backGroundColor,
      body: SafeArea(
        child: SingleChildScrollView(
          child: Column(
            children: [
              (size.height * 32 / 852).pv,
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'Good day,',
                        style: Palette.lightModeAppTheme.textTheme.bodyMedium
                            ?.copyWith(
                          fontSize: 14,
                          height: 0,
                          letterSpacing: -0.4,
                        ),
                      ),
                      (size.height * 12 / 852).pv,
                      Text(
                        'How may I help you today?',
                        style: Palette.lightModeAppTheme.textTheme.titleMedium
                            ?.copyWith(
                          height: 0,
                          letterSpacing: -0.4,
                        ),
                      ),
                    ],
                  ),
                  InkWell(
                    onTap: (){
                      Navigator.push(context, MaterialPageRoute(builder: (context)=>EditPharmacyProfileScreen()));
                    },
                    child: CircleAvatar(
                      backgroundImage: NetworkImage(pharmacy!.pharmacyImgUrl),
                      radius: 24,
                    ),
                  ),
                ],
              ).sidePad(size.width * 16 / 393),
              (size.height * 21 / 852).pv,
              Container(
                width: (size.width * 361 / 393),
                height: (size.height * 106.5 / 852),
                padding: EdgeInsets.all(size.width * 16 / 393)
                    .copyWith(bottom: size.height * 20 / 852),
                decoration: BoxDecoration(
                  color: Palette.mainGreen,
                  borderRadius: BorderRadius.circular(10),
                ),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        Text(
                          'Total Orders',
                          style: Palette.lightModeAppTheme.textTheme.bodyMedium
                              ?.copyWith(
                            fontSize: 10,
                            color: Palette.whiteColor,
                          ),
                        ),
                        (size.width * 9 / 393).ph,
                        SvgPicture.asset(
                          'assets/icons/svgs/transaction_orders.svg',
                          height: 12,
                          width: 12,
                        ),
                        Flexible(child: Container()),
                        InkWell(
                          onTap: () {
                            toggleObscured();
                          },
                          child: Icon(
                            (isObscured == true)
                                ? Icons.visibility_outlined
                                : Icons.visibility_off_outlined,
                            color: Palette.whiteColor,
                            size: 16,
                          ),
                        ),
                      ],
                    ),
                    ref.watch(getPharmaOrdersTotalProvider(pharmacy.pId)).when(
                          data: (data) => Text(
                            '$data',
                            style: Palette
                                .lightModeAppTheme.textTheme.titleSmall
                                ?.copyWith(
                              fontSize: 32,
                              color: Palette.whiteColor,
                            ),
                          ),
                          error: (err, stack) =>
                              const ErrorText(error: 'An error occurred'),
                          loading: () => const Loader(),
                        ),
                  ],
                ),
              ).sidePad(size.width * 16 / 393),
              (size.height * 24 / 852).pv,
              InkWell(
                onTap: () {
                  Navigator.push(context, MaterialPageRoute(builder: (context)=>const PharmacyCatalogScreen()));
                },
                child: Container(
                  height: size.height * 87.5 / 852,
                  width: double.infinity,
                  padding: EdgeInsets.all(size.width * 16 / 393),
                  decoration: const BoxDecoration(
                    color: Palette.whiteColor,
                  ),
                  child: Row(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      SizedBox(
                        width: (size.width * 203 / 393),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              'Manage your inventory',
                              style: Palette
                                  .lightModeAppTheme.textTheme.titleSmall
                                  ?.copyWith(
                                fontSize: 14,
                                height: 0,
                              ),
                            ),
                            (size.height * 8 / 852).pv,
                            Text(
                              'Upload new products, set price and other information fo your catalog.',
                              style: Palette
                                  .lightModeAppTheme.textTheme.bodySmall
                                  ?.copyWith(
                                color: Palette.messageHintText,
                                height: 1.2,
                              ),
                            ),
                          ],
                        ),
                      ),
                      Flexible(child: Container()),
                      const Icon(
                        Icons.chevron_right,
                        size: 24,
                        color: Palette.blackColor,
                      ),
                    ],
                  ),
                ),
              ),
              (size.height * 28 / 852).pv,
              const ExpandableSectionHeading(heading: 'E-PRESCRIPTIONS')
                  .sidePad(size.width * 16 / 393),
              (size.height * 12 / 852).pv,
              SizedBox(
                height: size.height * 186/852,
                child: ref.watch(getPharmaPrescriptionsProvider(pharmacy.pId)).when(
                    data: (prescriptions) {
                      if(prescriptions.isEmpty){
                        return const ErrorText(error: 'No prescriptions available.');
                      }else{
                        return ListView.builder(itemBuilder: (context, index){
                          if(index<=1){
                            final prescription = prescriptions[index];
                            return PrescriptionDownloadContainer(prescription: prescription);
                          }
                          return null;
                        });
                      }
                    },
                    error: (err, st) =>
                        const ErrorText(error: 'No prescriptions available.'),
                    loading: () => const Loader()),
              ),
              (size.height * 28 / 852).pv,
              const ExpandableSectionHeading(heading: 'DRUG ORDERS')
                  .sidePad(size.width * 16 / 393),
              (size.height * 12 / 852).pv,
              SizedBox(
                height: size.height * 198/852,
                child: ref.watch(getPharmaOrdersProvider(pharmacy.pId)).when(
                    data: (orders) {
                      if(orders.isEmpty){
                        return const ErrorText(error: 'No orders available.');
                      }else{
                        return ListView.builder(itemBuilder: (context, index){
                          if(index<=1){
                            final order = orders[index];
                            return DrugOrderBar(order: order);
                          }
                          return null;
                        });
                      }
                    },
                    error: (err, st) =>
                    const ErrorText(error: 'No orders available.'),
                    loading: () => const Loader()),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
