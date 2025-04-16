// Adapted from the Flutter ai_toolkit, EchoProvider class
// The original code is listed under a BSD-like license, found
// in https://raw.githubusercontent.com/flutter/ai/refs/heads/main/LICENSE

import 'package:flutter/foundation.dart';
import 'package:flutter_ai_toolkit/flutter_ai_toolkit.dart';
import 'package:collection/collection.dart';
import 'package:dart_openai/dart_openai.dart';

import 'package:siyuan_ai_companion_ui/provider/config.dart';
import 'package:siyuan_ai_companion_ui/service/database.dart';

class SessionRenameException implements Exception {
  final String message;
  SessionRenameException(this.message);
}

class ChatSession {
  final int id;
  final String name;
  final DateTime createdAt;

  ChatSession({required this.id, required this.name, required this.createdAt});
}

class OpenAiProvider extends LlmProvider with ChangeNotifier {
  OpenAiProvider({
    Iterable<ChatMessage>? history,
    required ConfigProvider configProvider,
  }) : _history = List<ChatMessage>.from(history ?? []),
       _configProvider = configProvider;

  final List<ChatMessage> _history;
  final ConfigProvider _configProvider;
  int? _activeSessionId;

  @override
  Iterable<ChatMessage> get history => _history;
  int? get activeSessionId => _activeSessionId;
  bool get isSessionEmpty => _history.isEmpty;
  Future<ChatSession?> get currentSession async {
    if (_activeSessionId == null) return null;
    final sessions = await getAllSessions();
    return sessions.firstWhereOrNull((s) => s.id == _activeSessionId);
  }

  @override
  set history(Iterable<ChatMessage> history) {
    _history.clear();
    _history.addAll(history);
    notifyListeners();
  }

  Future<void> loadSession(int sessionId, {VoidCallback? onLoaded}) async {
    final rows = await DatabaseService.getMessagesForSession(sessionId);
    _history.clear();
    for (final row in rows) {
      final isUser = row['is_user'] == 1;
      final message =
          isUser ? ChatMessage.user(row['text'], []) : (ChatMessage.llm()
            ..append(row['text']));
      _history.add(message);
    }
    _activeSessionId = sessionId;
    notifyListeners();
    onLoaded?.call();
  }

  Future<void> startNewSession(String? name) async {
    final cleanName = (name ?? '').trim();
    // @New Session is reserved
    if (cleanName == '@New Session') {
      throw SessionRenameException('Session name cannot be "@New Session".');
    }

    final sessionId = await DatabaseService.createSession(
      cleanName.isEmpty ? null : cleanName,
    );
    _activeSessionId = sessionId;
    _history.clear();
    notifyListeners();
  }

  Future<List<ChatSession>> getAllSessions() async {
    final rows = await DatabaseService.getSessions();
    return rows.map((row) {
      return ChatSession(
        id: row['id'] as int,
        name: row['name'] as String,
        createdAt: DateTime.parse(row['created_at'] as String),
      );
    }).toList();
  }

  Future<void> renameSession(int sessionId, String newName) async {
    if (newName.trim() == '@New Session') {
      throw SessionRenameException('Session name cannot be "@New Session".');
    }

    await DatabaseService.renameSession(sessionId, newName.trim());

    notifyListeners();
  }

  Future<void> deleteSession(int sessionId) async {
    await DatabaseService.deleteSession(sessionId);
    if (_activeSessionId == sessionId) {
      _activeSessionId = await DatabaseService.createSession(null);
      _history.clear();
    }
    notifyListeners();
  }

  Future<String> generateSessionName({int? sessionId}) async {
    sessionId ??= _activeSessionId;

    if (sessionId == null) {
      throw Exception('No active session. Call startNewSession() first.');
    }

    final sessionMap = await DatabaseService.getSession(sessionId);

    if (sessionMap['name'] != '@New Session') {
      throw Exception('Session is already named');
    }

    final messages = await DatabaseService.getMessagesForSession(sessionId);

    final prompt = StringBuffer();
    prompt.write('Generate a name for a chat session with the following messages:\n\n');
    for (final message in messages) {
      final isUser = message['is_user'] == 1;
      final text = message['text'] as String;
      prompt.write('${isUser ? 'User' : 'AI'}: $text\n');
    }
    prompt.write('\nName:');

    final newNameResult = await OpenAI.instance.completion.create(
      model: _configProvider.openAiModel ?? 'gpt-3.5-turbo',
      prompt: prompt.toString(),
      maxTokens: 10,
      temperature: 0.7,
    );
    final newName = newNameResult.choices.first.text.trim();

    if (newName.isEmpty) {
      throw Exception('Failed to generate a name for the session.');
    }

    await renameSession(sessionId, newName);

    return newName;
  }

  @override
  Stream<String> generateStream(
    String prompt, {
    Iterable<Attachment> attachments = const [],
  }) async* {
    final messages = <OpenAIChatCompletionChoiceMessageModel>[];

    for (final message in _history) {
      if (message.text == null) {
        continue;
      }

      final role =
          message.origin.isUser
              ? OpenAIChatMessageRole.user
              : OpenAIChatMessageRole.assistant;

      messages.add(
        OpenAIChatCompletionChoiceMessageModel(
          role: role,
          content: [
            OpenAIChatCompletionChoiceMessageContentItemModel.text(
              message.text!,
            ),
          ],
        ),
      );
    }

    messages.add(
      OpenAIChatCompletionChoiceMessageModel(
        role: OpenAIChatMessageRole.user,
        content: [
          OpenAIChatCompletionChoiceMessageContentItemModel.text(prompt),
        ],
      ),
    );

    try {
      final chatStream = OpenAI.instance.chat.createStream(
        model: _configProvider.openAiModel ?? 'gpt-3.5-turbo',
        messages: messages,
      );

      await for (final chunk in chatStream) {
        final content = chunk.choices.first.delta.content?.first?.text;
        if (content != null && content.isNotEmpty) {
          yield content;
        }
      }
    } catch (e) {
      throw LlmFailureException(e.toString());
    }
  }

  @override
  Stream<String> sendMessageStream(
    String prompt, {
    Iterable<Attachment> attachments = const [],
  }) async* {
    if (_activeSessionId == null) {
      throw Exception('No active session. Call startNewSession() first.');
    }

    final userMessage = ChatMessage.user(prompt, attachments);
    final llmMessage = ChatMessage.llm();
    _history.addAll([userMessage, llmMessage]);
    final response = generateStream(prompt, attachments: attachments);

    await DatabaseService.saveMessage(_activeSessionId!, prompt, true);

    yield* response.map((chunk) {
      llmMessage.append(chunk);
      return chunk;
    });

    await DatabaseService.saveMessage(
      _activeSessionId!,
      llmMessage.text ?? '',
      false,
    );
    notifyListeners();
  }
}
