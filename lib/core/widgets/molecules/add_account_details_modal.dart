import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:medifirst/core/theming/spaces.dart';
import 'package:medifirst/core/utils/utils.dart';
import 'package:medifirst/core/widgets/atoms/underlined_text_field.dart';

import '../../theming/palette.dart';
import '../elements/action_button_container.dart';
import '../elements/amount_textfield.dart';
import '../elements/section_container.dart';
import '../elements/section_heading_text.dart';

class AddAccountDetailsModal extends ConsumerStatefulWidget {
  final String id;
  const AddAccountDetailsModal({super.key, required this.id});

  @override
  ConsumerState createState() => _WithdrawalModalState();
}

class _WithdrawalModalState extends ConsumerState<AddAccountDetailsModal> {
  late TextEditingController _accountController;
  late TextEditingController _bankController;
  List<String> banks = ['Access Bank', 'Citibank', 'Ecobank', 'Fidelity', 'First Bank', 'First City Monument Bank', 'Globus Bank', 'Guaranty Trust Bank', 'Heritage Bank', 'Keystone Bank',
  'Optimus Bank', 'Parallex Bank', 'Polaris Bank', 'Premium Trust Bank', 'Providus Bank', 'Signature Bank', 'Stanbic IBTC Bank', 'Standard Chartered Bank', 'Sterling Bank', 'SunTrust Bank',
  'Titan Trust Bank', 'Union Bank', 'United Bank for Africa', 'Unity Bank', 'Wema Bank', 'Zenith Bank'];
  @override
  void initState() {
    super.initState();
    _accountController = TextEditingController();
    _bankController = TextEditingController();
  }

  @override
  void dispose() {
    _accountController.dispose();
    _bankController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final Size size = MediaQuery.sizeOf(context);
    return Container(
      height: size.height * 521 / 852,
      width: double.infinity,
      padding:
      EdgeInsets.only(bottom: MediaQuery.of(context).viewInsets.bottom),
      color: Palette.smallBodyGray,
      child: Container(
        width: double.infinity,
        padding: EdgeInsets.all(size.width * 18 / 393),
        decoration: const BoxDecoration(
          borderRadius: BorderRadius.only(
              topRight: Radius.circular(20), topLeft: Radius.circular(20)),
          color: Palette.whiteColor,
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          children: [
            InkWell(
              onTap: () {
                Navigator.pop(context);
              },
              child: Icon(
                Icons.close_rounded,
                color: Palette.errorBorderGray,
                size: size.height * 24 / 852,
              ),
            ).alignLeft(),
            (size.height*27/852).pv,
            Text(
              'ENTER 10 DIGIT ACCOUNT NUMBER',
              style: Palette.lightModeAppTheme.textTheme.bodyLarge?.copyWith(
                fontSize: 10,
                color: Palette.highlightTextGray,
              ),
            ).alignLeft(),
            (size.height * 30 / 852).pv,
            UnderlinedTextField(controller: _accountController, hint: '1234567890'),
            (size.height*40/852).pv,
            Text(
              'SELECT BANK',
              style: Palette.lightModeAppTheme.textTheme.bodyLarge?.copyWith(
                fontSize: 10,
                color: Palette.highlightTextGray,
              ),
            ).alignLeft(),
            (size.height * 30 / 852).pv,
            DropdownButton<String>(
              value: _bankController.text,
              icon: const Icon(Icons.arrow_downward),
              elevation: 16,
              style: const TextStyle(color: Palette.hintTextGray),
              underline: Container(
                height: 2,
                color: Palette.hintTextGray,
              ),
              onChanged: (String? value) {
                // This is called when the user selects an item.
                setState(() {
                  _bankController.text = value!;
                });
              },
              items: banks.map<DropdownMenuItem<String>>((String value) {
                return DropdownMenuItem<String>(
                  value: value,
                  child: Text(value, style: Palette.lightModeAppTheme.textTheme.bodySmall?.copyWith(
                    fontSize: 16,
                  ),),
                );
              }).toList(),
            ),
            Flexible(child: Container()),
            InkWell(
              onTap: () {
                if(_bankController.text.isNotEmpty && _accountController.text.isNotEmpty){
                  ref.read(accountNumberProvider.notifier).update((state) => _accountController.text);
                  ref.read(bankProvider.notifier).update((state) => _bankController.text);
                  Navigator.pop(context);
                }
              },
              child: const ActionButtonContainer(title: 'Done'),
            ),
          ],
        ),
      ),
    );
  }
}
