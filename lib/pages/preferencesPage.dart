import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:preferences/preferences.dart';
import 'package:scheibner_app/Localizations.dart';

class PreferencesPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(ScheibnerLocalizations.of(context).getValue("preferences")),
      ),
      body: PreferencePage([
        PreferenceTitle(ScheibnerLocalizations.of(context).getValue("general")),
        DropdownPreference(
          ScheibnerLocalizations.of(context).getValue("inputAppereance"),
          'input_mode',
          defaultVal:
              ScheibnerLocalizations.of(context).getValue("inputModeSliders"),
          values: [
            ScheibnerLocalizations.of(context).getValue("inputModeTextFields"),
            ScheibnerLocalizations.of(context).getValue("inputModeSliders"),
          ],
        ),
        PreferenceTitle(
            ScheibnerLocalizations.of(context).getValue("countrySettings")),
        DropdownPreference(
          ScheibnerLocalizations.of(context).getValue("language"),
          'language',
          defaultVal:
              ScheibnerLocalizations.of(context).getValue("languageGerman"),
          values: [
            ScheibnerLocalizations.of(context).getValue("languageGerman"),
            ScheibnerLocalizations.of(context).getValue("languageEnglish"),
          ],
        ),
      ]),
    );
  }
}
