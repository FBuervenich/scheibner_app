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
      'dataInputTitle': 'Read Data',
      "simulationTitle": "Simulation",
      "resultsTitle": "Results",
      "comments": "Comments",
      "modifyValues": "Modify values for simulation",
      "measurementID": "Measurement ID:",
      "loadFromServer": "Load from server",
      "loadFromQRCode": "Load from QR code",
      "radumfang_vorn": "Front wheel",
      "radumfang_hinten": "Rear wheel",
      "gabellaenge": "Front fork",
      "heckhoehe": "Rear height",
      "schwingenlaenge": "Swing arm length",
      "lkwgrad": "Steering head angle",
      "nachlauf": "TODO",
      "offset": "TODO",
      "schwingenwinkelGrad": "TODO",
      "radstand": "TODO",
      "vorderachshoehe_read": "TODO",
      "hinterachshoehe_read": "TODO",
      "cameraPermissions":
          "No camera permission granted. Please go to settings and grand it!",
      "unknownError": "Unknown error: ",
      "errorDataLoading": "Error while calling Scheibner API",
      "errorJsonParsing": "Error while parsing JSON",
      "close": "Close",
      "inputModeTextFields": "Textfields",
      "inputModeSliders": "Sliders",
      "languageGerman": "German",
      "languageEnglish": "English",
      "preferences": "Preferences",
      "general": "General",
      "inputAppereance": "Input appereance",
      "countrySettings": "Country Settings",
      "language": "Language",
    },
    'de': {
      'title': 'Scheibner App',
      'dataInputTitle': 'Daten einlesen',
      "simulationTitle": "Simulation",
      "resultsTitle": "Ergebnisse",
      "comments": "Kommentare",
      "modifyValues": "Messwerte für Simulation anpassen",
      "measurementID": "ID der Messung:",
      "loadFromServer": "Vom Server laden",
      "loadFromQRCode": "Aus QR-Code laden",
      "radumfang_vorn": "Radumfang vorne",
      "radumfang_hinten": "Radumfang hinten",
      "gabellaenge": "Gabellänge",
      "heckhoehe": "Heckhöhe",
      "schwingenlaenge": "Schwingenlaenge",
      "lkwgrad": "Lenkkopfwinkel",
      "nachlauf": "Nachlauf",
      "offset": "Offset",
      "schwingenwinkelGrad": "Schwingenwinkel",
      "radstand": "Radstand",
      "vorderachshoehe_read": "Vorderachshöhe",
      "hinterachshoehe_read": "Hinterachshöhe",
      "cameraPermissions":
          "Keine Kamera-Berechtigung erteilt. Bitte erteilen Sie sie in den Einstellungen.",
      "unknownError": "Unbekannter Fehler: ",
      "errorDataLoading": "Fehler beim Aufrufen der Scheibner API",
      "errorJsonParsing": "Fehler beim Parsen des JSON",
      "close": "Schließen",
      "inputModeTextFields": "Textfelder",
      "inputModeSliders": "Slider",
      "languageGerman": "Deutsch",
      "languageEnglish": "Englisch",
      "preferences": "Einstellungen",
      "general": "Allgemein",
      "inputAppereance": "Darstellung Eingabe",
      "countrySettings": "Landeseinstellungen",
      "language": "Language",
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
  bool shouldReload(DemoLocalizationsDelegate old) => true;
}
