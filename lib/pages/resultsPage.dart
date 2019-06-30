import 'package:flutter/material.dart';
import 'package:ScheibnerSim/components/threePointMenu.dart';
import 'package:ScheibnerSim/localization/app_translations.dart';

import 'resultsChartView.dart';
import 'resultsSaveView.dart';
import 'resultsTableView.dart';

///class ResultsPage
class ResultsPage extends StatelessWidget {
  @override
  ///class for ResultsPage
  Widget build(BuildContext context) {
    return new DefaultTabController(
      initialIndex: 1,
      length: 3,
      child: new Scaffold(
        appBar: new AppBar(
          title: new Text(
            AppTranslations.of(context).text("resultsTitle"),
          ),
          actions: <Widget>[
            new ThreePointWidget(),
          ],
          bottom: new TabBar(
            tabs: [
              new Tab(icon: Icon(Icons.format_list_bulleted)),
              new Tab(icon: Icon(Icons.insert_chart)),
              new Tab(icon: Icon(Icons.save)),
            ],
          ),
        ),
        // backgroundColor: backgroundColor,
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
