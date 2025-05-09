import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:material_loading_buttons/material_loading_buttons.dart'
    show FilledAutoLoadingButton;
import 'package:provider/provider.dart';
import 'package:zaratask/core/utils/service_locator.dart';
import 'package:zaratask/providers/auth_provider.dart';
import 'package:zaratask/services/messenger_service.dart';

class VerifyOtpForEmailUpdateScreen extends StatefulWidget {
  const VerifyOtpForEmailUpdateScreen(this.email, {super.key});

  final String? email;

  @override
  State<VerifyOtpForEmailUpdateScreen> createState() =>
      _VerifyUpdateEmailOtpScreenState();
}

class _VerifyUpdateEmailOtpScreenState
    extends State<VerifyOtpForEmailUpdateScreen> {
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
          context.go('/profile');
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
              child: Column(
                children: [
                  Align(
                    alignment: Alignment.centerLeft,
                    child: Text(
                      'Enter the 6-digit code sent to ${widget.email}:',
                    ),
                  ),
                  const SizedBox(height: 8),
                  TextField(
                    autocorrect: false,
                    autofocus: true,
                    controller: _otpController,
                    decoration: const InputDecoration(
                      labelText: 'Verification Code',
                    ),
                    keyboardType: TextInputType.number,
                    maxLength: 6,
                  ),
                  const SizedBox(height: 16),
                  FilledAutoLoadingButton(
                    onPressed: () async {
                      await provider.verifyOtpForEmailUpdate(
                        context,
                        email: widget.email!,
                        token: _otpController.text,
                      );
                    },
                    child: const Text('Verify'),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
