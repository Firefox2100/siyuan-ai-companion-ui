import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';

import 'package:siyuan_ai_companion_ui/model/form_factor.dart';
import 'package:siyuan_ai_companion_ui/service/transcribe.dart';
import 'package:siyuan_ai_companion_ui/service/localization.dart';

class TranscribePage extends StatefulWidget {
  const TranscribePage({super.key});

  @override
  State<TranscribePage> createState() => _TranscribePageState();
}

class _TranscribePageState extends State<TranscribePage> {
  late Future<List<AudioAsset>> _audioAssetsFuture;

  void _refreshAssetList() {
    setState(() {
      _audioAssetsFuture = TranscribeService.getAudioAssets();
    });
  }

  Future<void> _onTranscribeAudio(String path) async {
    await TranscribeService.transcribeAudioAsset(path);

    _refreshAssetList();
  }

  @override
  void initState() {
    super.initState();

    _audioAssetsFuture = TranscribeService.getAudioAssets();
  }

  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.sizeOf(context).width;
    final l10n = LocalizationService.l10n;

    return Scaffold(
      appBar: AppBar(
        title:
            screenWidth > FormFactor.mobile
                ? Row(
                  mainAxisSize: MainAxisSize.max,
                  mainAxisAlignment: MainAxisAlignment.start,
                  crossAxisAlignment: CrossAxisAlignment.end,
                  children: [
                    SvgPicture.asset(
                      'assets/images/logo.svg',
                      semanticsLabel: l10n.logoLabel,
                      height: 40,
                    ),
                    Expanded(child: Center(child: Text(l10n.transcribe))),
                  ],
                )
                : Row(
                  mainAxisSize: MainAxisSize.max,
                  mainAxisAlignment: MainAxisAlignment.start,
                  crossAxisAlignment: CrossAxisAlignment.end,
                  children: [
                    SvgPicture.asset(
                      'assets/images/logo.svg',
                      semanticsLabel: l10n.logoLabel,
                      height: 40,
                    ),
                    Padding(
                      padding: EdgeInsets.symmetric(horizontal: 15),
                      child: Text(l10n.transcribe),
                    ),
                  ],
                ),
        actions: [
          IconButton(
            icon: const Icon(Icons.refresh),
            onPressed: _refreshAssetList,
          ),
        ],
      ),
      body: FutureBuilder<List<AudioAsset>>(
        future: _audioAssetsFuture,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Scaffold(
              body: Center(child: CircularProgressIndicator()),
            );
          }

          if (snapshot.hasError) {
            return Scaffold(
              body: Center(
                child: Text('Error loading audio assets: ${snapshot.error}'),
              ),
            );
          }

          final audioAssets = snapshot.data ?? [];

          if (audioAssets.isEmpty) {
            return Scaffold(
              body: Center(child: Text(l10n.noAudioAssetMessage)),
            );
          }

          if (screenWidth > FormFactor.mobile) {
            // Two-column layout for larger screens
            return GridView.builder(
              gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 2,
                childAspectRatio: 1.5,
              ),
              itemCount: audioAssets.length,
              itemBuilder: (context, index) {
                final asset = audioAssets[index];
                return Card(
                  child: ListTile(
                    title: Text(asset.path),
                    subtitle: Text(
                      asset.transcriptionBlockId ?? l10n.noTranscription,
                    ),
                    trailing:
                        asset.transcriptionBlockId == null
                            ? IconButton(
                              onPressed: () => _onTranscribeAudio(asset.path),
                              icon: const Icon(Icons.rotate_left_outlined),
                            )
                            : null,
                  ),
                );
              },
            );
          } else {
            // Single-column layout for smaller screens
            return ListView.builder(
              itemCount: audioAssets.length,
              itemBuilder: (context, index) {
                final asset = audioAssets[index];
                return Card(
                  child: ListTile(
                    title: Text(asset.path),
                    subtitle: Text(
                      asset.transcriptionBlockId ?? l10n.noTranscription,
                    ),
                    trailing:
                        asset.transcriptionBlockId == null
                            ? IconButton(
                              onPressed: () => _onTranscribeAudio(asset.path),
                              icon: const Icon(Icons.rotate_left_outlined),
                            )
                            : null,
                  ),
                );
              },
            );
          }
        },
      ),
    );
  }
}
