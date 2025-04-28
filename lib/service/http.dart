import 'dart:async';
import 'dart:convert';

import 'package:http/http.dart' as http;
import 'package:http_parser/http_parser.dart';

import 'package:siyuan_ai_companion_ui/model/consts.dart';

class HttpException implements Exception {
  final String message;
  HttpException(this.message);

  @override
  String toString() {
    return 'HTTP request error: $message';
  }
}

enum AuthType { none, apiKey }

class HttpService {
  static final _client = http.Client();
  static String? apiKey;

  static Future<Map<String, dynamic>> rawGet(String url) async {
    final response = await _client.get(
      Uri.parse(url),
      headers: {
        if (apiKey != null && apiKey!.isNotEmpty)
          'Authorization': 'Bearer $apiKey',
      },
    );

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
      headers: {
        'Content-Type': 'application/json',
        if (apiKey != null && apiKey!.isNotEmpty)
          'Authorization': 'Bearer $apiKey',
      },
      body: jsonEncode(payload),
    );

    if (response.statusCode != 200) {
      throw HttpException('Failed to load data: ${response.statusCode}');
    }

    final Map<String, dynamic> data = jsonDecode(response.body);

    return data;
  }

  static Future<http.StreamedResponse> rawMultipartRequest(
    String url,
    String method,
    List<int> fileBytes, {
    String filename = 'recording.wav',
    MediaType? contentType,
  }) async {
    final request = http.MultipartRequest(method, Uri.parse(url))
      ..files.add(
        http.MultipartFile.fromBytes(
          'file',
          fileBytes,
          filename: filename,
          contentType: contentType ?? MediaType('audio', 'wav'),
        ),
      );

    final streamedResponse = await _client.send(request);

    if (streamedResponse.statusCode != 200) {
      throw HttpException(
        'Failed to upload file: ${streamedResponse.statusCode}',
      );
    }

    return streamedResponse;
  }

  static Future<List<String>> getContextForPrompt(
    String prompt,
    String model,
  ) async {
    final data = await HttpService.rawPost(
      '$ORIGIN/openai/direct/v1/retrieve',
      {'prompt': prompt, 'model': model},
    );

    return List<String>.from(data['context'].map((x) => x.toString()));
  }

  static Future<AuthType> getAuthConfig() async {
    final data = await HttpService.rawGet('$ORIGIN/health');

    if (data['apiKeyRequired'] == true) {
      return AuthType.apiKey;
    } else {
      return AuthType.none;
    }
  }
}
