import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:intl/intl.dart';
import 'package:medifirst/core/constants/data.dart';
import 'package:medifirst/core/theming/palette.dart';
import 'package:medifirst/core/theming/spaces.dart';
import 'package:medifirst/core/widgets/elements/section_container.dart';
import 'package:medifirst/models/transaction_model.dart';

class TransactionListTile extends StatelessWidget {
  final TransactionModel transaction;
  const TransactionListTile({super.key, required this.transaction});

  @override
  Widget build(BuildContext context) {
    final Size size = MediaQuery.sizeOf(context);
    return SectionContainer(
      height: 70,
      child: Padding(
        padding: EdgeInsets.all(size.width * 16 / 393),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            SvgPicture.asset(Data.transactionLogo[transaction.type]!, width: size.height * 32/852, height: 50,),
            (size.height * 8/393).ph,
            Column(
              children: [
                Flexible(
                  child: Text(Data.transactionType[transaction.type]!, style: Palette.lightModeAppTheme.textTheme.bodySmall?.copyWith(
                    fontSize: 14,
                  ),),
                ),
                (size.height * 8/852).pv,
                Flexible(
                  child: RichText(text: TextSpan(
                    text: DateFormat.MMMd().format(transaction.date.toDate()),
                    style: Palette.lightModeAppTheme.textTheme.bodySmall?.copyWith(
                      color: Palette.highlightTextGray,
                    ),
                    children: [
                      TextSpan(
                        text: '. ${DateFormat.Hm().format(transaction.date.toDate())}',
                        style: Palette.lightModeAppTheme.textTheme.bodySmall?.copyWith(
                          color: Palette.highlightTextGray,
                        ),
                      )
                    ]
                  ),),
                ),
              ],
            ),
             Flexible(child: Container()),
            Column(
              children: [
                Flexible(
                  child: Text((transaction.isDebit)? '-${Data.numberFormat.format(transaction.amount)}': '${Data.numberFormat.format(transaction.amount)}', style: Palette.lightModeAppTheme.textTheme.bodySmall?.copyWith(
                    fontSize: 14,
                  ),),
                ),
                (size.height * 8/393).ph,
                Flexible(
                  child: Text((transaction.isCompleted)? 'Successful': 'Failed', style: Palette.lightModeAppTheme.textTheme.bodySmall?.copyWith(
                    fontSize: 14,
                    color: (transaction.isCompleted)? Palette.validationGreen : Palette.noRed,
                  ),),
                ),
              ],
            )
          ],
        ),
      ),
    );
  }
}
