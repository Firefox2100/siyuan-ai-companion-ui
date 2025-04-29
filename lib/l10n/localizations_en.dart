// ignore: unused_import
import 'package:intl/intl.dart' as intl;
import 'localizations.dart';

// ignore_for_file: type=lint

/// The translations for English (`en`).
class AppLocalizationsEn extends AppLocalizations {
  AppLocalizationsEn([String locale = 'en']) : super(locale);

  @override
  String get appTitle => 'SiYuan AI Companion';

  @override
  String get openAiApiSettings => 'OpenAI API Settings';

  @override
  String get apiKey => 'API Key';

  @override
  String get apiKeyHint => 'API key to authenticate with the server';

  @override
  String get orgId => 'OpenAI Organization ID';

  @override
  String get orgIdHint => 'Optional if using self-hosted OpenAI API';

  @override
  String get openAiModel => 'OpenAI Model';

  @override
  String get openAiModelHint => 'The model to use for generation';

  @override
  String get openAiApiUrl => 'OpenAI API URL';

  @override
  String get openAiApiUrlHint => 'Leave empty to use the backend API';

  @override
  String get openAiSystemPrompt => 'OpenAI System Prompt';

  @override
  String get openAiSystemPromptHint => 'The system prompt to use for generation';

  @override
  String get chatSavingNotebook => 'Chat Saving Notebook';

  @override
  String get chatSavingNotebookHint => 'Select a notebook to save chat history';

  @override
  String get enableRag => 'Enable RAG';

  @override
  String get rename => 'Rename';

  @override
  String get delete => 'Delete';

  @override
  String get cancel => 'Cancel';

  @override
  String get save => 'Save';

  @override
  String get newConversationName => '@New Conversation';

  @override
  String ragPrompt(String context, String question) {
    return 'Context:\\n$context\\nAnswer the question: $question\\nAnswer:';
  }

  @override
  String get defaultSystemPrompt => 'You are an assistant whose primary role is to answer user questions and provide writing assistance.\n  Always prioritize any context explicitly provided with the user prompt.\n  If something is unclear, ambiguous, or outside your knowledge, clearly communicate this to the user instead of making assumptions.\n  Maintain a helpful, accurate, and concise tone.\n  When providing writing assistance, ensure clarity, structure, and relevance to the user\'s request.';

  @override
  String get logoLabel => 'SiYuan AI Companion Logo';

  @override
  String get transcribe => 'Transcribe';

  @override
  String get noAudioAssetMessage => 'No audio assets found';

  @override
  String get noTranscription => 'No transcription';

  @override
  String get settings => 'Settings';

  @override
  String get renameSession => 'Rename Session';

  @override
  String get newName => 'New Name';

  @override
  String get deleteSession => 'Delete Session';

  @override
  String get deleteSessionConfirmation => 'Are you sure you want to delete this session?';

  @override
  String get chat => 'Chat';

  @override
  String get welcomeMessage => 'Welcome to SiYuan AI Companion';

  @override
  String get calendarPrompt => 'What is in my calendar today?';

  @override
  String get authenticatePrompt => 'Please authenticate to continue';

  @override
  String get authenticate => 'Authenticate';
}
