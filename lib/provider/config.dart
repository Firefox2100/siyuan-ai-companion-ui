import 'package:flutter/foundation.dart';
import 'package:web/web.dart' as web;
import 'package:shared_preferences/shared_preferences.dart';
import 'package:dart_openai/dart_openai.dart';

class ConfigProvider extends ChangeNotifier {
  late final SharedPreferences _prefs;

  String? _openAiKey;
  String? _openAiOrgId;
  String? _openAiModel;
  String? _openAiApiUrl;

  Future<void> init() async {
    _prefs = await SharedPreferences.getInstance();

    _openAiKey = _prefs.getString('open_ai_key');
    _openAiOrgId = _prefs.getString('open_ai_org_id');
    _openAiModel = _prefs.getString('open_ai_model');
    _openAiApiUrl = _prefs.getString('open_ai_api_url');

    if (_openAiApiUrl != null) {
      OpenAI.baseUrl = _openAiApiUrl!;
    }
    else {
      final location = web.window.location;
      OpenAI.baseUrl = Uri(
        scheme: location.protocol.replaceAll(':', ''),
        host: location.hostname,
        port: location.port.isNotEmpty ? int.tryParse(location.port) : null,
        path: 'openai',
      ).toString();
    }

    if (_openAiKey != null && _openAiKey!.isNotEmpty) {
      OpenAI.apiKey = _openAiKey!;
    }
    else {
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

  Future<void> setOpenAiKey(String key) async {
    _openAiKey = key;
    await _prefs.setString('open_ai_key', key);

    OpenAI.apiKey = key;

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
}
