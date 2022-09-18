import 'dart:collection';

import 'package:translator/translator.dart';

class CacheService {
  static const cacheLimit = 3000;

  final Map<String, Translation> _cache = {};
  final Queue<String> _sources = Queue();

  Future<void> cacheWord(
      String source, Translation translation, String cnLang) async {
    source += '@$cnLang@';
    _cache[source] = translation;
    _sources.add(source);
    while (_cache.length > cacheLimit && _sources.isNotEmpty) {
      _cache.remove(_sources.removeFirst());
    }
  }

  Translation? getCachedWord(String source, String cnLang) =>
      _cache['$source@$cnLang@'];
}
