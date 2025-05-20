import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:medifirst/core/theming/palette.dart';
import 'package:medifirst/core/theming/spaces.dart';
import 'package:medifirst/core/widgets/elements/section_heading_text.dart';
import 'package:medifirst/core/widgets/molecules/pay_with_medifirst_tile.dart';
import 'package:medifirst/models/appointment_info.dart';

class ConsultationCheckoutScreen extends ConsumerStatefulWidget {
  final AppointmentInfo appointment;
  const ConsultationCheckoutScreen({super.key, required this.appointment});

  @override
  ConsumerState createState() => _ConsultationCheckoutScreenState();
}

class _ConsultationCheckoutScreenState
    extends ConsumerState<ConsultationCheckoutScreen> {
  @override
  Widget build(BuildContext context) {
    final Size size = MediaQuery.sizeOf(context);
    return Scaffold(
      backgroundColor: Palette.backGroundColor,
      appBar: AppBar(
        backgroundColor: Palette.whiteColor,
        centerTitle: true,
        automaticallyImplyLeading: false,
        title: Text(
          'Checkout',
          style: Palette.lightModeAppTheme.textTheme.bodySmall?.copyWith(
            fontSize: 20,
          ),
        ),
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          child: Column(
            children: [
              (size.height * 32/852).pv,
              Text('Your appointment has ended', style: Palette.lightModeAppTheme.textTheme.bodyMedium?.copyWith(
                fontSize: 16,
              ),),
              (size.height * 28/852).pv,
              //TODO get price
              (size.height * 16/852).pv,
              Text(
                '30% Tax Included',
                style: Palette.lightModeAppTheme.textTheme.bodyMedium?.copyWith(
                  fontSize: 10,
                  color: Palette.discountGreen,
                ),
              ),
              (size.height * 32/852).pv,
              SectionHeadingText(heading: 'ORDER SUMMARY').sidePad(size.width * 16/852),
              (size.height * 12/852).pv,
              ConsultationCheckoutScreen(appointment: widget.appointment),
              (size.height * 24/852).pv,
              SectionHeadingText(heading: 'PAYMENT METHOD').sidePad(size.width * 16/852),
              (size.height * 12/852).pv,
              InkWell(onTap: (){

              }, child: PayWithMedifirstTile()),
            ],
          ),
        ),
      ),
    );
  }
}
