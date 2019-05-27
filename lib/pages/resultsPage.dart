import 'package:flutter/material.dart';
import 'package:scheibner_app/Localizations.dart';
import 'package:scheibner_app/styles.dart';

import 'resultsChartView.dart';
import 'resultsSaveView.dart';
import 'resultsTableView.dart';

class ResultsPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return new DefaultTabController(
      length: 3,
      child: new Scaffold(
        appBar: new AppBar(
          title: new Text(
            ScheibnerLocalizations.of(context).getValue("resultsTitle"),
          ),
          actions: <Widget>[
            new IconButton(
              icon: new Icon(Icons.settings),
              onPressed: () {
                Navigator.pushNamed(context, '/preferences');
              },
            ),
          ],
          bottom: new TabBar(
            tabs: [
              new Tab(icon: Icon(Icons.data_usage)),
              new Tab(icon: Icon(Icons.pie_chart)),
              new Tab(icon: Icon(Icons.save)),
            ],
          ),
        ),
        backgroundColor: backgroundColor,
        body: new TabBarView(
          children: [
            new TableView(),
            new ChartView(),
            new SaveView(),
          ],
        ),
      ),
    );
  }
}
