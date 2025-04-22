
import 'package:flutter/material.dart';
import 'package:nigerian_states_and_lga/nigerian_states_and_lga.dart';

import '../../theming/palette.dart';

class StateAndLGADropdown extends StatefulWidget {
  final TextEditingController stateController;
  final TextEditingController lgaController;
  const StateAndLGADropdown({Key? key, required this.stateController, required this.lgaController}) : super(key: key);

  @override
  _StateAndLGADropdownState createState() => _StateAndLGADropdownState();
}

class _StateAndLGADropdownState extends State<StateAndLGADropdown> {
  late String _selectedState;
  late String _selectedLGA;
  late TextEditingController _stateController;
  late TextEditingController _lgaController;

  @override
  void initState() {
    super.initState();
    _selectedState = NigerianStatesAndLGA.allStates.first;
    _selectedLGA = NigerianStatesAndLGA.getStateLGAs(_selectedState).first;
    _stateController = widget.stateController;
    _lgaController = widget.lgaController;
    _stateController.text = _selectedState;
    _lgaController.text = _selectedLGA;
  }

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;

    return Row(
      children: [
        SizedBox(
          width: size.width * 170 / 393,
          child: FormField<String>(
            builder: (FormFieldState<String> state) {
              return InputDecorator(
                decoration: InputDecoration(
                  hintStyle: Palette.lightModeAppTheme.textTheme.bodySmall?.copyWith(
                    fontSize: 16,
                    color: Palette.hintTextGray,
                  ),
                  hintText: 'State',
                  filled: true,
                  fillColor: Palette.whiteColor,
                  enabledBorder: const UnderlineInputBorder(
                    borderSide: BorderSide(color: Palette.hintTextGray, width: 1),
                  ),
                  focusedBorder: const UnderlineInputBorder(
                    borderSide: BorderSide(color: Palette.mainGreen, width: 1),
                  ),
                ),
                child: DropdownButtonHideUnderline(
                  child: Theme(
                    data: Theme.of(context).copyWith(
                      canvasColor: Palette.whiteColor,
                    ),
                    child: DropdownButton<String>(
                      dropdownColor: Palette.whiteColor,
                      isExpanded: true,
                      isDense: true,
                      value: _selectedState,
                      onChanged: (String? newValue) {
                        if (newValue != null) {
                          setState(() {
                            _selectedState = newValue;
                            _stateController.text = newValue;
                            _selectedLGA = NigerianStatesAndLGA.getStateLGAs(newValue).first;
                            _lgaController.text = _selectedLGA;
                          });
                        }
                      },
                      items: NigerianStatesAndLGA.allStates.map<DropdownMenuItem<String>>((String value) {
                        return DropdownMenuItem<String>(
                          value: value,
                          child: Text(
                            value,
                            style: Palette.lightModeAppTheme.textTheme.bodySmall?.copyWith(
                              fontSize: 16,
                              color: Palette.blackColor,
                            ),
                          ),
                        );
                      }).toList(),
                    ),
                  ),
                ),
              );
            },
          ),
        ),
        Flexible(child: Container()),
        SizedBox(
          width: size.width * 170 / 393,
          child: FormField<String>(
            builder: (FormFieldState<String> state) {
              return InputDecorator(
                decoration: InputDecoration(
                  hintStyle: Palette.lightModeAppTheme.textTheme.bodySmall?.copyWith(
                    fontSize: 16,
                    color: Palette.hintTextGray,
                  ),
                  hintText: 'LGA',
                  filled: true,
                  fillColor: Palette.whiteColor,
                  enabledBorder: const UnderlineInputBorder(
                    borderSide: BorderSide(color: Palette.hintTextGray, width: 1),
                  ),
                  focusedBorder: const UnderlineInputBorder(
                    borderSide: BorderSide(color: Palette.mainGreen, width: 1),
                  ),
                ),
                child: DropdownButtonHideUnderline(
                  child: Theme(
                    data: Theme.of(context).copyWith(
                      canvasColor: Palette.whiteColor,
                    ),
                    child: DropdownButton<String>(
                      dropdownColor: Palette.whiteColor,
                      isExpanded: true,
                      isDense: true,
                      value: _selectedLGA,
                      onChanged: (String? newValue) {
                        if (newValue != null) {
                          setState(() {
                            _selectedLGA = newValue;
                            _lgaController.text = newValue;
                          });
                        }
                      },
                      items: NigerianStatesAndLGA.getStateLGAs(_selectedState)
                          .map<DropdownMenuItem<String>>((String value) {
                        return DropdownMenuItem<String>(
                          value: value,
                          child: Text(
                            value,
                            style: Palette.lightModeAppTheme.textTheme.bodySmall?.copyWith(
                              fontSize: 16,
                              color: Palette.blackColor,
                            ),
                          ),
                        );
                      }).toList(),
                    ),
                  ),
                ),
              );
            },
          ),
        ),
      ],
    );
  }
}