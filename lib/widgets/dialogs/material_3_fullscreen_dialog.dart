import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

Future<void> material3FullscreenDialog(
  BuildContext context, {
  required String title,
  required void Function() onSave,
  List<Widget> slivers = const [],
}) async {
  return showDialog<void>(
    barrierColor: Theme.of(context).colorScheme.surface,
    context: context,
    builder: (context) {
      return Dialog.fullscreen(
        child: CustomScrollView(
          slivers: [
            SliverPadding(
              padding: const EdgeInsets.only(right: 16),
              sliver: SliverAppBar(
                actions: [
                  TextButton(
                    onPressed: () async {
                      onSave();
                      context.pop();
                    },
                    child: const Text('Save'),
                  ),
                ],
                centerTitle: false,
                leading: IconButton(
                  onPressed: () => context.pop(),
                  icon: const Icon(Icons.close),
                ),
                pinned: true,
                title: Text(title),
              ),
            ),
            ...slivers,
          ],
        ),
      );
    },
  );
}
