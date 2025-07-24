import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:medifirst/core/theming/palette.dart';
import 'package:medifirst/core/theming/spaces.dart';
import 'package:medifirst/core/widgets/elements/error_text.dart';
import 'package:medifirst/core/widgets/elements/loader.dart';
import 'package:medifirst/features/auth/controller/auth_controller.dart';
import 'package:medifirst/features/transactions/controller/transactions_controller.dart';
import 'package:medifirst/features/transactions/presentation/widgets/transaction_list_tile.dart';

class DoctorTransactionHistoryScreen extends ConsumerWidget {
  const DoctorTransactionHistoryScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final Size size = MediaQuery.sizeOf(context);
    final doctor = ref.watch(doctorProvider);
    return Scaffold(
      backgroundColor: Palette.backGroundColor,
      appBar: AppBar(
        backgroundColor: Palette.whiteColor,
        centerTitle: true,
        automaticallyImplyLeading: false,
        leading: IconButton(
          onPressed: () {
            Navigator.pop(context);
          },
          padding: EdgeInsets.only(right: size.width * 16 / 393),
          icon: const Icon(
            Icons.chevron_left_sharp,
            color: Palette.blackColor,
          ),
        ),
        title: Text(
          'Transaction History',
          style: Palette.lightModeAppTheme.textTheme.bodySmall?.copyWith(
            fontSize: 20,
          ),
        ),
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          child: Column(
            children: [
              (size.height * 22 / 852).pv,
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Text(
                        'All Categories',
                        style: Palette.lightModeAppTheme.textTheme.bodySmall
                            ?.copyWith(
                                fontSize: 17, color: Palette.hintTextGray),
                      ),
                      (size.width * 7 / 393).ph,
                      Icon(
                        Icons.keyboard_arrow_down_rounded,
                        size: 24,
                        color: Palette.highlightTextGray,
                      ),
                    ],
                  ),
                  Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Text(
                        'All',
                        style: Palette.lightModeAppTheme.textTheme.bodySmall
                            ?.copyWith(
                                fontSize: 17, color: Palette.hintTextGray),
                      ),
                      (size.width * 7 / 393).ph,
                      Icon(
                        Icons.keyboard_arrow_down_rounded,
                        size: 24,
                        color: Palette.highlightTextGray,
                      ),
                    ],
                  ),
                ],
              ).sidePad(size.width * 16 / 393),
              (size.height * 20 / 852).pv,
              SizedBox(
                height: size.height * 641 / 852,
                child: ref
                    .watch(getDoctorTransactionsProvider(doctor!.doctorId))
                    .when(
                      data: (transactions) {
                        return ListView.builder(
                          itemCount: transactions.length,
                          itemBuilder: (context, index) {
                            final transaction = transactions[index];
                            return Column(
                              children: [
                                TransactionListTile(transaction: transaction),
                                Divider(
                                  color: Palette.dividerGray,
                                  indent: size.width * 57 / 393,
                                  endIndent: size.width * 57 / 393,
                                ),
                              ],
                            );
                          },
                        );
                      },
                      error: (err, st) =>
                          ErrorText(error: 'No transactions available'),
                      loading: () => Loader(),
                    ),
              )
            ],
          ),
        ),
      ),
    );
  }
}
