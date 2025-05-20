import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:medifirst/core/theming/palette.dart';
import 'package:medifirst/core/theming/spaces.dart';
import 'package:medifirst/core/widgets/atoms/location_search_bar.dart';
import 'package:medifirst/core/widgets/elements/error_text.dart';
import 'package:medifirst/core/widgets/elements/filter_tag.dart';
import 'package:medifirst/core/widgets/elements/loader.dart';
import 'package:medifirst/core/widgets/molecules/drug_card.dart';
import 'package:medifirst/features/catalog/controller/catalog_controller.dart';
import 'package:medifirst/models/drug_info.dart';

class CatalogScreen extends ConsumerStatefulWidget {
  final String pharmacyId;
  const CatalogScreen({super.key, required this.pharmacyId});

  @override
  ConsumerState createState() => _CatalogScreenState();
}

class _CatalogScreenState extends ConsumerState<CatalogScreen> {
  List<String> searchTags = [];

  @override
  Widget build(BuildContext context) {
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
            Text(
              'Map',
              style: Palette.lightModeAppTheme.textTheme.bodySmall?.copyWith(
                fontSize: 16,
                color: Palette.highlightTextGray,
              ),
            ),
          ],
        ),
        title: Text(
          'Catalog',
          style: Palette.lightModeAppTheme.textTheme.bodySmall?.copyWith(
            fontSize: 20,
          ),
        ),
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            mainAxisSize: MainAxisSize.max,
            mainAxisAlignment: MainAxisAlignment.start,
            children: [
              (size.height * 4/852).pv,
              //TODO change this
              LocationSearchBar(controller: TextEditingController()),
              (size.height * 16/852).pv,
              ListView(
                scrollDirection: Axis.horizontal,
                children: searchTags.map((e) {
                  return Padding(
                    padding:  EdgeInsets.only(right: size.width * 4/393),
                    child: FilterTag(
                      label: e,
                    ),
                  );
                }).toList(),
              ),
              (size.height * 20/852).pv,
              SizedBox(
                height: (size.height * 597/852),
                child: ref.watch(getCatalogProvider(widget.pharmacyId)).when(
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
                            return DrugCard(drug: drug);
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
