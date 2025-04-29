import 'package:flutter/material.dart';

import 'package:siyuan_ai_companion_ui/provider/openai.dart';

class ChatSessionList extends StatelessWidget {
  const ChatSessionList({
    super.key,
    required this.sessions,
    required this.onSessionSelected,
    required this.onSessionRenamed,
    required this.onSessionDeleted,
    this.onSessionSaved,
  });

  final List<ChatSession> sessions;
  final Function(int) onSessionSelected;
  final Function(int) onSessionRenamed;
  final Function(int) onSessionDeleted;
  final Function(int)? onSessionSaved;

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
          onSaved: onSessionSaved,
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
    this.onSaved,
  });

  final ChatSession session;
  final Function(int) onSelected;
  final Function(int) onRenamed;
  final Function(int) onDeleted;
  final Function(int)? onSaved;

  @override
  State<_ChatSessionTile> createState() => _ChatSessionTileState();
}

// Dart
class _ChatSessionTileState extends State<_ChatSessionTile> {
  bool _hovering = false;
  bool _isMenuOpen = false;
  final GlobalKey _popupMenuKey = GlobalKey();

  @override
  Widget build(BuildContext context) {
    return MouseRegion(
      onEnter: (_) => setState(() => _hovering = true),
      onExit: (_) => setState(() => _hovering = false),
      child: ListTile(
        title: Text(widget.session.name),
        subtitle: Text(widget.session.createdAt.toLocal().toString()),
        onTap: () => widget.onSelected(widget.session.id),
        trailing:
            (_hovering || _isMenuOpen)
                ? PopupMenuButton<String>(
                  key: _popupMenuKey,
                  itemBuilder: (context) {
                    return [
                      PopupMenuItem(
                        value: 'rename',
                        child: const Text('Rename'),
                      ),
                      PopupMenuItem(
                        value: 'delete',
                        child: const Text('Delete'),
                      ),
                      if (widget.onSaved != null &&
                          widget.session.name != '@New Conversation')
                        PopupMenuItem(value: 'save', child: const Text('Save')),
                    ];
                  },
                  onSelected: (value) {
                    WidgetsBinding.instance.addPostFrameCallback((_) {
                      if (!mounted) return;

                      if (value == 'rename') {
                        widget.onRenamed(widget.session.id);
                      } else if (value == 'delete') {
                        widget.onDeleted(widget.session.id);
                      } else if (value == 'save' && widget.onSaved != null) {
                        widget.onSaved!(widget.session.id);
                      }
                    });

                    setState(() {
                      _isMenuOpen = false;
                    });
                  },
                  onOpened: () {
                    setState(() {
                      _isMenuOpen = true;
                    });
                  },
                  onCanceled: () {
                    setState(() {
                      _isMenuOpen = false;
                    });
                  },
                )
                : null,
      ),
    );
  }
}
