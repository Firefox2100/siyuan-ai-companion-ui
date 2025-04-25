import 'package:flutter/material.dart';
import 'package:flutter_ai_toolkit/flutter_ai_toolkit.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:provider/provider.dart';

import 'package:siyuan_ai_companion_ui/model/form_factor.dart';
import 'package:siyuan_ai_companion_ui/page/setting.dart';
import 'package:siyuan_ai_companion_ui/page/transcribe.dart';
import 'package:siyuan_ai_companion_ui/provider/config.dart';
import 'package:siyuan_ai_companion_ui/provider/openai.dart';
import 'package:siyuan_ai_companion_ui/widget/chat_session_list.dart';
import 'package:siyuan_ai_companion_ui/widget/setting.dart';

class ChatPage extends StatefulWidget {
  const ChatPage({super.key});

  @override
  State<ChatPage> createState() => _ChatPageState();
}

class _ChatPageState extends State<ChatPage>
    with SingleTickerProviderStateMixin {
  late final OpenAiProvider _provider;
  late Future<List<ChatSession>> _sessionsFuture;

  Future<void> _onShowSettings() async {
    final screenWidth = MediaQuery.sizeOf(context).width;
    final screenHeight = MediaQuery.sizeOf(context).height;

    if (screenWidth > FormFactor.mobile) {
      // Wider layout, display as a popup
      final formKey = GlobalKey<FormState>();

      await showDialog(
        context: context,
        builder: (context) {
          return AlertDialog(
            content: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text(
                  'Settings',
                  style: TextStyle(fontWeight: FontWeight.bold, fontSize: 24),
                ),
                const SizedBox(height: 16),
                SizedBox(
                  width: screenWidth * 0.7,
                  height: screenHeight * 0.5,
                  child: SingleChildScrollView(
                    child: SettingInput(formKey: formKey),
                  ),
                ),
              ],
            ),
            actions: [
              TextButton(
                onPressed: () => Navigator.pop(context),
                child: const Text('Cancel'),
              ),
              TextButton(
                onPressed: () {
                  if (formKey.currentState?.validate() ?? false) {
                    formKey.currentState?.save();
                    Navigator.pop(context);
                  }
                },
                child: const Text('Save'),
              ),
            ],
          );
        },
      );
    } else {
      // Navigate to setting page on mobile
      Navigator.push(
        context,
        MaterialPageRoute(builder: (context) => SettingPage()),
      );
    }
  }

  Future<void> _onNavigateTranscribe() async {
    Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => TranscribePage()),
    );
  }

  void _refreshSessionList() {
    setState(() {
      _sessionsFuture = _provider.getAllSessions();
    });
  }

  Future<void> _onSelectSession(int sessionId) async {
    await _provider.loadSession(sessionId);
    _refreshSessionList();
  }

  Future<void> _onNewSession(String? name) async {
    await _provider.startNewSession(name);
    _refreshSessionList();
  }

  Future<void> _onRenameSession(int sessionId) async {
    final controller = TextEditingController();
    await showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: const Text('Rename Session'),
          content: TextField(
            controller: controller,
            decoration: const InputDecoration(labelText: 'New Name'),
            onSubmitted: (newName) async {
              await _provider.renameSession(sessionId, newName);

              if (context.mounted) {
                Navigator.pop(context);
                _refreshSessionList();
              }
            },
          ),
          actions: [
            TextButton(
              onPressed: () async {
                await _provider.renameSession(sessionId, controller.text);

                if (context.mounted) {
                  Navigator.pop(context);
                  _refreshSessionList();
                }
              },
              child: const Text('Rename'),
            ),
            TextButton(
              onPressed: () => Navigator.pop(context),
              child: const Text('Cancel'),
            ),
          ],
        );
      },
    );
  }

  Future<void> _onDeleteSession(int sessionId) async {
    await showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: const Text('Delete Session'),
          content: const Text('Are you sure you want to delete this session?'),
          actions: [
            TextButton(
              onPressed: () async {
                await _provider.deleteSession(sessionId);

                if (context.mounted) {
                  Navigator.pop(context);
                  _refreshSessionList();
                }
              },
              child: const Text('Delete'),
            ),
            TextButton(
              onPressed: () => Navigator.pop(context),
              child: const Text('Cancel'),
            ),
          ],
        );
      },
    );
  }

  Widget _buildChatLayout(List<ChatSession> sessions) {
    final screenWidth = MediaQuery.sizeOf(context).width;

    if (screenWidth > FormFactor.mobile) {
      return Scaffold(
        appBar: AppBar(
          title: Row(
            mainAxisSize: MainAxisSize.max,
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.end,
            children: [
              SvgPicture.asset(
                'assets/images/logo.svg',
                semanticsLabel: 'SiYuan AI Companion Logo',
                height: 40,
              ),
              const Expanded(child: Center(child: Text('Chat'))),
            ],
          ),
          actions: [
            IconButton(
              onPressed: () => _onNavigateTranscribe(),
              icon: const Icon(Icons.mic_none_outlined),
            ),
            IconButton(
              onPressed: () => _onNewSession(null),
              icon: const Icon(Icons.add),
            ),
            IconButton(
              onPressed: () => _onShowSettings(),
              icon: const Icon(Icons.settings),
            ),
          ],
        ),
        body: Row(
          children: [
            SizedBox(
              width: 300,
              child: ChatSessionList(
                sessions: sessions,
                onSessionSelected:
                    (int sessionId) async => await _onSelectSession(sessionId),
                onSessionRenamed:
                    (int sessionId) async => await _onRenameSession(sessionId),
                onSessionDeleted:
                    (int sessionId) async => await _onDeleteSession(sessionId),
              ),
            ),
            const VerticalDivider(width: 1),
            Expanded(
              child: LlmChatView(
                provider: _provider,
                welcomeMessage: 'Welcome to SiYuan AI Companion!',
                suggestions: const ['What is in my calendar today?'],
              ),
            ),
          ],
        ),
      );
    }

    return Scaffold(
      appBar: AppBar(
        title: Row(
          mainAxisSize: MainAxisSize.max,
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.end,
          children: [
            SvgPicture.asset(
              'assets/images/logo.svg',
              semanticsLabel: 'SiYuan AI Companion Logo',
              height: 40,
            ),
            const Padding(
              padding: EdgeInsets.symmetric(horizontal: 15),
              child: Text('Chat'),
            ),
          ],
        ),
        actions: [
          IconButton(
            onPressed: () => _onNewSession(null),
            icon: const Icon(Icons.add),
          ),
          IconButton(
            onPressed: () => _onShowSettings(),
            icon: const Icon(Icons.settings),
          ),
        ],
      ),
      drawer: Drawer(
        child: ChatSessionList(
          sessions: sessions,
          onSessionSelected:
              (int sessionId) async => await _onSelectSession(sessionId),
          onSessionRenamed:
              (int sessionId) async => await _onRenameSession(sessionId),
          onSessionDeleted:
              (int sessionId) async => await _onDeleteSession(sessionId),
        ),
      ),
      body: LlmChatView(
        provider: _provider,
        welcomeMessage: 'Welcome to SiYuan AI Companion!',
        suggestions: const ['What is in my calendar today?'],
      ),
    );
  }

  Future<List<ChatSession>> _initializeAll() async {
    if (_provider.activeSessionId == null) {
      await _provider.startNewSession(null);
    }
    return _provider.getAllSessions();
  }

  @override
  void initState() {
    super.initState();

    final configProvider = context.read<ConfigProvider>();
    _provider = OpenAiProvider(
      configProvider: configProvider,
      refreshSessionList: _refreshSessionList,
    );

    _sessionsFuture = _initializeAll();
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<List<ChatSession>>(
      future: _sessionsFuture,
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Scaffold(
            body: Center(child: CircularProgressIndicator()),
          );
        }

        if (snapshot.hasError) {
          return Scaffold(
            body: Center(
              child: Text('Error loading sessions: ${snapshot.error}'),
            ),
          );
        }

        final sessions = snapshot.data ?? [];
        return _buildChatLayout(sessions);
      },
    );
  }
}
