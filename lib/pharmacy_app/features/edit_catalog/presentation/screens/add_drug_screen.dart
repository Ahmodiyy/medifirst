import 'dart:typed_data';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:medifirst/core/theming/spaces.dart';
import 'package:medifirst/core/widgets/atoms/underlined_text_field.dart';
import 'package:medifirst/core/widgets/elements/action_button_container.dart';
import 'package:medifirst/core/widgets/elements/removable_filter_tag.dart';
import 'package:medifirst/core/widgets/molecules/action_success_modal.dart';
import 'package:medifirst/core/widgets/molecules/error_modal.dart';
import 'package:medifirst/models/healthcare_centre_info.dart';
import 'package:medifirst/pharmacy_app/features/edit_catalog/controller/edit_catalog_controller.dart';

import '../../../../../core/theming/palette.dart';
import '../../../../../core/utils/utils.dart';
import '../../../../../features/auth/controller/auth_controller.dart';

class AddDrugScreen extends ConsumerStatefulWidget {
  const AddDrugScreen({super.key});

  @override
  ConsumerState createState() => _AddDrugScreenState();
}

class _AddDrugScreenState extends ConsumerState<AddDrugScreen> {
  late TextEditingController _nameController;
  late TextEditingController _sideFxController;
  late TextEditingController _priceController;
  Uint8List? image;
  List<String> sideFx = [];

  void selectImage(BuildContext context) async {
    var temp = await pickOneImage();
    if (temp.lengthInBytes <= 2097152 && mounted) {
      image = temp;
      setState(() {});
    } else {
      showModalBottomSheet(
          context: context,
          builder: (context) =>
              const ErrorModal(message: 'Image is too large.'));
    }
  }

  Future<void> addDrugToCatalog({required WidgetRef ref, required BuildContext context, required HealthcareCentreInfo pharm})async{
    final controller = ref.read(editCatalogControllerProvider);
    try{
      if(image != null && _nameController.text.isNotEmpty && _priceController.text.isNotEmpty && mounted){
        await controller.addDrugToCatalog(image: image!, pId: pharm.pId, drugName: _nameController.text, price: _priceController.text, sideFx: sideFx, pharmacyName: pharm.name);
        showModalBottomSheet(context: context, builder: (context)=>const ActionSuccessModal());
      }
    }catch(e){
      if(mounted){
        showModalBottomSheet(context: context, builder: (context)=>const ErrorModal(message: 'Enter all fields'));
      }
    }
  }

  @override
  void initState() {
    super.initState();
    _nameController = TextEditingController();
    _sideFxController = TextEditingController();
    _priceController = TextEditingController();
  }

  @override
  void dispose() {
    _nameController.dispose();
    _sideFxController.dispose();
    _priceController.dispose();
    super.dispose();
  }

  void addSideEffect(String effect) {
    sideFx.add(effect);
    _sideFxController.text = '';
    setState(() {});
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
          'Untitled',
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
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          child: Column(
            children: [
              Container(
                width: double.infinity,
                height: size.height * 315 / 852,
                decoration: BoxDecoration(
                  color: Palette.containerBgGray,
                  image: (image == null)
                      ? null
                      : DecorationImage(
                          image: MemoryImage(image!), fit: BoxFit.fill),
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    (size.height * 132 / 852).pv,
                    InkWell(
                      onTap: () => selectImage(context),
                      child: Container(
                        height: size.height * 51 / 852,
                        width: size.width * 155 / 393,
                        decoration: BoxDecoration(
                          color: Palette.grayBgContrastButtonGray,
                          border: Border.all(color: Palette.dividerGray),
                          borderRadius: BorderRadius.circular(12),
                        ),
                        child: Center(
                          child: Text(
                            'Upload Image',
                            style: Palette
                                .lightModeAppTheme.textTheme.titleMedium
                                ?.copyWith(
                              fontSize: 16,
                            ),
                          ),
                        ),
                      ),
                    ),
                    (size.height * 72 / 852).pv,
                    Text(
                      'Click to upload',
                      style: Palette.lightModeAppTheme.textTheme.titleMedium
                          ?.copyWith(
                        color: Palette.blueText,
                        fontSize: 12,
                      ),
                    ),
                    Text(
                      'Jpeg, Png or Pdf formats with a maximum size of 2MB',
                      style: Palette.lightModeAppTheme.textTheme.titleMedium
                          ?.copyWith(
                        color: Palette.messageHintText,
                        fontSize: 12,
                      ),
                    ),
                  ],
                ),
              ),
              (size.height * 32 / 852).pv,
              UnderlinedTextField(
                      controller: _nameController, hint: 'Name of drug')
                  .sidePad(size.width * 16 / 393),
              (size.height * 32 / 852).pv,
              UnderlinedTextField(
                controller: _sideFxController,
                onSubmitted: addSideEffect,
                hint: 'Side effect(if any)',
              ).sidePad(size.width * 16 / 393),
              (size.height * 32 / 852).pv,
              SizedBox(
                width: size.width * 104 / 393,
                child: UnderlinedTextField(
                    controller: _priceController, hint: 'Price'),
              ).sidePad(size.width * 16 / 393).alignLeft(),
              (size.height * 20 / 852).pv,
              Wrap(
                children: sideFx
                    .map((e) => InkWell(
                        onTap: () {
                          sideFx.remove(e);
                          setState(() {
                          });
                        },
                        child: RemovableFilterTag(label: e)))
                    .toList(),
              ).sidePad(size.width * 16 / 393).alignLeft(),
              (size.height * 60 / 852).pv,
              InkWell(
                onTap: ()async{
                  await addDrugToCatalog(ref: ref, context: context, pharm: pharmacy!);
                },
                child: const ActionButtonContainer(title: 'Done'),
              ).sidePad(size.width * 16 / 393),
              (size.height * 24 / 852).pv,
            ],
          ),
        ),
      ),
    );
  }
}
