import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:material_loading_buttons/material_loading_buttons.dart'
    show FilledAutoLoadingButton;
import 'package:provider/provider.dart';
import 'package:zaratask/core/utils/service_locator.dart';
import 'package:zaratask/providers/auth_provider.dart';
import 'package:zaratask/services/messenger_service.dart';
import 'package:zaratask/widgets/form_fields/material_3_text_form_field.dart';

class VerifyOtpForEmailSignInScreen extends StatefulWidget {
  const VerifyOtpForEmailSignInScreen(this.email, {super.key});

  final String? email;

  @override
  State<VerifyOtpForEmailSignInScreen> createState() =>
      _SignInVerifyOtpScreenState();
}

class _SignInVerifyOtpScreenState extends State<VerifyOtpForEmailSignInScreen> {
  final _formKey = GlobalKey<FormState>();
  final _otpController = TextEditingController();

  @override
  void initState() {
    // After the widget is built, check if an email was provided.
    // If not, assume something is wrong or the user got here mistakenly and
    // nav back to safety.
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (widget.email == null || widget.email!.isEmpty) {
        if (context.canPop()) {
          context.pop();
        } else {
          context.go('/sign-in');
        }

        ServiceLocator.messenger.showError('Something went wrong loading this screen');
      }
    });
    super.initState();
  }

  @override
  void dispose() {
    _otpController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final provider = Provider.of<AuthProvider>(context, listen: false);

    return Scaffold(
      body: CustomScrollView(
        slivers: [
          const SliverAppBar.large(title: Text('Verify Email')),
          SliverPadding(
            padding: const EdgeInsets.symmetric(horizontal: 16),
            sliver: SliverToBoxAdapter(
              child: Form(
                key: _formKey,
                child: Column(
                  children: [
                    Align(
                      alignment: Alignment.centerLeft,
                      child: Text(
                        'Enter the verification code sent to ${widget.email}:',
                      ),
                    ),
                    const SizedBox(height: 8),
                    Material3TextFormField(
                      autocorrect: false,
                      autofocus: true,
                      iconData: Icons.password,
                      keyboardType: TextInputType.emailAddress,
                      labelText: 'Verification Code',
                      maxLength: 6,
                      textEditingController: _otpController,
                      validator: (value) {
                        final numbersOnly = RegExp(r'^\d+$');

                        if (value == null || value.isEmpty) {
                          return 'Field cannot be empty';
                        } else if (!numbersOnly.hasMatch(value)) {
                          return 'Field must only contain numbers';
                        }

                        return null;
                      },
                    ),
                    const SizedBox(height: 8),
                    FilledAutoLoadingButton(
                      onPressed: () async {
                        if (_formKey.currentState!.validate()) {
                          await provider.verifyOtpForEmailSignIn(
                            email: widget.email!,
                            token: _otpController.text,
                          );
                        }
                      },
                      child: const Text('Verify'),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
