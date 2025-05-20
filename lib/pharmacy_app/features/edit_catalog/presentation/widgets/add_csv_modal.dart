import 'dart:convert';
import 'dart:io';
import 'package:flutter/services.dart' show rootBundle;

import 'package:csv/csv.dart';
import 'package:dotted_border/dotted_border.dart';
import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:medifirst/core/theming/spaces.dart';
import 'package:medifirst/core/widgets/molecules/error_modal.dart';
import 'package:medifirst/features/auth/controller/auth_controller.dart';
import 'package:medifirst/models/healthcare_centre_info.dart';
import 'package:medifirst/pharmacy_app/features/edit_catalog/controller/edit_catalog_controller.dart';

import '../../../../../core/theming/palette.dart';
import '../../../../../core/widgets/elements/action_button_container.dart';

class AddCSVModal extends ConsumerStatefulWidget {
  const AddCSVModal({super.key});

  @override
  ConsumerState createState() => _AddCSVModalState();
}

class _AddCSVModalState extends ConsumerState<AddCSVModal> {
  List<List<dynamic>> data = [];
  String fileName = '';
  int size = 0;

  Future<void> selectCSVFromStorage() async {
    FilePickerResult? result = await FilePicker.platform.pickFiles(
      allowedExtensions: ['csv'],
      type: FileType.custom,
    );
    if (result != null) {
      String? path = result.files.first.path;
      size = result.files.first.size;
      fileName = path!;
      final myData = await rootBundle.loadString(path!);
      List<List<dynamic>> csvTable =
          CsvToListConverter().convert(myData, eol: '\n');
      data = csvTable;
    }
  }

  Future<void> uploadCSVToFirestore(
      WidgetRef ref, HealthcareCentreInfo pharmacy) async {
    try {
      await ref.read(editCatalogControllerProvider).uploadBatchDrugs(
          data: data, pharmacyId: pharmacy.pId, pharmacyName: pharmacy.name);
    } catch (e) {
      if (mounted) {
        showModalBottomSheet(
            context: context,
            builder: (context) =>
                const ErrorModal(message: 'An error occurred'));
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final Size size = MediaQuery.sizeOf(context);
    final pharmacy = ref.watch(pharmacyProvider);
    return Container(
      height: size.height * 503 / 852,
      width: double.infinity,
      padding:
          EdgeInsets.only(bottom: MediaQuery.of(context).viewInsets.bottom),
      color: Palette.smallBodyGray,
      child: Container(
        width: double.infinity,
        padding: EdgeInsets.symmetric(
            vertical: size.height * 24 / 393,
            horizontal: size.width * 16 / 393),
        decoration: const BoxDecoration(
          borderRadius: BorderRadius.only(
              topRight: Radius.circular(20), topLeft: Radius.circular(20)),
          color: Palette.whiteColor,
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          children: [
            Text(
              'Upload File(s)',
              style: Palette.lightModeAppTheme.textTheme.bodyMedium?.copyWith(
                fontSize: 16,
              ),
            ).alignLeft(),
            (size.height * 19 / 852).pv,
            InkWell(
              onTap: () {
                selectCSVFromStorage();
                setState(() {});
              },
              child: DottedBorder(
                padding: EdgeInsets.zero,
                child: Container(
                  child: Center(
                    child: Column(
                      children: [
                        SvgPicture.asset(
                          'assets/icons/svgs/cloud_upload.svg',
                          height: size.height * 54 / 852,
                          width: size.height * 54 / 852,
                        ),
                        (size.height * 8 / 852).pv,
                        Text(
                          'Click to upload',
                          style: Palette.lightModeAppTheme.textTheme.bodyMedium
                              ?.copyWith(
                            fontSize: 12,
                            color: Palette.blueText,
                          ),
                        ),
                        (size.height * 8 / 852).pv,
                        Text(
                          'CSV File format only',
                          style: Palette.lightModeAppTheme.textTheme.bodySmall
                              ?.copyWith(
                            fontSize: 12,
                            color: Palette.messageHintText,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ),
            (size.height * 24 / 852).pv,
            Text(
              'UPLOADING',
              style: Palette.lightModeAppTheme.textTheme.bodySmall?.copyWith(
                fontSize: 10,
              ),
            ),
            (size.height * 12 / 852).pv,
            (data.isNotEmpty)
                ? Container(
                    width: double.infinity,
                    height: size.height * 91 / 852,
                    padding: EdgeInsets.symmetric(
                        vertical: size.height * 20 / 852,
                        horizontal: size.width * 21 / 393),
                    decoration: BoxDecoration(
                      color: Palette.messageFieldGray,
                    ),
                    child: Row(
                      children: [
                        SvgPicture.asset(
                          'assets/icons/svgs/adobe_pdf_colour.svg',
                          height: size.height * 38 / 852,
                          width: size.height * 38 / 852,
                        ),
                        (size.width * 12 / 393).ph,
                        Column(
                          children: [
                            Row(
                              children: [
                                Text(
                                  fileName,
                                  style: Palette
                                      .lightModeAppTheme.textTheme.bodyMedium
                                      ?.copyWith(
                                    fontSize: 16,
                                  ),
                                ),
                                Flexible(child: Container()),
                                InkWell(
                                  onTap: () {
                                    setState(() {
                                      data = [];
                                    });
                                  },
                                  child: Icon(
                                    Icons.close_rounded,
                                    color: Palette.blackColor,
                                    size: size.height * 10 / 852,
                                  ),
                                ),
                              ],
                            ),
                            (size.height * 10 / 852).pv,
                            Text(
                              '${size / 1024}KB',
                              style: Palette
                                  .lightModeAppTheme.textTheme.bodyMedium
                                  ?.copyWith(
                                fontSize: 12,
                                color: Palette.highlightTextGray,
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                  )
                : Container(),
            (size.height * 33 / 852).pv,
            Container(
              width: double.infinity,
              height: size.height * 52 / 852,
              padding: EdgeInsets.all(size.height * 10 / 852),
              decoration: BoxDecoration(
                color: Palette.tipBackgroundYellow,
              ),
              child: Row(
                children: [
                  SvgPicture.asset(
                    'assets/icons/svgs/warnings.svg',
                    height: size.height * 24 / 852,
                    width: size.height * 24 / 852,
                  ),
                  (size.width * 8 / 393).ph,
                  Text(
                    'Please ensure the document uploaded matches your selected option and profile details.',
                    style:
                        Palette.lightModeAppTheme.textTheme.bodySmall?.copyWith(
                      height: 0.11,
                      fontSize: 12,
                    ),
                  ),
                ],
              ),
            ),
            (size.height * 18 / 852).pv,
            Row(
              children: [
                SizedBox(
                    width: size.width * 170 / 393,
                    child: InkWell(
                      onTap: () {
                        Navigator.pop(context);
                      },
                      child: const ActionButtonContainer(
                        title: 'Cancel',
                        backGroundColor: Palette.highlightGreen,
                        titleColor: Palette.mainGreen,
                      ),
                    )),
                Flexible(child: Container()),
                SizedBox(
                  width: size.width * 170 / 393,
                  child: InkWell(
                    onTap: () => uploadCSVToFirestore(ref, pharmacy!),
                    child: const ActionButtonContainer(
                      title: 'Submit',
                    ),
                  ),
                ),
              ],
            ),
            (size.height*40/852).pv,
          ],
        ),
      ),
    );
  }
}
