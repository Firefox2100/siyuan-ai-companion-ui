import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';
import 'package:flutter_ai_toolkit/flutter_ai_toolkit.dart';
import 'package:auto_route/annotations.dart';
import 'package:provider/provider.dart';

import 'package:siyuan_ai_companion_ui/model/form_factor.dart';
import 'package:siyuan_ai_companion_ui/provider/config.dart';
import 'package:siyuan_ai_companion_ui/provider/openai.dart';
import 'package:siyuan_ai_companion_ui/route/router.gr.dart';
import 'package:siyuan_ai_companion_ui/widget/setting.dart';

@RoutePage()
class ChatPage extends StatefulWidget {
  const ChatPage({super.key});

  @override
  State<ChatPage> createState() => _ChatPageState();
}

class _ChatPageState extends State<ChatPage>
    with SingleTickerProviderStateMixin {
  late final _animationController = AnimationController(
    duration: const Duration(seconds: 1),
    vsync: this,
    lowerBound: 0.25,
    upperBound: 1.0,
  );
  late final OpenAiProvider _provider;

  void _resetAnimation() {
    _animationController.value = 1.0;
    _animationController.reverse();
  }

  Future<void> _onShowSettings() async {
    final screenWidth = MediaQuery.sizeOf(context).width;
    final screenHeight = MediaQuery.sizeOf(context).height;

    if (screenWidth > FormFactor.mobile) {
      // Wider layout, display as a popup
      final formKey = GlobalKey<FormState>();

      await showDialog(
        context: context,
        builder: (context) {
          return AlertDialog(
            content: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text(
                  'Settings',
                  style: TextStyle(fontWeight: FontWeight.bold, fontSize: 24),
                ),
                const SizedBox(height: 16),
                SizedBox(
                  width: screenWidth * 0.7,
                  height: screenHeight * 0.5,
                  child: SingleChildScrollView(
                    child: SettingInput(formKey: formKey),
                  ),
                ),
              ],
            ),
            actions: [
              TextButton(
                onPressed: () => Navigator.pop(context),
                child: const Text('Cancel'),
              ),
              TextButton(
                onPressed: () {
                  if (formKey.currentState?.validate() ?? false) {
                    formKey.currentState?.save();
                    Navigator.pop(context);
                  }
                },
                child: const Text('Save'),
              ),
            ],
          );
        },
      );
    } else {
      // Navigate to setting page on mobile
      await context.router.navigate(SettingRoute());
    }
  }

  @override
  void initState() {
    super.initState();

    final configProvider = context.read<ConfigProvider>();
    _provider = OpenAiProvider(configProvider: configProvider);

    _resetAnimation();
  }

  @override
  void dispose() {
    _animationController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Chat'),
        actions: [
          IconButton(
            onPressed: () => _onShowSettings(),
            icon: const Icon(Icons.settings),
          ),
          // IconButton(
          //   onPressed: _clearHistory,
          //   tooltip: 'Clear History',
          //   icon: const Icon(Icons.history),
          // ),
        ],
      ),
      body: LlmChatView(
        provider: _provider,
        welcomeMessage: 'Welcome to SiYuan AI Companion!',
        suggestions: ['What is in my calendar today?'],
      ),
    );
  }
}
