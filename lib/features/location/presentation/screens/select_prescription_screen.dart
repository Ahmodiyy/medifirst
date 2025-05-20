import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:medifirst/core/theming/palette.dart';
import 'package:medifirst/core/widgets/elements/action_button_container.dart';
import 'package:medifirst/core/widgets/molecules/action_success_modal.dart';
import 'package:medifirst/core/widgets/molecules/error_modal.dart';
import 'package:medifirst/features/auth/controller/auth_controller.dart';
import 'package:medifirst/features/location/controller/location_controller.dart';
import 'package:medifirst/features/my_lists/controller/my_orders_controller.dart';
import 'package:medifirst/models/healthcare_centre_info.dart';
import 'package:medifirst/models/prescription_info.dart';

import '../../../../core/widgets/elements/error_text.dart';
import '../../../../core/widgets/elements/loader.dart';
import '../../../prescriptions/presentation/widgets/prescription_list_tile.dart';

class SelectPrescriptionScreen extends ConsumerStatefulWidget {
  final HealthcareCentreInfo pharmacy;
  const SelectPrescriptionScreen({super.key, required this.pharmacy});

  @override
  ConsumerState createState() => _SelectPrescriptionScreenState();
}

class _SelectPrescriptionScreenState
    extends ConsumerState<SelectPrescriptionScreen> {
  List<PrescriptionInfo> selectedPrescriptions = [];

  Future<void> uploadPrescriptions(WidgetRef ref, BuildContext context) async {
    if (selectedPrescriptions.isNotEmpty && mounted) {
      final controller = ref.read(locationControllerProvider);
      try {
        final res = await controller.uploadPrescriptionsToPharmacy(
            widget.pharmacy, selectedPrescriptions);
        showModalBottomSheet(
            context: context, builder: (context) => const ActionSuccessModal());
      } catch (e) {
        showModalBottomSheet(
            context: context,
            builder: (context) =>
                const ErrorModal(message: 'An error occurred'));
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final Size size = MediaQuery.sizeOf(context);
    final user = ref.watch(userProvider);
    return Scaffold(
      backgroundColor: Palette.backGroundColor,
      appBar: AppBar(
        backgroundColor: Palette.whiteColor,
        centerTitle: true,
        automaticallyImplyLeading: false,
        title: Text(
          'Select Prescription',
          style: Palette.lightModeAppTheme.textTheme.bodySmall?.copyWith(
            fontSize: 20,
          ),
        ),
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          child: Column(
            children: [
              SizedBox(
                height: size.height * 769 / 852,
                child: ref.read(getUsersPrescriptionsProvider(user!.uid)).when(
                      data: (prescriptions) {
                        return ListView.builder(itemBuilder: (context, index) {
                          final prescription = prescriptions[index];
                          return InkWell(
                            onTap: () {
                              if (selectedPrescriptions
                                  .contains(prescription)) {
                                selectedPrescriptions.remove(prescription);
                              } else {
                                selectedPrescriptions.add(prescription);
                              }
                            },
                            child: PrescriptionListTile(
                              prescription: prescription,
                              isToday:
                                  selectedPrescriptions.contains(prescription),
                            ),
                          );
                        });
                      },
                      error: (err, st) =>
                          const ErrorText(error: 'No prescriptions'),
                      loading: () => const Loader(),
                    ),
              ),
              InkWell(
                onTap: () => uploadPrescriptions(ref, context),
                child:
                    const ActionButtonContainer(title: 'Upload Prescriptions'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
