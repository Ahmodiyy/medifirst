import 'package:flutter/material.dart';
import 'package:medifirst/core/theming/spaces.dart';
import 'package:medifirst/core/widgets/atoms/underlined_text_field.dart';

import '../elements/country_code_selector.dart';

class PhoneTextField extends StatefulWidget {
  final TextEditingController codeController;
  final TextEditingController phoneController;
  const PhoneTextField({required this.codeController, required this.phoneController, super.key});

  @override
  State<PhoneTextField> createState() => _PhoneTextFieldState();
}

class _PhoneTextFieldState extends State<PhoneTextField> {
  @override
  Widget build(BuildContext context) {
    final Size size = MediaQuery.sizeOf(context);
    return Row(
      children: [
        SizedBox(
          width: size.width * 97/393,
          child: CountryCodeSelector(controller: widget.codeController),
        ),
        (size.width * 14/393).ph,
        SizedBox(
          width: (size.width * 240/393),
          child: UnderlinedTextField(
            controller: widget.phoneController,
            hint: 'Phone Number',
            textInputType: TextInputType.phone,
          ),
        ),
      ],
    );
  }
}
