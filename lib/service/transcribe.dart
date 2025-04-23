import 'dart:convert';

import 'package:http/http.dart' as http;

import 'package:siyuan_ai_companion_ui/model/consts.dart';

class TranscribeException implements Exception {
  final String message;
  TranscribeException(this.message);

  @override
  String toString() {
    return 'Transcribe error: $message';
  }
}

class AudioAsset {
  final String path;
  final String transcriptionBlockId;

  AudioAsset({required this.path, required this.transcriptionBlockId});
}

class TranscribeService {
  static final http.Client _client = http.Client();

  static Future<Map<String, dynamic>> _rawGet(String url) async {
    final response = await http.get(Uri.parse(url));

    if (response.statusCode != 200) {
      throw TranscribeException('Failed to load data: ${response.statusCode}');
    }

    final Map<String, dynamic> data = jsonDecode(response.body);

    return data;
  }

  static Future<List<AudioAsset>> getAudioAssets() async {
    final data = await _rawGet('$ORIGIN/assets/audio');

    final assets = <AudioAsset>[];
    
    for (final asset in data.entries) {
      assets.add(AudioAsset(path: asset, transcriptionBlockId: transcriptionBlockId))
    }
  }
}
