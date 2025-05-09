import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:material_loading_buttons/material_loading_buttons.dart'
    show FilledAutoLoadingButton;
import 'package:provider/provider.dart';
import 'package:zaratask/core/utils/service_locator.dart';
import 'package:zaratask/providers/auth_provider.dart';
import 'package:zaratask/services/messenger_service.dart';

class UpdateEmailScreen extends StatefulWidget {
  const UpdateEmailScreen(this.currentEmail, {super.key});

  final String? currentEmail;

  @override
  State<UpdateEmailScreen> createState() => _UpdateEmailScreenState();
}

class _UpdateEmailScreenState extends State<UpdateEmailScreen> {
  final _newEmailController = TextEditingController();

  @override
  void initState() {
    // After the widget is built, check if a current email was provided.
    // If not, assume something is wrong or the user got here mistakenly and
    // nav back to safety.
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (widget.currentEmail == null || widget.currentEmail!.isEmpty) {
        if (context.canPop()) {
          context.pop();
        } else {
          context.go('/profile');
        }

        ServiceLocator.messenger.showError(
          'Something went wrong loading this screen',
        );
      }
    });
    super.initState();
  }

  @override
  void dispose() {
    _newEmailController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final provider = Provider.of<AuthProvider>(context, listen: false);

    return Scaffold(
      body: CustomScrollView(
        slivers: [
          const SliverAppBar.large(title: Text('Update Email')),
          SliverPadding(
            padding: const EdgeInsets.symmetric(horizontal: 16),
            sliver: SliverToBoxAdapter(
              child: Column(
                children: [
                  TextField(
                    autocorrect: false,
                    autofocus: true,
                    autofillHints: const [AutofillHints.email],
                    controller: _newEmailController,
                    decoration: InputDecoration(
                      hintText: widget.currentEmail,
                      labelText: 'Email',
                    ),
                    keyboardType: TextInputType.emailAddress,
                  ),
                  const SizedBox(height: 16),
                  FilledAutoLoadingButton(
                    onPressed: () async {
                      await provider.updateEmail(
                        context,
                        email: _newEmailController.text,
                      );
                    },
                    child: const Text('Send Verification Code'),
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
