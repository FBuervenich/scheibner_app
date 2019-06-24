import 'dart:async';
import 'dart:convert';
import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart' show rootBundle;

///class AppTranslations
class AppTranslations {
  Locale locale;
  static Map<dynamic, dynamic> _localisedValues;

  ///constructor for AppTranslations for a given Locale [locale]
  AppTranslations(Locale locale) {
    this.locale = locale;
  }

  ///returns itself
  static AppTranslations of(BuildContext context) {
    return Localizations.of<AppTranslations>(context, AppTranslations);
  }

  ///loads the translations for a given [locale]
  static Future<AppTranslations> load(Locale locale) async {
    AppTranslations appTranslations = AppTranslations(locale);
    String jsonContent =
    await rootBundle.loadString("assets/locale/localization_${locale.languageCode}.json");
    _localisedValues = json.decode(jsonContent);
    return appTranslations;
  }

  ///getter for currentLanguage
  get currentLanguage => locale.languageCode;

  ///return the translated text for a given [key]
  String text(String key) {
    return _localisedValues[key] ?? "Translation missing: $key";
  }
}