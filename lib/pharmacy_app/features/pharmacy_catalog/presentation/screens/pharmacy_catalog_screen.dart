import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_svg/svg.dart';
import 'package:medifirst/core/theming/palette.dart';
import 'package:medifirst/core/theming/spaces.dart';
import 'package:medifirst/core/widgets/elements/action_button_container.dart';
import 'package:medifirst/core/widgets/elements/section_heading_text.dart';
import 'package:medifirst/features/auth/controller/auth_controller.dart';
import 'package:medifirst/features/catalog/presentation/widgets/drug_catalog_card.dart';
import 'package:medifirst/pharmacy_app/features/edit_catalog/presentation/screens/add_drug_screen.dart';
import 'package:medifirst/pharmacy_app/features/edit_catalog/presentation/widgets/add_csv_modal.dart';

import '../../../../../core/widgets/elements/error_text.dart';
import '../../../../../core/widgets/elements/loader.dart';
import '../../../../../core/widgets/elements/rounded_edge_textfield.dart';
import '../../../../../features/catalog/controller/catalog_controller.dart';
import '../../../../../models/drug_info.dart';

class PharmacyCatalogScreen extends ConsumerStatefulWidget {
  const PharmacyCatalogScreen({super.key});

  @override
  ConsumerState createState() => _PharmacyCatalogScreenState();
}

class _PharmacyCatalogScreenState extends ConsumerState<PharmacyCatalogScreen> {
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
    final pharmacy = ref.watch(pharmacyProvider);
    return Scaffold(
      backgroundColor: Palette.backGroundColor,
      appBar: AppBar(
        backgroundColor: Palette.whiteColor,
        title: Text(
          'Catalog',
          style: Palette.lightModeAppTheme.textTheme.bodySmall?.copyWith(
            fontSize: 20,
            letterSpacing: -0.4,
          ),
        ),
        centerTitle: true,
        automaticallyImplyLeading: false,
        leading: InkWell(
            onTap: () {
              Navigator.pop(context);
            },
            child: const Icon(
              Icons.chevron_left,
              color: Palette.blackColor,
              size: 24,
            )),
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              (size.height * 4 / 852).pv,
              SizedBox(
                height: size.height * 48 / 852,
                child: Row(
                  children: [
                    SizedBox(
                      width: size.width * 309 / 393,
                      child: RoundedEdgeTextField(
                          controller: _controller,
                          isReadOnly: true,
                          prefixIcon: 'assets/icons/svgs/location.svg',
                          hint: 'Search Catalog'),
                    ),
                    Flexible(child: Container()),
                    InkWell(
                      onTap: () {},
                      child: Container(
                        height: size.height * 44 / 852,
                        width: size.width * 44 / 393,
                        decoration: BoxDecoration(
                          color: Palette.whiteColor,
                          borderRadius: BorderRadius.circular(50),
                          border: Border.all(
                              color: Palette.dividerGray, width: 1.0),
                        ),
                        child: Center(
                          child: SvgPicture.asset(
                            'assets/icons/svgs/search-filters.svg',
                            height: 24,
                            width: 24,
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ).sidePad(size.width * 16 / 393),
              (size.height * 12 / 852).pv,
              Text('Bulk upload multiple products using a CSV file.', style: Palette.lightModeAppTheme.textTheme.bodyMedium?.copyWith(
                fontSize: 12,
              ),),
              (size.height * 8 / 852).pv,
              InkWell(onTap: (){
                showModalBottomSheet(context: context, builder: (context)=>AddCSVModal());
              },child: ActionButtonContainer(title: 'Magic Upload', backGroundColor: Palette.redTextColor,).sidePad(size.width * 16/393)),
              (size.height * 19 / 852).pv,
              const SectionHeadingText(heading: 'MEDICINE CABINET')
                  .sidePad(size.width * 16 / 393)
                  .alignLeft(),
              (size.height * 12 / 852).pv,
              InkWell(
                onTap: () {
                  Navigator.push(context, MaterialPageRoute(builder: (context)=>const AddDrugScreen()));
                },
                child: Container(
                  width: double.infinity,
                  height: size.height * 56 / 852,
                  padding: EdgeInsets.all(size.width * 16 / 393),
                  decoration: const BoxDecoration(
                    color: Palette.whiteColor,
                  ),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      Text(
                        'Add drug to cabinet',
                        style: Palette.lightModeAppTheme.textTheme.bodySmall
                            ?.copyWith(
                          fontSize: 14,
                        ),
                      ),
                      const Icon(
                        Icons.add_rounded,
                        size: 24,
                        color: Palette.blueText,
                      ),
                    ],
                  ),
                ),
              ),
              (size.height * 26/852).pv,
              SizedBox(
                height: (size.height * 597/852),
                child: ref.watch(getCatalogProvider(pharmacy!.pId)).when(
                  data: (drugs) {
                    return GridView.builder(
                      gridDelegate:
                      SliverGridDelegateWithMaxCrossAxisExtent(
                          maxCrossAxisExtent: (size.width * 114/393),
                          childAspectRatio: 130 / 114,
                          crossAxisSpacing: size.width * 10/393,
                          mainAxisSpacing: size.width * 10/852),
                      itemCount: drugs.length,
                      itemBuilder: (context, index) {
                        DrugInfo drug = drugs[index];
                        return DrugCatalogCard(drug: drug);
                      },
                    );
                  },
                  error: (error, stackTrace) =>
                  const ErrorText(error: 'An error occurred'),
                  loading: () => const Loader(),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
