// Adapted from the Flutter ai_toolkit, EchoProvider class
// This part of code is listed under a BSD-like license, found
// in https://raw.githubusercontent.com/flutter/ai/refs/heads/main/LICENSE

import 'package:flutter/foundation.dart';
import 'package:flutter_ai_toolkit/flutter_ai_toolkit.dart';
import 'package:dart_openai/dart_openai.dart';

import 'package:siyuan_ai_companion_ui/provider/config.dart';

class OpenAiProvider extends LlmProvider with ChangeNotifier {
  OpenAiProvider({
    Iterable<ChatMessage>? history,
    required ConfigProvider configProvider,
  }) : _history = List<ChatMessage>.from(history ?? []),
       _configProvider = configProvider;

  final List<ChatMessage> _history;
  final ConfigProvider _configProvider;

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
    final userMessage = ChatMessage.user(prompt, attachments);
    final llmMessage = ChatMessage.llm();
    _history.addAll([userMessage, llmMessage]);
    final response = generateStream(prompt, attachments: attachments);

    // don't write this code if you're targeting the web until this is fixed:
    // https://github.com/dart-lang/sdk/issues/47764
    // await for (final chunk in chunks) {
    //   llmMessage.append(chunk);
    //   yield chunk;
    // }
    // await for (final chunk in response) {
    //   llmMessage.append(chunk);
    //   yield chunk;
    // }

    yield* response.map((chunk) {
      llmMessage.append(chunk);
      return chunk;
    });

    notifyListeners();
  }

  @override
  Iterable<ChatMessage> get history => _history;

  @override
  set history(Iterable<ChatMessage> history) {
    _history.clear();
    _history.addAll(history);
    notifyListeners();
  }
}
