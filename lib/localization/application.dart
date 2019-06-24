import 'dart:ui';
///comprehensive class Application
class Application {
  static final Application _application = Application._internal();

  ///factory for singleton Application
  factory Application() {
    return _application;
  }

  Application._internal();

  final List<String> supportedLanguages = [
    "English",
    "German",
  ];

  final List<String> supportedLanguagesCodes = [
    "en",
    "de",
  ];
  ///returns the list of supported Locales
  Iterable<Locale> supportedLocales() =>
      supportedLanguagesCodes.map<Locale>((language) => Locale(language, ""));
  ///function to be invoked when changing the language
  LocaleChangeCallback onLocaleChanged;
}
Application application = Application();
typedef void LocaleChangeCallback(Locale locale);