class TranslateService {
  Future<String> translate(String input) {
    return Future.delayed(const Duration(milliseconds: 100), () => input);
  }
}