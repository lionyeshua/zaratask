import 'package:email_validator/email_validator.dart';
import 'package:flutter/material.dart';
import 'package:material_loading_buttons/material_loading_buttons.dart'
    show FilledAutoLoadingButton;
import 'package:zaratask/providers/auth_provider.dart';
import 'package:provider/provider.dart';
import 'package:zaratask/widgets/form_fields/material_3_text_form_field.dart';

class SignInScreen extends StatefulWidget {
  const SignInScreen({super.key});

  @override
  State<SignInScreen> createState() => _SignInScreenState();
}

class _SignInScreenState extends State<SignInScreen> {
  final _emailController = TextEditingController();
  final _formKey = GlobalKey<FormState>();

  @override
  void dispose() {
    _emailController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final provider = Provider.of<AuthProvider>(context, listen: false);

    return Scaffold(
      body: CustomScrollView(
        slivers: [
          const SliverAppBar.large(title: Text('Welcome')),
          SliverPadding(
            padding: const EdgeInsets.symmetric(horizontal: 16),
            sliver: SliverToBoxAdapter(
              child: Form(
                key: _formKey,
                child: Column(
                  children: [
                    Material3TextFormField(
                      autocorrect: false,
                      autofocus: true,
                      autofillHints: const [AutofillHints.email],
                      iconData: Icons.email,
                      keyboardType: TextInputType.emailAddress,
                      labelText: 'Email',
                      textEditingController: _emailController,
                      validator: (value) {
                        final email = value ?? '';
                        if (EmailValidator.validate(email)) {
                          return null;
                        }
                        return 'Invalid email address';
                      },
                    ),
                    const SizedBox(height: 16),
                    FilledAutoLoadingButton(
                      onPressed: () async {
                        if (_formKey.currentState!.validate()) {
                          await provider.signInWithEmailAndOtp(
                            context,
                            email: _emailController.text,
                          );
                        }
                      },
                      child: const Text('Send Verification Code'),
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
