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
      "modifyValues": "Modify values for simulation",
      "measurementID": "Measurement ID:",
      "loadFromServer": "Load from server",
      "loadFromQRCode": "Load from QR code",
      "radumfangVorn": "Front wheel",
      "radumfangHinten": "Rear wheel",
      "gabellaenge": "Front fork",
      "heckhoehe": "Rear height",
      "schwingenlaenge": "TODO",
      "lkwgrad": "TODO",
      "nachlauf": "TODO",
      "offset": "TODO",
      "schwingenwinkelGrad": "TODO",
      "radstand": "TODO",
      "vorderachshoehe": "TODO",
      "hinterachshoehe": "TODO",
    },
    'de': {
      'title': 'Scheibner App',
      'title2': 'titll2',
      "metadata": "Metadaten",
      "results": "Ergebnisse",
      "comments": "Kommentare",
      "modifyValues": "Messwerte für Simulation anpassen",
      "measurementID": "ID der Messung:",
      "loadFromServer": "Vom Server laden",
      "loadFromQRCode": "Aus QR-Code laden",
      "radumfangVorn": "Radumfang vorne",
      "radumfangHinten": "Radumfang hinten",
      "gabellaenge": "Gabellänge",
      "heckhoehe": "Heckhöhe",
      "schwingenlaenge": "Schwingenlaenge",
      "lkwgrad": "Lenkkopfwinkel",
      "nachlauf": "Nachlauf",
      "offset": "Offset",
      "schwingenwinkelGrad": "Schwingenwinkel",
      "radstand": "Radstand",
      "vorderachshoehe": "Vorderachshöhe",
      "hinterachshoehe": "Hinterachshöhe",
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
