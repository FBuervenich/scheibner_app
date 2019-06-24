import 'dart:async';
import 'package:flutter/material.dart';
import 'package:ScheibnerSim/localization/app_translations.dart';
import 'package:preferences/preference_service.dart';
import 'package:ScheibnerSim/localization/application.dart';

///class AppTranslationsDelegate
class AppTranslationsDelegate extends LocalizationsDelegate<AppTranslations> {
  final Locale newLocale;

  ///constructor for AppTranslationsDelegate
  const AppTranslationsDelegate({this.newLocale});

  @override
  ///checks whether a given [locale] is supported
  bool isSupported(Locale locale) {
    return application.supportedLanguagesCodes.contains(locale.languageCode);
  }

  @override
  ///loads the translations for a given [locale]
  Future<AppTranslations> load(Locale locale) {
    String lang = PrefService.getString("language");
    return AppTranslations.load(Locale(lang.toLowerCase()));
  }

  @override
  ///callback whether build should be triggered again, always returns true
  bool shouldReload(LocalizationsDelegate<AppTranslations> old) {
    return true;
  }
}