import 'package:chuanslate/service/settings_service.dart';
import 'package:chuanslate/service/setu_service.dart';
import 'package:chuanslate/service/translate_service.dart';
import 'package:chuanslate/strings.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:translator/translator.dart';
import 'dart:convert' show utf8;
import 'package:collection/collection.dart';

class TranslateBody extends StatefulWidget {
  const TranslateBody({super.key});

  @override
  State<TranslateBody> createState() => TranslateBodyState();
}

class TranslateBodyState extends State<TranslateBody> {
  late final _controller = TextEditingController()..addListener(onInputChanged);
  Translation? _translation;
  int _lastRequestTimeMs = 0;
  double _fontSize = 36;
  bool _setuMode = false;

  void resetInput() => setState(() => _controller.text = '');

  void _setFontSize(int textLen) => setState(() {
        if (textLen < 15) {
          _fontSize = 36;
        } else if (textLen < 40) {
          _fontSize = 32;
        } else if (textLen < 80) {
          _fontSize = 28;
        } else {
          _fontSize = 24;
        }
      });

  void onInputChanged() async {
    if (const ListEquality().equals(utf8.encode(_controller.text), secretWord)) {
      setState(() => _setuMode = true);
      return;
    }

    _lastRequestTimeMs = DateTime.now().millisecondsSinceEpoch;
    final timeStampMs = _lastRequestTimeMs;

    _setFontSize(_controller.text.length);

    final translationService = context.read<TranslateService>();
    final translationFutures = Future.any([
      translationService.translate(_controller.text, inWall: false),
      if (context.read<SettingsService>().isGfwMode)
        translationService.translate(_controller.text, inWall: true),
    ]);
    final translation = await translationFutures;

    if (!mounted) return;

    if (_lastRequestTimeMs == timeStampMs) {
      setState(() {
        _translation = translation;
        _setuMode = false;
      });
    }
  }

  Widget _buildInputText(BuildContext context) {
    return TextField(
      controller: _controller,
      decoration: InputDecoration.collapsed(
        hintText: 'Enter here',
        hintStyle: TextStyle(color: Theme.of(context).hintColor),
      ),
      style: TextStyle(fontSize: _fontSize),
      cursorColor: Theme.of(context).hintColor,
      maxLines: null,
    );
  }

  Widget _buildTranslationText(BuildContext context) {
    return Text(
      _translation?.text ?? '',
      style: TextStyle(
        fontSize: _fontSize,
        color: Theme.of(context).hintColor.withOpacity(0.6),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: Column(
        children: [
          _buildInputText(context),
          if (_translation != null && _translation?.text.isNotEmpty == true)
            const Padding(
              padding: EdgeInsets.symmetric(vertical: 24, horizontal: 120),
              child: Divider(thickness: 2),
            ),
          if (_setuMode)
            FutureBuilder(
              future: context.watch<SetuService>().setuUrl,
              builder: (_, snapShot) {
                if (!snapShot.hasData) {
                  return const CircularProgressIndicator();
                }
                return Stack(children: [
                  Image.network(snapShot.data!),
                  IconButton(onPressed: () {
                    context.read<SetuService>().refresh();
                  }, icon: const Icon(Icons.refresh)),
                ]);
              },
            ),
          if (!_setuMode && _translation != null)
            Align(
              alignment: Alignment.centerLeft,
              child: _buildTranslationText(context),
            )
        ],
      ),
    );
  }
}
