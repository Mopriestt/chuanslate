import 'dart:collection';

import 'package:translator/translator.dart';

class CacheService {
  static const cacheLimit = 3000;

  final Map<String, Translation> _cache = {};
  final Queue<String> _sources = Queue();

  Future<void> cacheWord(String source, Translation translation) async {
    _cache[source] = translation;
    _sources.add(source);
    while (_cache.length > cacheLimit) {
      _cache.remove(_sources.removeFirst());
    }
  }

  Translation? getCachedWord(String source) => _cache[source];
}