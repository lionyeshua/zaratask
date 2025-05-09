import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';
import 'package:zaratask/models/topic_model.dart';
import 'package:zaratask/providers/topics_provider.dart';
import 'package:zaratask/widgets/dialogs/material_3_confirm_action_dialog.dart';
import 'package:zaratask/widgets/dialogs/material_3_fullscreen_dialog.dart';

import 'package:zaratask/widgets/form_fields/material_3_text_form_field.dart';

class TopicsScreen extends StatelessWidget {
  const TopicsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Consumer<TopicsProvider>(
      builder: (context, provider, child) {
        return CustomScrollView(
          slivers: [
            const SliverAppBar.large(title: Text('Topics')),
            SliverList.separated(
              itemCount: provider.topics.length,
              itemBuilder: (context, index) {
                final topic = provider.topics[index];

                return TopicListTile(topic);
              },
              separatorBuilder:
                  (context, index) => const Divider(indent: 16, endIndent: 16),
            ),
          ],
        );
      },
    );
  }
}

class TopicListTile extends StatefulWidget {
  const TopicListTile(this.topic, {super.key});

  final Topic topic;

  @override
  State<TopicListTile> createState() => _TopicListTileState();
}

class _TopicListTileState extends State<TopicListTile> {
  var _controller = TextEditingController();

  @override
  void initState() {
    _controller = TextEditingController(text: widget.topic.name);
    super.initState();
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final provider = Provider.of<TopicsProvider>(context, listen: false);

    return ListTile(
      key: ValueKey(widget.topic.id),
      onLongPress: () async {
        await material3FullscreenDialog(
          context,
          title: 'Edit list',
          onSave: () async {
            //await provider.renameList(widget.topic.id, _controller.text);
          },
          slivers: [
            SliverPadding(
              padding: const EdgeInsets.symmetric(horizontal: 24),
              sliver: SliverList.list(
                children: [
                  Material3TextFormField(
                    autofocus: true,
                    labelText: 'Name',
                    textEditingController: _controller,
                  ),
                  DeleteListTextButton(widget.topic.id, provider),
                ],
              ),
            ),
          ],
        );
      },
      title: Text(widget.topic.name),
      trailing: IconButton(
        onPressed: () => print('go to list'),
        icon: const Icon(Icons.arrow_forward),
      ),
    );
  }
}

class DeleteListTextButton extends StatelessWidget {
  const DeleteListTextButton(this.listId, this.provider, {super.key});

  final String listId;
  final TopicsProvider provider;

  @override
  Widget build(BuildContext context) {
    return TextButton(
      onPressed: () async {
        final response = await material3ConfirmActionDialog(
          context,
          title: 'Delete list?',
          content:
              'The list and all of its tasks will be '
              'permanently deleted.',
          primaryButtonText: 'Delete',
        );

        if (response ?? false) {
          //await provider.deleteList(listId);
        }
        if (context.mounted) {
          context.pop();
        }
      },
      child: const Text('Delete List'),
    );
  }
}
