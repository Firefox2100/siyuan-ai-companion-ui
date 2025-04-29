// ignore: unused_import
import 'package:intl/intl.dart' as intl;
import 'localizations.dart';

// ignore_for_file: type=lint

/// The translations for Chinese (`zh`).
class AppLocalizationsZh extends AppLocalizations {
  AppLocalizationsZh([String locale = 'zh']) : super(locale);

  @override
  String get appTitle => '思源AI助手';

  @override
  String get openAiApiSettings => 'OpenAI API 设置';

  @override
  String get apiKey => 'API 密钥';

  @override
  String get apiKeyHint => '与后端服务器进行身份验证的 API 密钥';

  @override
  String get orgId => 'OpenAI 的组织 ID';

  @override
  String get orgIdHint => '如果使用自己搭建的 OpenAI API，一般不需要填写';

  @override
  String get openAiModel => 'OpenAI 模型';

  @override
  String get openAiModelHint => '生成对话的模型';

  @override
  String get openAiApiUrl => 'OpenAI API 地址';

  @override
  String get openAiApiUrlHint => '留空以使用配套的后端 API';

  @override
  String get openAiSystemPrompt => 'OpenAI 系统提示词';

  @override
  String get openAiSystemPromptHint => '在每次对话最开始使用的提示词';

  @override
  String get chatSavingNotebook => '保存对话的笔记本';

  @override
  String get chatSavingNotebookHint => '选择一个笔记本以保存对话内容';

  @override
  String get enableRag => '启用 RAG';

  @override
  String get rename => '重命名';

  @override
  String get delete => '删除';

  @override
  String get cancel => '取消';

  @override
  String get save => '保存';

  @override
  String get newConversationName => '@新对话';

  @override
  String ragPrompt(String context, String question) {
    return '根据额外信息：\\n$context\\n回答以下问题：$question\\n回答：';
  }

  @override
  String get defaultSystemPrompt => '你是一名AI助手，主要负责通过用户提示词和额外信息回答问题和写作。\n  优先使用用户提供的额外信息\n  如果有不清楚或者超出你知识范围的内容，请提问，而不是猜测\n  保持用语准确客观\n  提供写作帮助时，保持风格一致，用语准确，与用户主题相关';

  @override
  String get logoLabel => '思源 AI 助手 Logo';

  @override
  String get transcribe => '转录';

  @override
  String get noAudioAssetMessage => '没有音频资源';

  @override
  String get noTranscription => '没有转录文本';

  @override
  String get settings => '设置';

  @override
  String get renameSession => '重命名会话';

  @override
  String get newName => '新名称';

  @override
  String get deleteSession => '删除会话';

  @override
  String get deleteSessionConfirmation => '是否确认删除该会话？';

  @override
  String get chat => '会话';

  @override
  String get welcomeMessage => '欢迎使用思源 AI 助手';

  @override
  String get calendarPrompt => '今天我的日程安排是什么？';

  @override
  String get authenticatePrompt => '请进行身份验证以继续';

  @override
  String get authenticate => '验证';
}
