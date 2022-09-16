import 'package:chuanslate/home/translate_body.dart';
import 'package:flutter/material.dart';
import 'package:chuanslate/strings.dart';

class Home extends StatefulWidget {
  const Home({super.key});

  @override
  State<Home> createState() => _HomeState();
}

class _HomeState extends State<Home> {
  final translateBodyKey = GlobalKey<TranslateBodyState>();

  AppBar appBar() => AppBar(
        title: const Text(
          appName,
          style: TextStyle(color: Colors.blueAccent),
        ),
        elevation: 0,
        backgroundColor: Colors.transparent,
        actions: [
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 24),
            child: IconButton(
              onPressed: () => translateBodyKey.currentState?.resetInput(),
              icon: const Icon(Icons.clear, color: Colors.black),
            ),
          )
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
