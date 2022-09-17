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
  DateTime _lastRequestTime = DateTime.now();

  void resetInput() => setState(() => _controller.text = '');

  void onInputChanged() {
    _lastRequestTime = DateTime.now();
    int timeStampMs = _lastRequestTime.millisecondsSinceEpoch;

    context
        .read<TranslateService>()
        .translate(_controller.text)
        .then((translation) {
      if (_lastRequestTime.millisecondsSinceEpoch == timeStampMs) {
        setState(() => _translation = translation);
      }
    });
  }

  Widget _buildInputText(BuildContext context) {
    return TextField(
      controller: _controller,
      decoration: InputDecoration.collapsed(
        hintText: 'Enter here',
        hintStyle: TextStyle(color: Theme.of(context).hintColor),
      ),
      style: const TextStyle(fontSize: 32),
      cursorColor: Theme.of(context).hintColor,
      maxLines: null,
    );
  }

  Widget _buildTranslationText(BuildContext context) {
    return Text(
      _translation?.text ?? '',
      style: TextStyle(
        fontSize: 32,
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
