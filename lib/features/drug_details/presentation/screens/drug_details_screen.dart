import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:intl/intl.dart';
import 'package:medifirst/core/constants/data.dart';
import 'package:medifirst/core/theming/spaces.dart';
import 'package:medifirst/core/widgets/elements/action_button_container.dart';
import 'package:medifirst/core/widgets/elements/error_text.dart';
import 'package:medifirst/core/widgets/elements/loader.dart';
import 'package:medifirst/core/widgets/elements/section_heading_text.dart';
import 'package:medifirst/core/widgets/molecules/drug_page_drug_info.dart';
import 'package:medifirst/core/widgets/molecules/error_modal.dart';
import 'package:medifirst/core/widgets/molecules/review_card.dart';
import 'package:medifirst/features/auth/controller/auth_controller.dart';
import 'package:medifirst/features/cart_and_checkout/presentation/screens/cart_screen.dart';
import 'package:medifirst/features/drug_details/controller/drug_details_controller.dart';
import 'package:medifirst/features/drug_details/presentation/widgets/item_tag.dart';
import 'package:medifirst/models/drug_info.dart';
import 'package:medifirst/models/user_info.dart';

import '../../../../core/theming/palette.dart';

class DrugDetailsScreen extends ConsumerStatefulWidget {
  final DrugInfo drug;
  const DrugDetailsScreen({super.key, required this.drug});

  @override
  ConsumerState createState() => _DrugDetailsScreenState();
}

class _DrugDetailsScreenState extends ConsumerState<DrugDetailsScreen> {
  final value = NumberFormat('#,##0.00', 'en_US');

  Future<void> addToCart({required WidgetRef ref, required UserInfoModel user, required DrugInfo drug})async{
    try{
      final controller = ref.read(drugDetailsControllerProvider);
      await controller.addToCart(uid: user.uid, drugId: drug.drugId, pharmacyId: drug.pharmacyId, pharmacyName: drug.pharmacyName, brand: drug.brandName, orderUnit: Data.pkgUnits[0], quantity: 1, drugName: drug.drugName, price: drug.price, dosage: drug.dosage, drugImageURL: drug.drugImageURL);
    }catch(e){
      showModalBottomSheet(context: context, builder: (context)=>const ErrorModal(message: 'An error occurred'));
    }
  }

