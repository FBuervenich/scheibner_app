import 'package:flutter/material.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:scheibner_app/data/appmodel.dart';
import 'package:scheibner_app/pages/preferencesPage.dart';
import 'package:scheibner_app/pages/profilePage.dart';
import 'package:scheibner_app/pages/simulationPage.dart';
import 'package:scheibner_app/pages/dataInputPage.dart';
import 'package:scheibner_app/pages/resultsPage.dart';
import 'package:scheibner_app/styles.dart';
import 'package:scoped_model/scoped_model.dart';
import 'package:preferences/preferences.dart';

import 'package:scheibner_app/localization/app_translations_delegate.dart';
import 'package:scheibner_app/localization/application.dart';

import 'data/profileList.dart';

final model = new AppModel();
final profileList = new ProfileList();

void main() async {
  await PrefService.init(prefix: 'pref_');

  runApp(
      // new ScopedModel<AppModel>(
      //   model: model,
      //   child: new ScheibnerApp(),
      // )
      new ScheibnerApp());
}

class ScheibnerApp extends StatefulWidget {
  @override
  ScheibnerAppState createState() {
    return new ScheibnerAppState();
  }
}

class ScheibnerAppState extends State<ScheibnerApp> {
  AppTranslationsDelegate _newLocaleDelegate;

  @override
  void initState() {
    super.initState();

    String localeFromPrefs = PrefService.getString("language");

    _newLocaleDelegate = AppTranslationsDelegate(
        newLocale: localeFromPrefs != null
            ? Locale(localeFromPrefs.toLowerCase())
            : null);
    application.onLocaleChanged = onLocaleChange;
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      theme: new ThemeData(
        primaryColor: highlightColor,
        accentColor: highlightColor,
        textTheme: new TextTheme(
          display4: new TextStyle(
            fontSize: 24,
          ),
        ),
      ),
      // profilePage
      home: new ScopedModel<ProfileList>(
        model: profileList,
        child: new ProfilePage(),
      ),
      // dataInputPage
      // home: new ScopedModel<AppModel>(
      //   model: profileList,
      //   child: new DataInputPage(),
      // ),
      routes: {
        '/profiles': (BuildContext context) => new ScopedModel<ProfileList>(
              model: profileList,
              child: new ProfilePage(),
            ),
        '/inputdata': (BuildContext context) => new ScopedModel<AppModel>(
              model: model,
              child: new DataInputPage(),
            ),
        '/simulation': (BuildContext context) => new ScopedModel<AppModel>(
              model: model,
              child: new SimulationPage(),
            ),
        '/results': (BuildContext context) => new ScopedModel<AppModel>(
              model: model,
              child: new ResultsPage(),
            ),
        '/preferences': (BuildContext context) => new PreferencesPage(),
      },
      localizationsDelegates: [
        _newLocaleDelegate,
        //provides localised strings
        GlobalMaterialLocalizations.delegate,
        //provides RTL support
        GlobalWidgetsLocalizations.delegate,
      ],
      supportedLocales: [
        const Locale('en'),
        const Locale('de'),
      ],
    );
  }

  void onLocaleChange(Locale locale) {
    setState(() {
      _newLocaleDelegate = AppTranslationsDelegate(newLocale: locale);
    });
  }

  // Wrap a widget into a given Scoped Model
  ScopedModel _scopedModelWrapper(Model model, widget) {
    return new ScopedModel(
      model: model,
      child: widget,
    );
  }
}

// class _scopedModelWrapperc<T> {

//   ScopedModel _scopedModelWrappera(Model model, T modelType, widget) {
//     return new ScopedModel<T>(
//       model: model,
//       child: widget,
//     );
//   }
// }
