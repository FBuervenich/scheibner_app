import 'package:flutter/material.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:ScheibnerSim/data/appmodel.dart';
import 'package:ScheibnerSim/pages/preferencesPage.dart';
import 'package:ScheibnerSim/pages/profilePage.dart';
import 'package:ScheibnerSim/pages/simulationPage.dart';
import 'package:ScheibnerSim/pages/dataInputPage.dart';
import 'package:ScheibnerSim/pages/resultsPage.dart';
import 'package:ScheibnerSim/styles.dart';
import 'package:scoped_model/scoped_model.dart';
import 'package:preferences/preferences.dart';

import 'package:ScheibnerSim/localization/app_translations_delegate.dart';
import 'package:ScheibnerSim/localization/application.dart';

import 'data/profileList.dart';

final model = new AppModel();
final profileList = new ProfileList();

void main() async {
  await PrefService.init(prefix: 'pref_');
  PrefService.setDefaultValues({'language': 'DE', 'input_mode': 'Slider'});

  runApp(new ScopedModel<AppModel>(
    model: model,
    child: new ScheibnerApp(),
  ));
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
        backgroundColor: backgroundColor,
        scaffoldBackgroundColor: backgroundColor,
        primaryColor: highlightColor,
        accentColor: highlightColor,
        buttonColor: highlightColor,
        iconTheme: IconThemeData(
          color: Colors.white,
        ),
        textTheme: new TextTheme(
          display4: new TextStyle(
            fontSize: 24,
            color: Colors.white,
          ),
        ),
      ),
      home: new ProfilePage(),
      routes: {
        '/profiles': (BuildContext context) => new ProfilePage(),
        '/inputdata': (BuildContext context) => new DataInputPage(),
        '/simulation': (BuildContext context) => new SimulationPage(),
        '/results': (BuildContext context) => new ResultsPage(),
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

  // ScopedModel _scopedModelWrappera(Model model, widget) {
  //   return new ScopedModel<T>(
  //     model: model,
  //     child: widget,
  //   );
  // }
}
