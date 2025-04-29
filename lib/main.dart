import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import 'package:siyuan_ai_companion_ui/provider/config.dart';
import 'package:siyuan_ai_companion_ui/page/auth.dart';
import 'package:siyuan_ai_companion_ui/page/chat.dart';
import 'package:siyuan_ai_companion_ui/service/http.dart';
import 'package:siyuan_ai_companion_ui/service/localization.dart';
import 'package:siyuan_ai_companion_ui/l10n/localizations.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  final authType = await HttpService.getAuthConfig();

  runApp(
    MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (context) => ConfigProvider()),
      ],
      child: MyApp(authType: authType),
    ),
  );
}

class MyApp extends StatefulWidget {
  const MyApp({super.key, required this.authType});

  final AuthType authType;

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  bool _isLoading = true;

  @override
  void initState() {
    super.initState();

    final configProvider = context.read<ConfigProvider>();

    WidgetsBinding.instance.addPostFrameCallback((_) async {
      await configProvider.init();

      if (mounted) {
        setState(() {
          _isLoading = false;
        });
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    if (_isLoading) {
      return const MaterialApp(
        home: Scaffold(body: Center(child: CircularProgressIndicator())),
      );
    }

    final configProvider = context.watch<ConfigProvider>();
    final l10n = AppLocalizations.of(context)!;
    LocalizationService.update(l10n);

    return MaterialApp(
      title: 'SiYuan AI Companion',
      onGenerateTitle: (context) => l10n.appTitle,
      localizationsDelegates: AppLocalizations.localizationsDelegates,
      supportedLocales: AppLocalizations.supportedLocales,
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Color(0xFFDA3838)),
      ),
      home:
          (widget.authType != AuthType.none && configProvider.openAiKey == null)
              ? const AuthPage()
              : const ChatPage(),
    );
  }
}
