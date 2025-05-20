import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:medifirst/core/theming/palette.dart';
import 'package:medifirst/core/widgets/atoms/underlined_text_field.dart';
import 'package:medifirst/core/widgets/elements/action_button_container.dart';
import 'package:medifirst/core/widgets/molecules/error_modal.dart';

class PasswordResetScreen extends StatefulWidget {
  const PasswordResetScreen({Key? key}) : super(key: key);

  @override
  _PasswordResetScreenState createState() => _PasswordResetScreenState();
}

class _PasswordResetScreenState extends State<PasswordResetScreen> {
  final TextEditingController _emailController = TextEditingController();
  bool _isLoading = false;

  @override
  void dispose() {
    _emailController.dispose();
    super.dispose();
  }

  Future<void> _resetPassword() async {
    if (_emailController.text.trim().isEmpty) {
      FocusScope.of(context).unfocus();
      await Future.delayed(const Duration(milliseconds: 500));
      _showErrorModal('Please enter your email address.');
      return;
    }

    setState(() {
      _isLoading = true;
    });

    try {
      await FirebaseAuth.instance.sendPasswordResetEmail(
        email: _emailController.text.trim(),
      );
      _showSuccessModal('Password reset email sent. Please check your inbox.');
    } on FirebaseAuthException catch (e) {
      FocusScope.of(context).unfocus();
      await Future.delayed(const Duration(milliseconds: 500));
      _showErrorModal(e.message ?? 'An error occurred. Please try again.');
    } catch (e) {
      FocusScope.of(context).unfocus();
      await Future.delayed(const Duration(milliseconds: 500));
      _showErrorModal('An unexpected error occurred. Please try again.');
    } finally {
      setState(() {
        _isLoading = false;
      });
    }
  }

  void _showErrorModal(String message) {
    showModalBottomSheet(
      context: context,
      builder: (context) => SingleChildScrollView(
        child: ErrorModal(message: message),
      ),
    );
  }

  void _showSuccessModal(String message) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('Success'),
          content: Text(message),
          actions: <Widget>[
            TextButton(
              child: const Text('OK'),
              onPressed: () {
                Navigator.of(context).pop();
                Navigator.of(context).pop(); // Return to login screen
              },
            ),
          ],
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    final Size size = MediaQuery.of(context).size;

    return Scaffold(
      backgroundColor: Palette.whiteColor,
      appBar: AppBar(
        backgroundColor: Palette.whiteColor,
        elevation: 0,
        leading: IconButton(
          padding: EdgeInsets.zero,
          onPressed: () => Navigator.pop(context),
          icon: const Icon(
            Icons.chevron_left,
            color: Palette.blackColor,
            size: 24,
          ),
        ),
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          child: Padding(
            padding: EdgeInsets.symmetric(horizontal: size.width * 16.0 / 393),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                SizedBox(height: size.height * 40 / 852),
                Text(
                  'Reset Password',
                  style: Theme.of(context).textTheme.headlineMedium?.copyWith(
                    fontSize: 36,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                SizedBox(height: size.height * 20 / 852),
                Text(
                  'Enter your email address and we\'ll send you a link to reset your password.',
                  style: Theme.of(context).textTheme.bodyMedium,
                ),
                SizedBox(height: size.height * 40 / 852),
                UnderlinedTextField(
                  controller: _emailController,
                  hint: 'Email',
                  textInputType: TextInputType.emailAddress,
                ),
                SizedBox(height: size.height * 40 / 852),
                InkWell(
                  onTap: _isLoading ? null : _resetPassword,
                  child: _isLoading
                      ? const Center(
                    child: CircularProgressIndicator(
                      color: Palette.mainGreen,
                    ),
                  )
                      : const ActionButtonContainer(title: 'Send Reset Link'),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
