import 'package:shared_preferences/shared_preferences.dart';

class SettingsService {
  static const chineseLanguageKey = 'cn_lang';
  static const gfwModeKey = 'gfw_mode';

  late final SharedPreferences sp;

  Future<void> init() async => sp = await SharedPreferences.getInstance();

  Future<bool> toggleChineseLanguage() => sp.setString(
        chineseLanguageKey,
        chineseLanguage == 'zh-cn' ? 'zh-tw' : 'zh-cn',
      );

  String get chineseLanguage => sp.getString(chineseLanguageKey) ?? 'zh-cn';

  Future<bool> toggleGfwMode() => sp.setBool(gfwModeKey, !isGfwMode);

  bool get isGfwMode => sp.getBool(gfwModeKey) ?? false;
}
