import 'dart:async';

import 'package:chuanslate/service/settings_service.dart';
import 'package:translator/translator.dart';
import 'package:chuanslate/service/cache_service.dart';

bool isMajorlyEnglish(String input) {
  int cnLetter = 0, enLetter = 0;
  for (int i = 0; i < input.length; i++) {
    if (input[i].trim().isEmpty) continue;
    input[i].toUpperCase().contains(RegExp('[A-Z]')) ? enLetter++ : cnLetter++;
  }
  return enLetter > cnLetter;
}

class TranslateService {
  static const outWallUrl = 'translate.googleapis.com';
  static const inWallUrl = 'translate.google.cn';
  static const enLang = 'en';

  final SettingsService _settingsService;
  final _translator = GoogleTranslator();
  final _cacheService = CacheService();

  late String _cnLang;

  TranslateService(this._settingsService) {
    fetchChineseLanguage();
  }

  void fetchChineseLanguage() => _cnLang = _settingsService.chineseLanguage;

  Future<Translation?> translate(String input, {bool inWall = false}) async {
    input = input.trim();
    if (input.isEmpty) return null;

    final cnLang = _cnLang;
    final cachedTranslation = _cacheService.getCachedWord(input, cnLang);
    if (cachedTranslation != null) return cachedTranslation;

    _translator.baseUrl = inWall ? inWallUrl : outWallUrl;
    final langFrom = isMajorlyEnglish(input) ? enLang : cnLang;
    final langTo = langFrom == enLang ? cnLang : enLang;
    final translation = await _translator.translate(
      input,
      from: langFrom,
      to: langTo,
    );

    unawaited(_cacheService.cacheWord(input, translation, cnLang));
    return translation;
  }
}

const _langs = {
  'auto': 'Automatic',
  'af': 'Afrikaans',
  'sq': 'Albanian',
  'am': 'Amharic',
  'ar': 'Arabic',
  'hy': 'Armenian',
  'az': 'Azerbaijani',
  'eu': 'Basque',
  'be': 'Belarusian',
  'bn': 'Bengali',
  'bs': 'Bosnian',
  'bg': 'Bulgarian',
  'ca': 'Catalan',
  'ceb': 'Cebuano',
  'ny': 'Chichewa',
  'zh-cn': 'Chinese Simplified',
  'zh-tw': 'Chinese Traditional',
  'co': 'Corsican',
  'hr': 'Croatian',
  'cs': 'Czech',
  'da': 'Danish',
  'nl': 'Dutch',
  'en': 'English',
  'eo': 'Esperanto',
  'et': 'Estonian',
  'tl': 'Filipino',
  'fi': 'Finnish',
  'fr': 'French',
  'fy': 'Frisian',
  'gl': 'Galician',
  'ka': 'Georgian',
  'de': 'German',
  'el': 'Greek',
  'gu': 'Gujarati',
  'ht': 'Haitian Creole',
  'ha': 'Hausa',
  'haw': 'Hawaiian',
  'iw': 'Hebrew',
  'hi': 'Hindi',
  'hmn': 'Hmong',
  'hu': 'Hungarian',
  'is': 'Icelandic',
  'ig': 'Igbo',
  'id': 'Indonesian',
  'ga': 'Irish',
  'it': 'Italian',
  'ja': 'Japanese',
  'jw': 'Javanese',
  'kn': 'Kannada',
  'kk': 'Kazakh',
  'km': 'Khmer',
  'ko': 'Korean',
  'ku': 'Kurdish (Kurmanji)',
  'ky': 'Kyrgyz',
  'lo': 'Lao',
  'la': 'Latin',
  'lv': 'Latvian',
  'lt': 'Lithuanian',
  'lb': 'Luxembourgish',
  'mk': 'Macedonian',
  'mg': 'Malagasy',
  'ms': 'Malay',
  'ml': 'Malayalam',
  'mt': 'Maltese',
  'mi': 'Maori',
  'mr': 'Marathi',
  'mn': 'Mongolian',
  'my': 'Myanmar (Burmese)',
  'ne': 'Nepali',
  'no': 'Norwegian',
  'ps': 'Pashto',
  'fa': 'Persian',
  'pl': 'Polish',
  'pt': 'Portuguese',
  'pa': 'Punjabi',
  'ro': 'Romanian',
  'ru': 'Russian',
  'sm': 'Samoan',
  'gd': 'Scots Gaelic',
  'sr': 'Serbian',
  'st': 'Sesotho',
  'sn': 'Shona',
  'sd': 'Sindhi',
  'si': 'Sinhala',
  'sk': 'Slovak',
  'sl': 'Slovenian',
  'so': 'Somali',
  'es': 'Spanish',
  'su': 'Sundanese',
  'sw': 'Swahili',
  'sv': 'Swedish',
  'tg': 'Tajik',
  'ta': 'Tamil',
  'te': 'Telugu',
  'th': 'Thai',
  'tr': 'Turkish',
  'uk': 'Ukrainian',
  'ur': 'Urdu',
  'uz': 'Uzbek',
  'ug': 'Uyghur',
  'vi': 'Vietnamese',
  'cy': 'Welsh',
  'xh': 'Xhosa',
  'yi': 'Yiddish',
  'yo': 'Yoruba',
  'zu': 'Zulu'
};