  @override
  Widget build(BuildContext context) {
    final DrugInfo drug = widget.drug;
    final user = ref.watch(userProvider);
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
              padding: const EdgeInsets.only(right: 16),
              icon: const Icon(
                Icons.chevron_left_sharp,
                color: Palette.blackColor,
              ),
            ),
            Text(
              'Catalog',
              style: Palette.lightModeAppTheme.textTheme.bodySmall?.copyWith(
                fontSize: 16,
                color: Palette.highlightTextGray,
              ),
            ),
          ],
        ),
        title: Text(
          drug.drugName,
          style: Palette.lightModeAppTheme.textTheme.bodySmall?.copyWith(
            fontSize: 20,
          ),
        ),
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Container(
                width: double.infinity,
                height: size.height * 315 / 393,
                padding: EdgeInsets.symmetric(
                    vertical: size.height * 20 / 852,
                    horizontal: size.width * 16 / 393),
                decoration: BoxDecoration(
                  image: DecorationImage(
                    image: NetworkImage(drug.drugImageURL),
                    fit: BoxFit.fill,
                  ),
                ),
                child: Align(
                  alignment: Alignment.topRight,
                  child: Container(
                    height: 43,
                    width: 43,
                    decoration: const ShapeDecoration(
                      shape: OvalBorder(),
                      color: Palette.whiteColor,
                    ),
                    child: Center(
                      child: SvgPicture.asset(
                        'assets/icons/svgs/heart_outline.svg',
                        height: 24,
                        width: 24,
                      ),
                    ),
                  ),
                ),
              ),
              DrugPageDrugInfo(
                  name: drug.drugName,
                  dosage: drug.dosage,
                  price: value.format(drug.price),
                  pharmacy: drug.pharmacyName,
                  totalRating: drug.totalRating,
                  noOfReviews: drug.numberOfReviews),
              (size.height * 16 / 852).pv,
              const Divider(
                thickness: 1,
                color: Palette.dividerGray,
              ),
              (size.height * 24 / 852).pv,
              const SectionHeadingText(heading: 'ABOUT')
                  .sidePad(size.width * 16 / 393)
                  .alignLeft(),
              (size.height * 16 / 852).pv,
              Text(
                drug.aboutDrug,
                style: Palette.lightModeAppTheme.textTheme.bodySmall?.copyWith(
                  fontSize: 12,
                ),
              ).sidePad(size.width * 16 / 393),
              (size.height * 24 / 852).pv,
              const SectionHeadingText(heading: 'SIDE EFFECTS')
                  .sidePad(16)
                  .alignLeft(),
              (size.height * 16 / 852).pv,
              SizedBox(
                height: size.height * 25/852,
                child: ListView.builder(
                  scrollDirection: Axis.horizontal,
                  itemCount: drug.sideEffects.length,
                  itemBuilder: (context, index) {
                    final effect = drug.sideEffects[index];
                    return Padding(
                      padding: const EdgeInsets.only(right: 2.0),
                      child: ItemTag(tag: effect),
                    );
                  },
                ),
              ).sidePad(size.width * 16 / 393),
              (size.height * 24 / 852).pv,
              const SectionHeadingText(heading: 'CURABLE SYMPTOMS')
                  .sidePad(size.width * 16 / 393)
                  .alignLeft(),
              (size.height * 16 / 852).pv,
              SizedBox(
                height: size.height * 25/852,
                child: ListView.builder(
                  scrollDirection: Axis.horizontal,
                  itemCount: drug.curableSymptoms.length,
                  itemBuilder: (context, index) {
                    final effect = drug.curableSymptoms[index];
                    return Padding(
                      padding: const EdgeInsets.only(right: 2.0),
                      child: ItemTag(tag: effect),
                    );
                  },
                ),
              ).sidePad(size.width * 16 / 393),
              (size.height * 24 / 852).pv,
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  const SectionHeadingText(heading: 'RATINGS AND REVIEWS'),
                  GestureDetector(
                      onTap: () {},
                      child: const Icon(
                        Icons.add,
                        color: Palette.mainGreen,
                        size: 20,
                      )),
                ],
              ).sidePad(size.width * 16 / 393),
              (size.height * 16 / 852).pv,
              SizedBox(
                height: (size.height * 100 / 852),
                child: ref.watch(getDrugReviewsProvider(drug)).when(
                    data: (reviews) {
                      return ListView.builder(
                          itemCount: reviews.length,
                          itemBuilder: (context, index) {
                            final review = reviews[index];
                            return ReviewCard(review: review);
                          });
                    },
                    error: (error, stackTrace) =>
                        const ErrorText(error: 'An error occurred'),
                    loading: () => const Loader()),
              ),
              (size.height * 24 / 852).pv,
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  //TODO add function to add to cart
                  SizedBox(
                      width: size.width * 170 / 393,
                      child: InkWell(
                        onTap: ()async{
                          await addToCart(ref: ref, user: user!, drug: drug);
                        },
                        child: const ActionButtonContainer(
                          title: 'Add to cart',
                          backGroundColor: Palette.highlightGreen,
                          titleColor: Palette.mainGreen,
                        ),
                      )),
                  Flexible(child: Container()),
                  //TODO add function to add to cart and go direct to buy screen
                  SizedBox(
                      width: size.width * 170 / 393,
                      child: InkWell(
                        onTap: ()async{
                          await addToCart(ref: ref, user: user!, drug: drug);
                          Navigator.push(context, MaterialPageRoute(builder: (context)=>const CartScreen()));
                        },
                        child: const ActionButtonContainer(
                          title: 'Buy now',
                        ),
                      )),
                ],
              ),
              (size.height * 24 / 852).pv
            ],
          ),
        ),
      ),
    );
  }
}
