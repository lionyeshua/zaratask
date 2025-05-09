import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';
import 'package:zaratask/providers/auth_provider.dart';
import 'package:zaratask/providers/topics_provider.dart';
import 'package:zaratask/core/utils/service_locator.dart';
import 'package:zaratask/widgets/form_fields/material_3_text_form_field.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen(this.child, {super.key});

  final StatefulNavigationShell child;

  @override
  Widget build(BuildContext context) {
    final provider = Provider.of<AuthProvider>(context, listen: false);

    return ChangeNotifierProvider(
      create: (context) => TopicsProvider(ServiceLocator.db, provider.user.id),
      child: _HomeScreen(child),
    );
  }
}

class _HomeScreen extends StatelessWidget {
  const _HomeScreen(this.child);

  final StatefulNavigationShell child;

  void _onTap(int index) =>
      child.goBranch(index, initialLocation: index == child.currentIndex);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: child,
      bottomNavigationBar: NavigationBar(
        destinations: const [
          NavigationDestination(icon: Icon(Icons.list), label: 'My Lists'),
          NavigationDestination(icon: Icon(Icons.person), label: 'Profile'),
        ],
        onDestinationSelected: _onTap,
        selectedIndex: child.currentIndex,
      ),
      floatingActionButton:
          child.currentIndex == 0 ? const _CreateTaskListFab() : null,
      // Allows scrolling to the end of lists when the keyboard (or other
      // floating widgets) may otherwise cover them.
      resizeToAvoidBottomInset: true,
    );
  }
}

class _CreateTaskListFab extends StatefulWidget {
  const _CreateTaskListFab();

  @override
  State<_CreateTaskListFab> createState() => _CreateTaskListFabState();
}

class _CreateTaskListFabState extends State<_CreateTaskListFab> {
  final _controller = TextEditingController();

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final provider = Provider.of<TopicsProvider>(context, listen: false);

    return FloatingActionButton(
      onPressed: () async {
        final listName = await showDialog<String?>(
          context: context,
          builder: (context) {
            return AlertDialog(
              title: const Text('Create List'),
              content: Material3TextFormField(
                autocorrect: false,
                autofocus: true,
                labelText: 'List',
                textEditingController: _controller,
              ),
              actions: [
                TextButton(
                  onPressed: () {
                    context.pop();
                    _controller.clear();
                  },
                  child: const Text('Cancel'),
                ),
                TextButton(
                  onPressed: () {
                    context.pop(_controller.text);
                    _controller.clear();
                  },
                  child: const Text('OK'),
                ),
              ],
            );
          },
        );

        if (listName != null) {
          // await provider.createList(listName);
        }
      },
      child: const Icon(Icons.add),
    );
  }
}
