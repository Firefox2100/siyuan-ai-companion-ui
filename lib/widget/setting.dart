import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import 'package:siyuan_ai_companion_ui/provider/config.dart';
import 'package:siyuan_ai_companion_ui/service/http.dart';
import 'package:siyuan_ai_companion_ui/service/localization.dart';

class SettingInput extends StatefulWidget {
  const SettingInput({super.key, required this.formKey});

  final GlobalKey<FormState> formKey;

  @override
  State<SettingInput> createState() => _SettingInputState();
}

class _SettingInputState extends State<SettingInput> {
  final TextEditingController _openAiKeyController = TextEditingController();
  final TextEditingController _openAiOrgIdController = TextEditingController();
  final TextEditingController _openAiModelController = TextEditingController();
  final TextEditingController _openAiApiUrlController = TextEditingController();
  final TextEditingController _openAiSystemPromptController =
      TextEditingController();

  late bool _enableRag;
  String? _chatSavingNotebookId;

  bool _isKeyHidden = true;
  bool _isLoading = true;
  List<Map<String, dynamic>> _notebooks = [];

  @override
  void initState() {
    super.initState();

    final configProvider = context.read<ConfigProvider>();

    if (configProvider.openAiKey != null &&
        configProvider.openAiKey!.isNotEmpty) {
      _openAiKeyController.text = configProvider.openAiKey!;
    }
    if (configProvider.openAiOrgId != null &&
        configProvider.openAiOrgId!.isNotEmpty) {
      _openAiOrgIdController.text = configProvider.openAiOrgId!;
    }
    if (configProvider.openAiModel != null &&
        configProvider.openAiModel!.isNotEmpty) {
      _openAiModelController.text = configProvider.openAiModel!;
    }
    if (configProvider.openAiApiUrl != null &&
        configProvider.openAiApiUrl!.isNotEmpty) {
      _openAiApiUrlController.text = configProvider.openAiApiUrl!;
    }
    if (configProvider.openAiSystemPrompt.isNotEmpty) {
      _openAiSystemPromptController.text = configProvider.openAiSystemPrompt;
    }

    _chatSavingNotebookId = configProvider.chatSavingNotebookId;
    _enableRag = configProvider.enableRag;

    WidgetsBinding.instance.addPostFrameCallback((_) async {
      final notebooks = await HttpService.getNotebooks();

      if (mounted) {
        setState(() {
          _notebooks = notebooks;
          _isLoading = false;
        });
      }
    });
  }

