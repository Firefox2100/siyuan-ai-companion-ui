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
  final TextEditingController _openAiKeyController = TextEditingController();
  final TextEditingController _openAiOrgIdController = TextEditingController();
  final TextEditingController _openAiModelController = TextEditingController();
  final TextEditingController _openAiApiUrlController = TextEditingController();

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
              controller: _openAiKeyController,
              decoration: const InputDecoration(
                icon: Icon(Icons.key),
                labelText: 'OpenAI API Key',
                hintText: 'Optional if using self-hosted OpenAI API',
                border: OutlineInputBorder(),
              ),
              onSaved: (value) {
                if (value == null || value.isEmpty) {
                  return;
                }
                configProvider.setOpenAiKey(value);
              },
            ),
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
                hintText: 'Leave empty to use the official OpenAI API',
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
        ],
      ),
    );
  }
}
