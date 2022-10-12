import 'package:flutter/cupertino.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

class SetuService extends ChangeNotifier {
  late Future<String> setuUrl = _getSetuUrl();

  Future<String> _getSetuUrl() async {
    final url = Uri.https(
      'iw233.cn',
      'api.php',
      {'sort': 'random', 'type': 'json'},
    );
    final response = await http.get(url);
    final Map<String, dynamic> data = jsonDecode(response.body);

    return (data['pic']! as List).first as String;
  }

  void refresh() {
    setuUrl = _getSetuUrl();
    notifyListeners();
  }
}
