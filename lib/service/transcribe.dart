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

  static Future<void> transcribeAudio(String path) async {
    await HttpService.rawPost(
      '$ORIGIN/assets/audio/transcribe',
      {'assetPath': path},
    );
  }
}
