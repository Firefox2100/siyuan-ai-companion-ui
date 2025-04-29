import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:provider/provider.dart';

import 'package:siyuan_ai_companion_ui/page/chat.dart';
import 'package:siyuan_ai_companion_ui/provider/config.dart';
import 'package:siyuan_ai_companion_ui/service/localization.dart';

class AuthPage extends StatefulWidget {
  const AuthPage({super.key});

  @override
  State<AuthPage> createState() => _AuthPageState();
}

class _AuthPageState extends State<AuthPage> {
  final TextEditingController _apiKeyController = TextEditingController();
  bool _isHidden = true;

  Future<void> _onAuthenticate() async {
    final configProvider = context.read<ConfigProvider>();
    final apiKey = _apiKeyController.text.trim();

    await configProvider.setOpenAiKey(apiKey);

    if (mounted) {
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (context) => const ChatPage()),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    final l10n = LocalizationService.l10n;

    return Scaffold(
      body: Center(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Text(
                l10n.welcomeMessage,
                style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 16),
              Container(
                padding: EdgeInsets.all(15),
                decoration: BoxDecoration(
                  color:
                      Theme.of(context).colorScheme.brightness ==
                              Brightness.light
                          ? Theme.of(context).colorScheme.onPrimary
                          : Theme.of(context).colorScheme.onPrimaryContainer,
                  borderRadius: BorderRadius.circular(15),
                ),
                child: SvgPicture.asset(
                  'assets/images/logo.svg',
                  semanticsLabel: l10n.logoLabel,
                  height: 100,
                ),
              ),
              const SizedBox(height: 16),
              Text(
                l10n.authenticatePrompt,
                style: TextStyle(fontSize: 16),
              ),
              const SizedBox(height: 16),
              SizedBox(
                width: 420,
                child: Padding(
                  padding: EdgeInsets.only(right: 45),
                  child: TextField(
                    controller: _apiKeyController,
                    decoration: InputDecoration(
                      icon: Icon(Icons.key),
                      labelText: l10n.apiKey,
                      hintText: l10n.apiKeyHint,
                      border: OutlineInputBorder(),
                      suffixIcon: IconButton(
                        onPressed: () {
                          setState(() {
                            _isHidden = !_isHidden;
                          });
                        },
                        icon:
                            _isHidden
                                ? const Icon(Icons.visibility_off)
                                : const Icon(Icons.visibility),
                      ),
                    ),
                    onSubmitted: (value) {
                      _onAuthenticate();
                    },
                    obscureText: _isHidden,
                    enableSuggestions: false,
                    autocorrect: false,
                  ),
                ),
              ),
              const SizedBox(height: 16),
              ElevatedButton(
                onPressed: _onAuthenticate,
                child: Text(l10n.authenticate),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
