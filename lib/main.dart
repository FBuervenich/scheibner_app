import 'package:flutter/material.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:scheibner_app/i18n/localization.dart';
import 'package:scheibner_app/pages/ergebnissePage.dart';
import 'package:scheibner_app/pages/metadataPage.dart';
import 'package:scheibner_app/pages/saveCommentsPage.dart';

void main() {
  runApp(TabBarDemo());
}

class TabBarDemo extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      supportedLocales: [const Locale('en', 'US'), const Locale('de', 'DE')],
      localizationsDelegates: [
        const LocalizationDelegate(),
        GlobalMaterialLocalizations.delegate,
        GlobalWidgetsLocalizations.delegate
      ],
      localeResolutionCallback:
          (Locale locale, Iterable<Locale> supportedLocales) {
        for (Locale supportedLocale in supportedLocales) {
          if (supportedLocale.languageCode == locale.languageCode ||
              supportedLocale.countryCode == locale.countryCode) {
            return supportedLocale;
          }
        }

        return supportedLocales.first;
      },

      home: DefaultTabController(
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
              title: Text("tmp")),
              //internationalization, nullpointer, ask cardinaels
              //title: Text(Localization.of(context).getValue("AppTitle"));
          body: TabBarView(
            children: [metadataPage(), ergebnissePage(), saveCommentsPage()],
          ),
        ),
      ),
    );
  }
}
