import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:medifirst/core/theming/palette.dart';
import 'package:medifirst/core/theming/spaces.dart';
import 'package:medifirst/core/widgets/atoms/underlined_text_field.dart';
import 'package:medifirst/core/widgets/elements/action_button_container.dart';
import 'package:medifirst/core/widgets/molecules/action_success_modal.dart';
import 'package:medifirst/core/widgets/molecules/error_modal.dart';
import 'package:medifirst/features/feedback_and_complaints/controller/feedback_controller.dart';

class ReportIssueScreen extends ConsumerStatefulWidget {
  const ReportIssueScreen({super.key});

  @override
  ConsumerState createState() => _ReportIssueScreenState();
}

class _ReportIssueScreenState extends ConsumerState<ReportIssueScreen> {
  late TextEditingController _firstNameController;
  late TextEditingController _lastNameController;
  late TextEditingController _emailController;
  late TextEditingController _issueController;
  bool isLoading = false;

  @override
  void initState() {
    super.initState();
    _firstNameController = TextEditingController();
    _lastNameController = TextEditingController();
    _emailController = TextEditingController();
    _issueController = TextEditingController();
  }

  @override
  void dispose() {
    _firstNameController.dispose();
    _lastNameController.dispose();
    _emailController.dispose();
    _issueController.dispose();
    super.dispose();
  }

  void postFeedback(WidgetRef ref, BuildContext context) async {
    setState(() {
      isLoading = true;
    });
    try {
      if (_firstNameController.text.isNotEmpty &&
          _lastNameController.text.isNotEmpty &&
          _emailController.text.isNotEmpty &&
          _issueController.text.isNotEmpty) {
        await ref.read(feedbackControllerProvider).sendFeedback(
            firstName: _firstNameController.text,
            surname: _lastNameController.text,
            email: _emailController.text,
            message: _issueController.text);
        showModalBottomSheet(
            context: context,
            builder: (context) {
              return const ActionSuccessModal();
            });
      }
    } catch (e) {
      FocusScope.of(context).unfocus();
      await Future.delayed(const Duration(milliseconds: 500));
      showModalBottomSheet(
          context: context,
          builder: (context) {
            return const ErrorModal(message: 'Please try again');
          });
    }
    setState(() {
      isLoading = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    final Size size = MediaQuery.sizeOf(context);
    return Scaffold(
      backgroundColor: Palette.whiteColor,
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
          'Report an Issue',
          style: Palette.lightModeAppTheme.textTheme.bodySmall?.copyWith(
            fontSize: 20,
          ),
        ),
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 20),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisSize: MainAxisSize.max,
              children: [
                Text(
                  "Let’s make your experience better!",
                  style:
                      Palette.lightModeAppTheme.textTheme.titleMedium?.copyWith(
                    fontSize: 34,
                  ),
                ),
                (size.height * 60 / 852).pv,
                Row(
                  children: [
                    SizedBox(
                        width: size.width * 170 / 393,
                        child: UnderlinedTextField(
                            controller: _firstNameController,
                            hint: 'First Name')),
                    Flexible(child: Container()),
                    SizedBox(
                        width: size.width * 170 / 393,
                        child: UnderlinedTextField(
                            controller: _lastNameController,
                            hint: 'Last Name')),
                  ],
                ),
                (size.height * 53 / 852).pv,
                UnderlinedTextField(
                    controller: _emailController, hint: 'Email Address'),
                (size.height * 53 / 852).pv,
                UnderlinedTextField(
                    controller: _issueController, hint: 'Report Issue'),
                (size.height * 60 / 852).pv,
                InkWell(
                  onTap: () => postFeedback(ref, context),
                  child: isLoading
                      ? const ActionButtonContainer(title: 'Loading...')
                      : const ActionButtonContainer(title: 'Done'),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
