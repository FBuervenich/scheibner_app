import 'dart:async';
import 'package:flutter/material.dart';
import 'package:scheibner_app/localization/app_translations.dart';
import 'package:preferences/preference_service.dart';
import 'package:scheibner_app/localization/application.dart';

class AppTranslationsDelegate extends LocalizationsDelegate<AppTranslations> {
  final Locale newLocale;

  const AppTranslationsDelegate({this.newLocale});

  @override
  bool isSupported(Locale locale) {
    return application.supportedLanguagesCodes.contains(locale.languageCode);
  }

  @override
  Future<AppTranslations> load(Locale locale) {
    String lang = PrefService.getString("language");
    return AppTranslations.load(Locale(lang.toLowerCase()));
  }

  @override
  bool shouldReload(LocalizationsDelegate<AppTranslations> old) {
    return true;
  }
}