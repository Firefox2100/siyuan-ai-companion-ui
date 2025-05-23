import 'package:flutter/foundation.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:dart_openai/dart_openai.dart';

import 'package:siyuan_ai_companion_ui/model/consts.dart';
import 'package:siyuan_ai_companion_ui/service/http.dart';
import 'package:siyuan_ai_companion_ui/service/localization.dart';

class ConfigProvider extends ChangeNotifier {
  late final SharedPreferences _prefs;

  String? _openAiKey;
  String? _openAiOrgId;
  String? _openAiModel;
  String? _openAiApiUrl;
  String? _openAiSystemPrompt;
  String? _chatSavingNotebookId;

  bool _enableRag = true;

  Future<void> init() async {
    _prefs = await SharedPreferences.getInstance();

    _openAiKey = _prefs.getString('open_ai_key');
    _openAiOrgId = _prefs.getString('open_ai_org_id');
    _openAiModel = _prefs.getString('open_ai_model');
    _openAiApiUrl = _prefs.getString('open_ai_api_url');
    _openAiSystemPrompt = _prefs.getString('open_ai_system_prompt');
    _chatSavingNotebookId = _prefs.getString('chat_saving_notebook_id');

    _enableRag = _prefs.getBool('enable_rag') ?? true;

    if (_openAiApiUrl != null) {
      OpenAI.baseUrl = _openAiApiUrl!;
    } else {
      OpenAI.baseUrl =
          Uri(
            scheme: PROTOCOL,
            host: HOST,
            port: PORT,
            path: 'openai/direct',
          ).toString();
    }

    if (_openAiKey != null && _openAiKey!.isNotEmpty) {
      OpenAI.apiKey = _openAiKey!;
      HttpService.apiKey = _openAiKey!;
    } else {
      OpenAI.apiKey = 'debug-key';
    }

    if (_openAiOrgId != null) {
      OpenAI.organization = _openAiOrgId!;
    }
  }

  String? get openAiKey => _openAiKey;
  String? get openAiOrgId => _openAiOrgId;
  String? get openAiModel => _openAiModel;
  String? get openAiApiUrl => _openAiApiUrl;
  String get openAiSystemPrompt =>
      _openAiSystemPrompt ?? LocalizationService.l10n.defaultSystemPrompt;
  String? get chatSavingNotebookId => _chatSavingNotebookId;

  bool get enableRag => _enableRag;

  Future<void> setOpenAiKey(String key) async {
    _openAiKey = key;
    await _prefs.setString('open_ai_key', key);

    OpenAI.apiKey = key;
    HttpService.apiKey = key;

    notifyListeners();
  }

  Future<void> setOpenAiOrgId(String orgId) async {
    _openAiOrgId = orgId;
    await _prefs.setString('open_ai_org_id', orgId);

    OpenAI.organization = orgId;

    notifyListeners();
  }

  Future<void> setOpenAiModel(String model) async {
    _openAiModel = model;
    await _prefs.setString('open_ai_model', model);
    notifyListeners();
  }

  Future<void> setOpenAiApiUrl(String apiUrl) async {
    _openAiApiUrl = apiUrl;
    await _prefs.setString('open_ai_api_url', apiUrl);

    OpenAI.baseUrl = apiUrl;

    notifyListeners();
  }

  Future<void> setOpenAiSystemPrompt(String systemPrompt) async {
    _openAiSystemPrompt = systemPrompt;
    await _prefs.setString('open_ai_system_prompt', systemPrompt);
    notifyListeners();
  }

  Future<void> setChatSavingNotebookId(String notebookId) async {
    _chatSavingNotebookId = notebookId;
    await _prefs.setString('chat_saving_notebook_id', notebookId);
    notifyListeners();
  }

  Future<void> setEnableRag(bool enable) async {
    _enableRag = enable;
    await _prefs.setBool('enable_rag', enable);
    notifyListeners();
  }
}
