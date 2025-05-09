import 'package:flutter/material.dart';

class InitializationFailedScreen extends StatelessWidget {
  const InitializationFailedScreen(this.errorMessage, {super.key});

  final String errorMessage;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Initialization Failed')),
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 16),
        child: Text(
          'The app failed to initialize and cannot run.\n\n'
          'Here are a few things to try:\n'
          '1. Close and reopen the app.\n'
          '2. Update to the latest version of the app in the app store.\n'
          '3. Delete the app and reinstall it.\n\n'
          'If none of these solved the issue, take a screen shot and '
          'provide it to the developer.\n\n'
          '$errorMessage',
        ),
      ),
    );
  }
}
