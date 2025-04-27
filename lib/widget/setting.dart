import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import 'package:siyuan_ai_companion_ui/provider/config.dart';

class SettingInput extends StatefulWidget {
  const SettingInput({super.key, required this.formKey});

  final GlobalKey<FormState> formKey;

  @override
  State<SettingInput> createState() => _SettingInputState();
}

class _SettingInputState extends State<SettingInput> {
  final TextEditingController _openAiOrgIdController = TextEditingController();
  final TextEditingController _openAiModelController = TextEditingController();
  final TextEditingController _openAiApiUrlController = TextEditingController();
  final TextEditingController _openAiSystemPromptController =
      TextEditingController();

  late bool enableRag;

  @override
  void initState() {
    super.initState();

    final configProvider = context.read<ConfigProvider>();

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

    enableRag = configProvider.enableRag;
  }

  @override
  void dispose() {
    _openAiOrgIdController.dispose();
    _openAiModelController.dispose();
    _openAiApiUrlController.dispose();

    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final configProvider = context.watch<ConfigProvider>();

    return Form(
      key: widget.formKey,
      child: Column(
        mainAxisSize: MainAxisSize.min,
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(
            padding: EdgeInsets.only(left: 40),
            child: Text(
              'OpenAI API Settings',
              style: TextStyle(fontWeight: FontWeight.bold),
            ),
          ),
          const Padding(
            padding: EdgeInsets.symmetric(vertical: 20, horizontal: 40),
            child: Divider(),
          ),
          Padding(
            padding: EdgeInsets.only(top: 10, bottom: 10, right: 50),
            child: TextFormField(
              controller: _openAiOrgIdController,
              decoration: const InputDecoration(
                icon: Icon(Icons.account_circle),
                labelText: 'OpenAI Organization ID',
                hintText: 'Optional if using self-hosted OpenAI API',
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
            padding: EdgeInsets.only(top: 10, bottom: 10, right: 50),
            child: TextFormField(
              controller: _openAiModelController,
              decoration: const InputDecoration(
                icon: Icon(Icons.model_training),
                labelText: 'OpenAI Model',
                hintText: 'The model to use for generation',
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
            padding: EdgeInsets.only(top: 10, bottom: 10, right: 50),
            child: TextFormField(
              controller: _openAiApiUrlController,
              decoration: const InputDecoration(
                icon: Icon(Icons.api),
                labelText: 'OpenAI API URL',
                hintText: 'Leave empty to use the backend API',
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
            padding: EdgeInsets.only(top: 10, bottom: 10, right: 50),
            child: TextFormField(
              controller: _openAiSystemPromptController,
              decoration: const InputDecoration(
                icon: Icon(Icons.api),
                labelText: 'OpenAI System Prompt',
                hintText: 'The system prompt to use for generation',
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
            padding: EdgeInsets.only(top: 10, bottom: 10, right: 50),
            child: SwitchListTile(
              title: const Text('Enable RAG'),
              value: enableRag,
              onChanged: (value) {
                setState(() {
                  enableRag = value;
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
