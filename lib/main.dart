import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import 'package:siyuan_ai_companion_ui/provider/config.dart';
import 'package:siyuan_ai_companion_ui/page/chat.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  runApp(
    MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (context) => ConfigProvider()),
      ],
      child: const MyApp(),
    ),
  );
}

class MyApp extends StatefulWidget {
  const MyApp({super.key});

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  @override
  void initState() {
    super.initState();

    final configProvider = context.read<ConfigProvider>();

    WidgetsBinding.instance.addPostFrameCallback(
      (_) async {
        await configProvider.init();
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'SiYuan AI Companion',
      home: ChatPage(),
    );
  }
}
