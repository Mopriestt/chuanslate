import 'package:translator/translator.dart';

class CacheService {
  final Map<String, Translation> _cache = {};

  Future<void> cacheWord(String source, Translation translation) async {
    _cache[source] = translation;
    while (_cache.length > 3000) {
      _cache.remove(_cache.keys.first);
    }
  }

  Translation? getCachedWord(String source) => _cache[source];
}