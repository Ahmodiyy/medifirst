import 'package:country_code_picker/country_code_picker.dart';
import 'package:flutter/material.dart';
import 'package:medifirst/core/theming/palette.dart';

class CountryCodeSelector extends StatefulWidget {
  final TextEditingController controller;
  const CountryCodeSelector({required this.controller, super.key});

  @override
  State<CountryCodeSelector> createState() => _CountryCodeSelectorState();
}

class _CountryCodeSelectorState extends State<CountryCodeSelector> {
  ValueNotifier<String> selectedCountry = ValueNotifier('Nigeria');
  ValueNotifier<String> countryCode = ValueNotifier('+234');

  @override
  Widget build(BuildContext context) {
    final Size size = MediaQuery.sizeOf(context);
    return Container(
      decoration: const BoxDecoration(
        border: Border(bottom: BorderSide(color: Palette.hintTextGray, width: 1.0)),
      ),
      child: CountryCodePicker(
        onChanged: (country) {
          selectedCountry.value = country.name!;
          widget.controller.text = country.dialCode!;
        },
        initialSelection: "NG",
        padding: EdgeInsets.zero,
        showDropDownButton: false,
        hideMainText: true,
        flagWidth: size.width * 32/393,
        alignLeft: true,
        textStyle: Palette.lightModeAppTheme.textTheme.bodySmall?.copyWith(
          fontSize: 12,
          color: Palette.hintTextGray,
        ),
      ),
    );
  }
}
