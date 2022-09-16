import 'package:chuanslate/service/translate_service.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class TranslateBody extends StatefulWidget {
  const TranslateBody({super.key});

  @override
  State<TranslateBody> createState() => TranslateBodyState();
}

class TranslateBodyState extends State<TranslateBody> {
  late final _controller = TextEditingController()..addListener(onInputChanged);
  String _translation = '';

  void resetInput() => setState(() => _controller.text = '');

  void onInputChanged() async {
    _translation = await context.read<TranslateService>().translate(_controller.text);
    setState(() {});
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
/*      onChanged: (input) async {
        _translation = await context.read<TranslateService>().translate(input);
        setState(() {});
      },*/
    );
  }

  Widget _buildTranslationText(BuildContext context) {
    return Text(
      _translation,
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
          if (_translation.isNotEmpty)
            const Padding(
              padding: EdgeInsets.symmetric(vertical: 24, horizontal: 120),
              child: Divider(thickness: 2),
            ),
          if (_translation.isNotEmpty)
            Align(
              alignment: Alignment.centerLeft,
              child: _buildTranslationText(context),
            )
        ],
      ),
    );
  }
}
