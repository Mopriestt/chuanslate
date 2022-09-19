import 'package:chuanslate/home/translate_body.dart';
import 'package:chuanslate/service/settings_service.dart';
import 'package:chuanslate/service/translate_service.dart';
import 'package:flutter/material.dart';
import 'package:chuanslate/strings.dart';
import 'package:provider/provider.dart';

class Home extends StatefulWidget {
  const Home({super.key});

  @override
  State<Home> createState() => _HomeState();
}

class _HomeState extends State<Home> {
  final translateBodyKey = GlobalKey<TranslateBodyState>();

  // Toggles target chinese translation between zh-cn and zh-tw.
  Future<void> _toggleChineseLanguage() async {
    await context.read<SettingsService>().toggleChineseLanguage();
    if (!mounted) return;
    context.read<TranslateService>().fetchChineseLanguage();
    translateBodyKey.currentState?.onInputChanged();
    setState(() {});
  }

  Future<void> _toggleGfwMode() async {
    await context.read<SettingsService>().toggleGfwMode();
    if (!mounted) return;
    final isGfwMode = context.read<SettingsService>().isGfwMode;

    ScaffoldMessenger.of(context).clearSnackBars();
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text('GFW Mode ${isGfwMode ? "ON" : "OFF"} !'),
        duration: const Duration(seconds: 1),
      ),
    );
    setState(() {});
  }

  AppBar appBar() => AppBar(
        title: const Text(
          appName,
          style: TextStyle(color: Colors.blueAccent),
        ),
        elevation: 0,
        backgroundColor: Colors.transparent,
        actions: [
          TextButton(
            onPressed: _toggleChineseLanguage,
            child: Text(
              context.watch<SettingsService>().chineseLanguage == 'zh-cn'
                  ? '简'
                  : '繁',
              style: const TextStyle(fontSize: 24),
            ),
          ),
          TextButton(
            onPressed: _toggleGfwMode,
            child: Text(
              '墙',
              style: TextStyle(
                fontSize: 24,
                color: context.watch<SettingsService>().isGfwMode
                    ? Colors.blueAccent
                    : Colors.black54,
              ),
            ),
          ),
          IconButton(
            onPressed: () => translateBodyKey.currentState?.resetInput(),
            icon: const Icon(Icons.clear, color: Colors.black),
          ),
        ],
      );

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: appBar(),
      body: Padding(
        padding: const EdgeInsets.only(left: 18, right: 18, top: 28, bottom: 0),
        child: TranslateBody(key: translateBodyKey),
      ),
    );
  }
}
