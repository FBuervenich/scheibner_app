import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter/foundation.dart' show SynchronousFuture;
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:scheibner_app/Localizations.dart';
import 'package:scheibner_app/data/appmodel.dart';
import 'package:scheibner_app/pages/preferencesPage.dart';
import 'package:scheibner_app/pages/profilePage.dart';
import 'package:scheibner_app/pages/simulationPage.dart';
import 'package:scheibner_app/pages/dataInputPage.dart';
import 'package:scheibner_app/pages/resultsPage.dart';
import 'package:scoped_model/scoped_model.dart';
import 'package:preferences/preferences.dart';

void main() async {
  await PrefService.init(prefix: 'pref_');
  //TODO bengsch: check if values are null --> initalize them

  final model = new AppModel();

  runApp(
    new ScopedModel<AppModel>(
      model: model,
      child: new ScheibnerApp(),
    ),
  );
}

class ScheibnerApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return new MaterialApp(
      onGenerateTitle: (BuildContext context) =>
          ScheibnerLocalizations.of(context).getValue("title"),
      localizationsDelegates: [
        const DemoLocalizationsDelegate(),
        GlobalMaterialLocalizations.delegate,
        GlobalWidgetsLocalizations.delegate,
      ],
      supportedLocales: [
        const Locale('en'),
        const Locale('de'),
      ],
      // Watch out: MaterialApp creates a Localizations widget
      // with the specified delegates. DemoLocalizations.of()
      // will only find the app's Localizations widget if its
      // context is a child of the app.
      theme: new ThemeData(
        textTheme: new TextTheme(
          display4: new TextStyle(
            fontSize: 24,
          ),
        ),
      ),
      home: new DataInputPage(),
      routes: {
        '/profiles': (BuildContext context) => new ProfilePage(),
        '/inputdata': (BuildContext context) => new DataInputPage(),
        '/simulation': (BuildContext context) => new SimulationPage(),
        '/results': (BuildContext context) => new ResultsPage(),
        '/preferences': (BuildContext context) => new PreferencesPage(),
      },
    );
  }
}
