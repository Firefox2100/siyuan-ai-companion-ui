import 'package:flutter/material.dart';
import 'package:flutter_ai_toolkit/flutter_ai_toolkit.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:provider/provider.dart';

import 'package:siyuan_ai_companion_ui/model/form_factor.dart';
import 'package:siyuan_ai_companion_ui/page/setting.dart';
import 'package:siyuan_ai_companion_ui/page/transcribe.dart';
import 'package:siyuan_ai_companion_ui/provider/config.dart';
import 'package:siyuan_ai_companion_ui/provider/openai.dart';
import 'package:siyuan_ai_companion_ui/service/localization.dart';
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
    final l10n = LocalizationService.l10n;

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
                Text(
                  l10n.settings,
                  style: const TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 24,
                  ),
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
                child: Text(l10n.cancel),
              ),
              TextButton(
                onPressed: () {
                  if (formKey.currentState?.validate() ?? false) {
                    formKey.currentState?.save();
                    Navigator.pop(context);
                  }
                },
                child: Text(l10n.save),
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
    final l10n = LocalizationService.l10n;

    final controller = TextEditingController();
    await showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: Text(l10n.renameSession),
          content: TextField(
            controller: controller,
            decoration: InputDecoration(labelText: l10n.newName),
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
              child: Text(l10n.rename),
            ),
            TextButton(
              onPressed: () => Navigator.pop(context),
              child: Text(l10n.cancel),
            ),
          ],
        );
      },
    );
  }

  Future<void> _onDeleteSession(int sessionId) async {
    final l10n = LocalizationService.l10n;

    await showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: Text(l10n.deleteSession),
          content: Text(l10n.deleteSessionConfirmation),
          actions: [
            TextButton(
              onPressed: () async {
                await _provider.deleteSession(sessionId);

                if (context.mounted) {
                  Navigator.pop(context);
                  _refreshSessionList();
                }
              },
              child: Text(l10n.delete),
            ),
            TextButton(
              onPressed: () => Navigator.pop(context),
              child: Text(l10n.cancel),
            ),
          ],
        );
      },
    );
  }

  Future<void> _onSaveSession(int sessionId) async {
    await _provider.saveSession(sessionId);
    _refreshSessionList();
  }

  // Stream<String> _messageSender(
  //     String prompt, {
  //       required Iterable<Attachment> attachments,
  //     }) async* {
  //   final response = _provider.sendMessageStream(
  //     prompt,
  //     attachments: attachments,
  //   );
  //
  //   final text = await response.join();
  //
  //   yield text;
  // }

  Widget _buildChatLayout(List<ChatSession> sessions) {
    final screenWidth = MediaQuery.sizeOf(context).width;
    final configProvider = context.watch<ConfigProvider>();
    final l10n = LocalizationService.l10n;

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
                semanticsLabel: l10n.logoLabel,
                height: 40,
              ),
              Expanded(child: Center(child: Text(l10n.chat))),
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
                onSessionSaved:
                    configProvider.chatSavingNotebookId != null
                        ? (int sessionId) async =>
                            await _onSaveSession(sessionId)
                        : null,
              ),
            ),
            const VerticalDivider(width: 1),
            Expanded(
              child: LlmChatView(
                provider: _provider,
                welcomeMessage: l10n.welcomeMessage,
                suggestions: [l10n.calendarPrompt],
                enableAttachments: false,
                // messageSender: _messageSender,
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
              semanticsLabel: l10n.logoLabel,
              height: 40,
            ),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 15),
              child: Text(l10n.chat),
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
        welcomeMessage: l10n.welcomeMessage,
        suggestions: [l10n.calendarPrompt],
        enableAttachments: false,
        // messageSender: _messageSender,
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
