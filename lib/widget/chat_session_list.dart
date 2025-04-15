import 'package:flutter/material.dart';

import 'package:siyuan_ai_companion_ui/provider/openai.dart';

class ChatSessionList extends StatelessWidget {
  const ChatSessionList({
    super.key,
    required this.sessions,
    required this.onSessionSelected,
    required this.onSessionRenamed,
    required this.onSessionDeleted,
  });

  final List<ChatSession> sessions;
  final Function(int) onSessionSelected;
  final Function(int) onSessionRenamed;
  final Function(int) onSessionDeleted;

  @override
  Widget build(BuildContext context) {
    return ListView.builder(
      itemCount: sessions.length,
      itemBuilder: (context, index) {
        final session = sessions[index];
        return _ChatSessionTile(
          session: session,
          onSelected: onSessionSelected,
          onRenamed: onSessionRenamed,
          onDeleted: onSessionDeleted,
        );
      },
    );
  }
}

class _ChatSessionTile extends StatefulWidget {
  const _ChatSessionTile({
    required this.session,
    required this.onSelected,
    required this.onRenamed,
    required this.onDeleted,
  });

  final ChatSession session;
  final Function(int) onSelected;
  final Function(int) onRenamed;
  final Function(int) onDeleted;

  @override
  State<_ChatSessionTile> createState() => _ChatSessionTileState();
}

class _ChatSessionTileState extends State<_ChatSessionTile> {
  bool _hovering = false;

  @override
  Widget build(BuildContext context) {
    return MouseRegion(
      onEnter: (_) => setState(() => _hovering = true),
      onExit: (_) => setState(() => _hovering = false),
      child: ListTile(
        title: Text(widget.session.name),
        subtitle: Text(widget.session.createdAt.toLocal().toString()),
        onTap: () => widget.onSelected(widget.session.id),
        trailing: _hovering
            ? PopupMenuButton<String>(
          itemBuilder: (context) {
            return [
              PopupMenuItem(value: 'rename', child: const Text('Rename')),
              PopupMenuItem(value: 'delete', child: const Text('Delete')),
            ];
          },
          onSelected: (value) {
            WidgetsBinding.instance.addPostFrameCallback((_) {
              if (!mounted) return;

              if (value == 'rename') {
                widget.onRenamed(widget.session.id);
              } else if (value == 'delete') {
                widget.onDeleted(widget.session.id);
              }
            });
          },
        )
            : null,
      ),
    );
  }
}
