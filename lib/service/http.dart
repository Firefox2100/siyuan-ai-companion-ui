import 'dart:convert';

import 'package:http/http.dart' as http;

import 'package:siyuan_ai_companion_ui/model/consts.dart';

class HttpException implements Exception {
  final String message;
  HttpException(this.message);

  @override
  String toString() {
    return 'HTTP request error: $message';
  }
}

class HttpService {
  static final _client = http.Client();

  static Future<Map<String, dynamic>> rawGet(String url) async {
    final response = await _client.get(Uri.parse(url));

    if (response.statusCode != 200) {
      throw HttpException('Failed to load data: ${response.statusCode}');
    }

    final Map<String, dynamic> data = jsonDecode(response.body);

    return data;
  }

  static Future<Map<String, dynamic>> rawPost(
    String url,
    Map<String, dynamic> payload,
  ) async {
    final response = await _client.post(
      Uri.parse(url),
      headers: {'Content-Type': 'application/json'},
      body: jsonEncode(payload),
    );

    if (response.statusCode != 200) {
      throw HttpException('Failed to load data: ${response.statusCode}');
    }

    final Map<String, dynamic> data = jsonDecode(response.body);

    return data;
  }

  static Future<List<String>> getContextForPrompt(
    String prompt,
    String model,
  ) async {
    final data = await HttpService.rawPost(
      'http://localhost:5000/openai/direct/v1/retrieve',
      //'$ORIGIN/openai/direct/v1/retrieve',
      {
        'prompt': prompt,
        'model': model,
      },
    );

    return List<String>.from(data['context'].map((x) => x.toString()));
  }
}
