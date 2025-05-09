import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

Future<bool?> material3ConfirmActionDialog(
  BuildContext context, {
  required String title,
  required String content,
  String primaryButtonText = 'OK',
  String secondaryButtonText = 'Cancel',
}) async {
  return showDialog<bool>(
    context: context,
    builder: (_) {
      return AlertDialog(
        title: Text(title),
        content: Text(content),
        actions: [
          TextButton(
            onPressed: () {
              context.pop(false);
            },
            child: Text(secondaryButtonText),
          ),
          TextButton(
            onPressed: () {
              context.pop(true);
            },
            child: Text(primaryButtonText),
          ),
        ],
      );
    },
  );
}