  @override
  void dispose() {
    _openAiKeyController.dispose();
    _openAiOrgIdController.dispose();
    _openAiModelController.dispose();
    _openAiApiUrlController.dispose();

    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final configProvider = context.watch<ConfigProvider>();
    final l10n = LocalizationService.l10n;

    return Form(
      key: widget.formKey,
      child: Column(
        mainAxisSize: MainAxisSize.min,
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(
            padding: const EdgeInsets.only(left: 40),
            child: Text(
              l10n.openAiApiSettings,
              style: TextStyle(fontWeight: FontWeight.bold),
            ),
          ),
          const Padding(
            padding: const EdgeInsets.symmetric(vertical: 20, horizontal: 40),
            child: Divider(),
          ),
          Padding(
            padding: const EdgeInsets.only(top: 10, bottom: 10, right: 50),
            child: TextFormField(
              controller: _openAiKeyController,
              decoration: InputDecoration(
                icon: const Icon(Icons.key),
                labelText: l10n.apiKey,
                hintText: l10n.apiKeyHint,
                border: OutlineInputBorder(),
                suffixIcon: IconButton(
                  onPressed: () {
                    setState(() {
                      _isKeyHidden = !_isKeyHidden;
                    });
                  },
                  icon:
                      _isKeyHidden
                          ? const Icon(Icons.visibility_off)
                          : const Icon(Icons.visibility),
                ),
              ),
              onSaved: (value) {
                if (value == null || value.isEmpty) {
                  return;
                }
                configProvider.setOpenAiKey(value);
              },
              obscureText: _isKeyHidden,
              enableSuggestions: false,
              autocorrect: false,
            ),
          ),
          Padding(
            padding: const EdgeInsets.only(top: 10, bottom: 10, right: 50),
            child: TextFormField(
              controller: _openAiOrgIdController,
              decoration: InputDecoration(
                icon: const Icon(Icons.account_circle),
                labelText: l10n.orgId,
                hintText: l10n.orgIdHint,
                border: OutlineInputBorder(),
              ),
              onSaved: (value) {
                if (value == null || value.isEmpty) {
                  return;
                }
                configProvider.setOpenAiOrgId(value);
              },
            ),
          ),
          Padding(
            padding: const EdgeInsets.only(top: 10, bottom: 10, right: 50),
            child: TextFormField(
              controller: _openAiModelController,
              decoration: InputDecoration(
                icon: const Icon(Icons.model_training),
                labelText: l10n.openAiModel,
                hintText: l10n.openAiModelHint,
                border: OutlineInputBorder(),
              ),
              onSaved: (value) {
                if (value == null || value.isEmpty) {
                  return;
                }
                configProvider.setOpenAiModel(value);
              },
            ),
          ),
          Padding(
            padding: const EdgeInsets.only(top: 10, bottom: 10, right: 50),
            child: TextFormField(
              controller: _openAiApiUrlController,
              decoration: InputDecoration(
                icon: const Icon(Icons.api),
                labelText: l10n.openAiApiUrl,
                hintText: l10n.openAiApiUrlHint,
                border: OutlineInputBorder(),
              ),
              onSaved: (value) {
                if (value == null || value.isEmpty) {
                  return;
                }
                configProvider.setOpenAiApiUrl(value);
              },
            ),
          ),
          Padding(
            padding: const EdgeInsets.only(top: 10, bottom: 10, right: 50),
            child: TextFormField(
              controller: _openAiSystemPromptController,
              decoration: InputDecoration(
                icon: const Icon(Icons.message),
                labelText: l10n.openAiSystemPrompt,
                hintText: l10n.openAiSystemPromptHint,
                border: OutlineInputBorder(),
              ),
              minLines: 5,
              maxLines: 5,
              onSaved: (value) {
                if (value == null || value.isEmpty) {
                  return;
                }
                configProvider.setOpenAiSystemPrompt(value);
              },
            ),
          ),
          Padding(
            padding: const EdgeInsets.only(top: 10, bottom: 10, right: 50),
            child: DropdownButtonFormField<String>(
              value:
                  _notebooks.any((n) => n['id'] == _chatSavingNotebookId)
                      ? _chatSavingNotebookId
                      : null,
              hint: Text(l10n.chatSavingNotebookHint),
              decoration: InputDecoration(
                icon: const Icon(Icons.book),
                labelText: l10n.chatSavingNotebook,
                border: OutlineInputBorder(),
                suffixIcon:
                    _isLoading
                        ? const SizedBox(
                          width: 24,
                          height: 24,
                          child: Padding(
                            padding: EdgeInsets.all(4.0),
                            child: CircularProgressIndicator(strokeWidth: 2),
                          ),
                        )
                        : null,
              ),
              items:
                  _notebooks.map((notebook) {
                    return DropdownMenuItem<String>(
                      value: notebook['id'] as String,
                      child: Row(
                        children: [
                          Text(
                            notebook['icon'] as String,
                            style: const TextStyle(fontSize: 20),
                          ),
                          const SizedBox(width: 10),
                          Expanded(child: Text(notebook['name'] as String)),
                        ],
                      ),
                    );
                  }).toList(),
              onChanged: (value) {
                setState(() {
                  _chatSavingNotebookId = value;
                });
              },
              onSaved: (value) {
                if (value == null || value.isEmpty) {
                  return;
                }
                configProvider.setChatSavingNotebookId(value);
              },
            ),
          ),
          Padding(
            padding: const EdgeInsets.only(top: 10, bottom: 10, right: 50),
            child: SwitchListTile(
              title: Text(l10n.enableRag),
              value: _enableRag,
              onChanged: (value) {
                setState(() {
                  _enableRag = value;
                });
                configProvider.setEnableRag(value);
              },
            ),
          ),
        ],
      ),
    );
  }
}
