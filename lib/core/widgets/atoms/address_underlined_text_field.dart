import 'dart:io' show Platform;

import 'package:flutter/material.dart';
import 'package:google_places_flutter/google_places_flutter.dart';
import 'package:google_places_flutter/model/prediction.dart';

//import '../../constants/credentials.dart';
import '../../theming/palette.dart';

class AddressUnderlinedTextField extends StatelessWidget {
  final TextEditingController controller;
  final FocusNode focus;
  final Function(Prediction prediction) latLngCallback;
  final Function(Prediction prediction) clickCallback;

  const AddressUnderlinedTextField(
      {super.key,
      required this.controller,
      required this.latLngCallback,
      required this.clickCallback,
      required this.focus});

  @override
  Widget build(BuildContext context) {
    final Size size = MediaQuery.sizeOf(context);
    return GooglePlaceAutoCompleteTextField(
      textEditingController: controller,
      debounceTime: 400,
      focusNode: focus,
      isLatLngRequired: true,
      getPlaceDetailWithLatLng: latLngCallback,
      itemClick: clickCallback,
      seperatedBuilder: const Divider(
        color: Palette.dividerGray,
      ),
      isCrossBtnShown: true,
      googleAPIKey: (Platform.isAndroid)
          ? const String.fromEnvironment('androidAPIKey', defaultValue: '')
          : const String.fromEnvironment('iosAPIKey', defaultValue: ''),
      itemBuilder: (context, index, Prediction prediction) {
        focus.requestFocus();
        return Container(
          padding: EdgeInsets.all(size.height * 10 / 852),
          child: Row(
            children: [
              const Icon(Icons.location_on),
              const SizedBox(
                width: 7,
              ),
              Expanded(child: Text(prediction.description ?? ""))
            ],
          ),
        );
      },
      boxDecoration: BoxDecoration(
        border: Border(),
      ),
      inputDecoration: InputDecoration(
        hintText: 'Address',
        hintStyle: Palette.lightModeAppTheme.textTheme.bodySmall?.copyWith(
          color: Palette.hintTextGray,
          fontSize: 16,
        ),
        enabledBorder: const UnderlineInputBorder(
          borderSide: BorderSide(color: Palette.hintTextGray, width: 1),
        ),
        focusedBorder: const UnderlineInputBorder(
          borderSide: BorderSide(color: Palette.mainGreen, width: 1),
        ),
      ),
    );
  }
}
