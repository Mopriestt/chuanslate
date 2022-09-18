import 'package:chuanslate/service/translate_service.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:translator/translator.dart';

class TranslateBody extends StatefulWidget {
  const TranslateBody({super.key});

  @override
  State<TranslateBody> createState() => TranslateBodyState();
}

class TranslateBodyState extends State<TranslateBody> {
  late final _controller = TextEditingController()..addListener(onInputChanged);
  Translation? _translation;
  int _lastRequestTimeMs = 0;
  double _fontSize = 32;

  void resetInput() => setState(() => _controller.text = '');

  void _setFontSize(int textLen) => setState(() {
        if (textLen < 40) {
          _fontSize = 32;
        } else if (textLen < 80) {
          _fontSize = 28;
        } else {
          _fontSize = 24;
        }
      });

  void onInputChanged() async {
    _lastRequestTimeMs = DateTime.now().millisecondsSinceEpoch;
    final timeStampMs = _lastRequestTimeMs;

    _setFontSize(_controller.text.length);

    final translation = await context
        .read<TranslateService>()
        .translate(_controller.text);

    if (_lastRequestTimeMs == timeStampMs) {
      setState(() => _translation = translation);
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
          if (_translation != null)
            const Padding(
              padding: EdgeInsets.symmetric(vertical: 24, horizontal: 120),
              child: Divider(thickness: 2),
            ),
          if (_translation != null)
            Align(
              alignment: Alignment.centerLeft,
              child: _buildTranslationText(context),
            )
        ],
      ),
    );
  }
}
