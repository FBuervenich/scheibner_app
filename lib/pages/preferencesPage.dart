import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:preferences/preferences.dart';
import 'package:scheibner_app/localization/app_translations.dart';
import 'package:scheibner_app/localization/application.dart';

class PreferencesPage extends StatefulWidget {
  @override
  PreferencesPageState createState() => new PreferencesPageState();
}

class PreferencesPageState extends State<PreferencesPage> {
  static final List<String> languagesList = application.supportedLanguages;
  static final List<String> languageCodesList =
      application.supportedLanguagesCodes;

  final Map<dynamic, dynamic> languagesMap = {
    languagesList[0]: languageCodesList[0],
    languagesList[1]: languageCodesList[1],
  };

  String label = languagesList[0];

  @override
  void initState() {
    super.initState();
    application.onLocaleChanged = onLocaleChange;
    // onLocaleChange(Locale(languagesMap["English"]));
  }

  void onLocaleChange(Locale locale) async {
    setState(() {
      AppTranslations.load(locale);
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(AppTranslations.of(context).text("preferences")),
      ),
      body: PreferencePage([
        PreferenceTitle(AppTranslations.of(context).text("general")),
        DropdownPreference(
          AppTranslations.of(context).text("inputAppereance"),
          'input_mode',
          values: [
            AppTranslations.of(context).text("inputModeTextFields"),
            AppTranslations.of(context).text("inputModeSliders"),
          ],
        ),
        PreferenceTitle(AppTranslations.of(context).text("countrySettings")),
        DropdownPreference(
          AppTranslations.of(context).text("language"),
          'language',
          values: [
            AppTranslations.of(context).text("languageGerman"),
            AppTranslations.of(context).text("languageEnglish"),
          ],
          onChange: (String lang) {
            this.onLocaleChange(Locale(lang.toLowerCase()));      
          },
        ),
      ]),
    );
  }
}
