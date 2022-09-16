import 'package:chuanslate/home/home.dart';
import 'package:chuanslate/service/translate_service.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

void main() {
  final translateService = TranslateService();

  runApp(MultiProvider(
    providers: [Provider.value(value: translateService)],
    child: app(),
  ));
}

MaterialApp app() => const MaterialApp(home: Home());
