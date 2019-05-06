import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter/foundation.dart' show SynchronousFuture;
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:scheibner_app/Localizations.dart';
import 'package:scheibner_app/pages/ergebnissePage.dart';
import 'package:scheibner_app/pages/metadataPage.dart';
import 'package:scheibner_app/pages/saveCommentsPage.dart';

class DemoApp extends StatelessWidget {
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
                  Tab(text: "metadata input", icon: Icon(Icons.input)),
                  Tab(text: "ergebnisse", icon: Icon(Icons.laptop_chromebook)),
                  Tab(text: "kommentare + save", icon: Icon(Icons.save)),
                ],
              ),
              //title: Text("tmp")),
              //internationalization, nullpointer, ask cardinaels
              title: Text(DemoLocalizations.of(context).getValue("title"))),
          body: TabBarView(
            children: [metadataPage(), ergebnissePage(), saveCommentsPage()],
          ),
        ),
      );
  }
}

class Demo extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      onGenerateTitle: (BuildContext context) => DemoLocalizations.of(context).getValue("title"),
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
      home: DemoApp(),
    );
  }
}

void main() {
  runApp(Demo());
}