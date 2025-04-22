import 'dart:typed_data';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:medifirst/core/theming/spaces.dart';
import 'package:medifirst/core/widgets/elements/action_button_container.dart';
import 'package:medifirst/core/widgets/elements/filter_tag.dart';
import 'package:medifirst/core/widgets/elements/section_heading_text.dart';
import 'package:medifirst/core/widgets/molecules/drug_page_drug_info.dart';
import 'package:medifirst/core/widgets/molecules/error_modal.dart';
import 'package:medifirst/features/auth/controller/auth_controller.dart';
import 'package:medifirst/pharmacy_app/features/edit_catalog/controller/edit_catalog_controller.dart';

import '../../../../../core/theming/palette.dart';
import '../../../../../core/utils/utils.dart';
import '../../../../../core/widgets/molecules/action_success_modal.dart';
import '../../../../../models/drug_info.dart';

class EditDrugScreen extends ConsumerStatefulWidget {
  final DrugInfo drug;
  const EditDrugScreen({super.key, required this.drug});

  @override
  ConsumerState createState() => _EditDrugScreenState();
}

class _EditDrugScreenState extends ConsumerState<EditDrugScreen> {
  Uint8List? image;

  void selectProfileImage() async {
    image = await pickOneImage();
    setState(() {});
  }

  Widget _getSideEffects(List<String> fx, double spacing) {
    return Wrap(
      spacing: spacing,
      children: fx.map((e) => FilterTag(label: e)).toList(),
    );
  }

  Future<void> editDrugInCatalog({required WidgetRef ref, required BuildContext context, required String drugId, required String pId})async{
    final controller = ref.read(editCatalogControllerProvider);
    try{
      if(image != null && mounted){
        await controller.editDrugInCatalog(image: image!, drugId: drugId, pId: pId);
        showModalBottomSheet(context: context, builder: (context)=>const ActionSuccessModal());
      }
    }catch(e){
      showModalBottomSheet(context: context, builder: (context)=>const ErrorModal(message: 'An error occurred'));
    }
  }

  @override
  Widget build(BuildContext context) {
    final Size size = MediaQuery.sizeOf(context);
    final pharmacy = ref.watch(pharmacyProvider);
    final drugData = widget.drug;
    return Scaffold(
      backgroundColor: Palette.backGroundColor,
      appBar: AppBar(
        backgroundColor: Palette.whiteColor,
        title: Text(
          drugData.drugName,
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
          ),
        ),
        actions: [
          InkWell(
            onTap: () {},
            child: SvgPicture.asset(
              'assets/icons/svgs/trash.svg',
              height: size.height * 24 / 852,
              width: size.height * 24 / 852,
            ),
          )
        ],
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          child: Column(
            children: [
              Stack(
                clipBehavior: Clip.none,
                children: [
                  Container(
                    width: double.infinity,
                    height: size.height * 315 / 852,
                    decoration: BoxDecoration(
                      image: (image == null)
                          ? DecorationImage(
                              image: NetworkImage(drugData.drugImageURL),
                              fit: BoxFit.fill,
                            )
                          : DecorationImage(
                              image: MemoryImage(image!),
                              fit: BoxFit.fill,
                            ),
                    ),
                    child: InkWell(
                      onTap: () {
                        pickOneImage();
                      },
                      child: Container(
                        width: size.width * 155 / 393,
                        height: size.height * 51 / 852,
                        decoration: BoxDecoration(
                          border: Border.all(color: Palette.whiteColor),
                          borderRadius: BorderRadius.circular(12),
                        ),
                        child: Center(
                          child: Text(
                            'Upload Image',
                            style: Palette
                                .lightModeAppTheme.textTheme.titleMedium
                                ?.copyWith(
                              color: Palette.whiteColor,
                              fontSize: 16,
                            ),
                          ),
                        ),
                      ),
                    ),
                  ),
                  FractionalTranslation(
                    translation: const Offset(0.0, 0.5),
                    child: InkWell(
                      onTap: () {
                        //TODO find out what the designer's intentions are
                      },
                      child: Container(
                        height: size.height * 43 / 852,
                        width: size.height * 43 / 852,
                        decoration: const ShapeDecoration(
                            shape: OvalBorder(), color: Palette.whiteColor),
                        child: const Icon(
                          Icons.edit,
                          color: Palette.errorBorderGray,
                        ),
                      ),
                    ),
                  ),
                ],
              ),
              DrugPageDrugInfo(
                name: drugData.drugName,
                dosage: drugData.dosage,
                price: drugData.price.toString(),
                pharmacy: drugData.pharmacyName,
                totalRating: drugData.totalRating,
                noOfReviews: drugData.numberOfReviews,
              ),
              (size.height * 40 / 852).pv,
              const SectionHeadingText(heading: 'SIDE EFFECTS')
                  .sidePad(size.width * 16 / 393)
                  .alignLeft(),
              (size.height * 16 / 852).pv,
              _getSideEffects(drugData.sideEffects, size.width * 4 / 393)
                  .sidePad(size.width * 16 / 393)
                  .alignLeft(),
              Flexible(child: Container()),
              InkWell(
                  onTap: () async{
                    editDrugInCatalog(ref: ref, context: context, drugId: drugData.drugId, pId: drugData.pharmacyId);
                  },
                  child: const ActionButtonContainer(title: 'Save Changes')
                      .sidePad(size.width * 16 / 393)),
              (size.height * 24 / 852).pv,
            ],
          ),
        ),
      ),
    );
  }
}
