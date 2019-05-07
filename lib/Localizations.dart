import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter/foundation.dart' show SynchronousFuture;

class ScheibnerLocalizations {
  ScheibnerLocalizations(this.locale);

  final Locale locale;

  static ScheibnerLocalizations of(BuildContext context) {
    return Localizations.of<ScheibnerLocalizations>(
        context, ScheibnerLocalizations);
  }

  static Map<String, Map<String, String>> _localizedValues = {
    'en': {
      'title': 'Scheibner App',
      'title2': 'titll2',
      "metadata": "Metadata",
      "results": "Results",
      "comments": "Comments",
    },
    'de': {
      'title': 'Scheibner App',
      'title2': 'titll2',
      "metadata": "Metadaten",
      "results": "Ergebnisse",
      "comments": "Kommentare",
    },
  };

  String getValue(val) {
    return _localizedValues[locale.languageCode][val];
  }
}

class DemoLocalizationsDelegate
    extends LocalizationsDelegate<ScheibnerLocalizations> {
  const DemoLocalizationsDelegate();

  @override
  bool isSupported(Locale locale) => ['en', 'de'].contains(locale.languageCode);

  @override
  Future<ScheibnerLocalizations> load(Locale locale) {
    // Returning a SynchronousFuture here because an async "load" operation
    // isn't needed to produce an instance of DemoLocalizations.
    return SynchronousFuture<ScheibnerLocalizations>(
        ScheibnerLocalizations(locale));
  }

  @override
  bool shouldReload(DemoLocalizationsDelegate old) => false;
}
