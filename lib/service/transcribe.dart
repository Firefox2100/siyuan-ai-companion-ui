import 'dart:convert';
import 'dart:typed_data';

import 'package:siyuan_ai_companion_ui/model/consts.dart';
import 'package:siyuan_ai_companion_ui/service/http.dart';

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
  final String? transcriptionBlockId;

  AudioAsset({required this.path, this.transcriptionBlockId});
}

class TranscribeService {
  static Future<List<AudioAsset>> getAudioAssets() async {
    final data = await HttpService.rawGet('$ORIGIN/assets/audio');

    final assets = <AudioAsset>[];

    for (final asset in data.entries) {
      assets.add(
        AudioAsset(path: asset.key, transcriptionBlockId: asset.value),
      );
    }

    return assets;
  }

  static Future<void> transcribeAudioAsset(String assetPath) async {
    await HttpService.rawPost(
      '$ORIGIN/assets/audio/transcribe',
      {'assetPath': assetPath},
    );
  }

  static Stream<String> transcribeAudioStream(Uint8List audioBytes) async* {
    final streamedResponse = await HttpService.rawMultipartRequest(
      '$ORIGIN/openai/direct/v1/transcribe',
      'POST',
      audioBytes,
    );

    await for (final chunk in streamedResponse.stream.transform(utf8.decoder)) {
      yield chunk;
    }
  }
}
