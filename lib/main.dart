import 'package:chuanslate/home/home.dart';
import 'package:chuanslate/service/settings_service.dart';
import 'package:chuanslate/service/setu_service.dart';
import 'package:chuanslate/service/translate_service.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  final settingsService = SettingsService();
  await settingsService.init();

  final translateService = TranslateService(settingsService);

  runApp(
    MultiProvider(
      providers: [
        Provider.value(value: translateService),
        Provider.value(value: settingsService),
        ChangeNotifierProvider(create: (_) => SetuService()),
      ],
      child: app(),
    ),
  );
}

MaterialApp app() => const MaterialApp(home: Home());
