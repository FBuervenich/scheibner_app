import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:preferences/preferences.dart';
import 'package:ScheibnerSim/localization/app_translations.dart';
import 'package:ScheibnerSim/localization/application.dart';

import '../styles.dart';

///class PreferencesPage
class PreferencesPage extends StatefulWidget {
  @override
  ///create state for PreferencesPage
  PreferencesPageState createState() => new PreferencesPageState();
}
///state for PreferencesPage
class PreferencesPageState extends State<PreferencesPage> {
  String currentInputAppearance = PrefService.getString("input_mode");
  String currentLanguage = PrefService.getString("language");

  @override
  ///init state for PreferencesPageState
  void initState() {
    super.initState();
    application.onLocaleChanged = onLocaleChange;
  }

  ///triggers apps' localeChange with a given [locale]
  void onLocaleChange(Locale locale) async {
    setState(() {
      AppTranslations.load(locale);
    });
  }

  ///callback that fires when input mode is changed, [changed] contains the new value
  void changedInputAppearance(String changed) {
    PrefService.setString("input_mode", changed);
    setState(() {
      currentInputAppearance = changed;
    });
  }

  ///callback that fires when language is changed, [changed] contains the new value
  void changedLanguage(String changed) {
    PrefService.setString("language", changed);
    this.onLocaleChange(Locale(changed.toLowerCase()));
    setState(() {
      currentLanguage = changed;
    });
  }

  ///get dropdownlist for input mode
  List<DropdownMenuItem<String>> getDropDownMenuItemsInputAppearance() {
    List<DropdownMenuItem<String>> items = new List();
    for (String input in [
      AppTranslations.of(context).text("inputModeTextFields"),
      AppTranslations.of(context).text("inputModeSliders"),
    ]) {
      items.add(new DropdownMenuItem(
          value: input,
          child: new Text(
            input,
            style: highlightTextStyle,
          )));
    }
    return items;
  }

  ///get dropdownlist for language
  List<DropdownMenuItem<String>> getDropDownMenuItemsLanguage() {
    List<DropdownMenuItem<String>> items = new List();
    for (String lang in [
      AppTranslations.of(context).text("languageGerman"),
      AppTranslations.of(context).text("languageEnglish"),
    ]) {
      items.add(new DropdownMenuItem(
          value: lang,
          child: new Text(
            lang,
            style: highlightTextStyle,
          )));
    }
    return items;
  }

  @override
  ///build for PreferencesPage
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(AppTranslations.of(context).text("preferences")),
      ),
      body: PreferencePage([
        PreferenceTitle(AppTranslations.of(context).text("general"),
            style: settingsStyle),
        Row(
          children: <Widget>[
            Padding(
              padding: EdgeInsets.only(left: 10.0),
              child: Text(
                AppTranslations.of(context).text("inputAppereance"),
                style: highlightTextStyle,
              ),
            ),
            Expanded(child: Container()),
            Padding(
              padding: EdgeInsets.all(10.0),
              child: new DropdownButton(
                value: currentInputAppearance,
                items: getDropDownMenuItemsInputAppearance(),
                onChanged: changedInputAppearance,
              ),
            )
          ],
        ),
        PreferenceTitle(AppTranslations.of(context).text("countrySettings"),
            style: settingsStyle),
        Row(
          children: <Widget>[
            Padding(
              padding: EdgeInsets.only(left: 10.0),
              child: Text(
                AppTranslations.of(context).text("language"),
                style: highlightTextStyle,
              ),
            ),
            Expanded(child: Container()),
            Padding(
              padding: EdgeInsets.all(10.0),
              child: new DropdownButton(
                value: currentLanguage,
                items: getDropDownMenuItemsLanguage(),
                onChanged: changedLanguage,
              ),
            )
          ],
        ),
      ]),
    );
  }
}
