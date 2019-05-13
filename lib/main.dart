import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter/foundation.dart' show SynchronousFuture;
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:scheibner_app/Localizations.dart';
import 'package:scheibner_app/helpers/appmodel.dart';
import 'package:scheibner_app/pages/ergebnissePage.dart';
import 'package:scheibner_app/pages/metadataPage.dart';
import 'package:scheibner_app/pages/saveCommentsPage.dart';
import 'package:scoped_model/scoped_model.dart';

class ScheibnerApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: 3,
      child: Scaffold(
        appBar: AppBar(
            leading: IconButton(
              icon: Icon(Icons.menu),
              onPressed: () {
                //TODO add menu actions
              },
            ),
            bottom: TabBar(
              tabs: [
                Tab(
                    text:
                        ScheibnerLocalizations.of(context).getValue("metadata"),
                    icon: Icon(Icons.input)),
                Tab(
                    text:
                        ScheibnerLocalizations.of(context).getValue("results"),
                    icon: Icon(Icons.laptop_chromebook)),
                Tab(
                    text:
                        ScheibnerLocalizations.of(context).getValue("comments"),
                    icon: Icon(Icons.save)),
              ],
            ),
            //title: Text("tmp")),
            //internationalization, nullpointer, ask cardinaels
            title: Text(ScheibnerLocalizations.of(context).getValue("title"))),
        body: TabBarView(
          children: [metadataPage(), ergebnissePage(), saveCommentsPage()],
        ),
      ),
    );
  }
}

class Scheibner extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      onGenerateTitle: (BuildContext context) =>
          ScheibnerLocalizations.of(context).getValue("title"),
      localizationsDelegates: [
        const DemoLocalizationsDelegate(),
        GlobalMaterialLocalizations.delegate,
        GlobalWidgetsLocalizations.delegate,
      ],
      supportedLocales: [
        const Locale('en', ''),
        const Locale('de', ''),
      ],
      // Watch out: MaterialApp creates a Localizations widget
      // with the specified delegates. DemoLocalizations.of()
      // will only find the app's Localizations widget if its
      // context is a child of the app.
      home: ScopedModel<AppModel>(
        model: AppModel(), // TODO: is this ok? or use static field instead?
        child: ScheibnerApp(),
      )
    );
  }
}

void main() {
  runApp(Scheibner());
}
