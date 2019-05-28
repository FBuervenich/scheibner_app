import 'dart:collection';

import 'package:barcode_scan/barcode_scan.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:scheibner_app/commonWidgets/charts/chartData.dart';
import 'package:charts_flutter/flutter.dart' as charts;
import 'package:scheibner_app/data/appmodel.dart';
import 'package:scheibner_app/data/data.dart';
import 'package:scoped_model/scoped_model.dart';

class ChartInitializer {
  Map<String, Color> colors;
  Map<String, double> diffpercent = new HashMap();
  Data meas;
  Data sim;

  ChartInitializer(this.meas, this.sim) {
    colors = new Map();
    diffpercent = new Map();

    _initDiff();
    _initColors();
  }

  void _initColors() {
    List<Color> defaultColors = [
      Colors.red,
      Colors.amber,
      Colors.yellow,
      Colors.green,
      Colors.cyan,
      Colors.blue,
      Colors.indigo,
      Colors.purple,
      Colors.purple,
      Colors.purple,
      Colors.purple,
      Colors.purple,
      Colors.purple,
      Colors.purple,
      Colors.purple,
      Colors.pink
    ];
    //Iterate over Values which are interessting for Charts
    for (int i = 0; i < Data.chartable.length; i++) {
      colors[Data.chartable[i]] = defaultColors[i];
    }
  }

  void _initDiff() {
    //Iterate over Values which are interessting for Charts
    Data.chartable.forEach((key) {
      //Init Differenz in Percent
      if (meas.getValue(key) == null) {
        return;
      }
      double diff = sim.getValue(key) - meas.getValue(key);
      if (diff < 0) {
        diff = diff * -1;
      }
      diffpercent[key] = (diff / meas.getValue(key) * 100).round().toDouble();
    });
  }

  List<String> _getMaxDiffs() {
    //Sortieren der Differenzen
    List<double> diffs = diffpercent.values.toList();
    diffs.sort((double a, double b) {
      if (a < b) {
        return 1;
      }
      
      if (b < a) {
        return -1;
      }
      return 0;
    });
    diffs = diffs.sublist(0, 4);

    List<String> ret = new List();
    //Keys der Differenzen in ret packen
    diffpercent.forEach((key, value) {
      if (diffs.contains(value)) {
        ret.add(key);
        diffs.remove(value);
      }
    });

    return ret;
  }

  List<ChartRow> getResultChartViewData() {
    List<ChartRow> ret = new List<ChartRow>();

    //PercentDiff
    ret.add(new ChartRow([_createPercentDiffChart()]));

    List<String> mostDiffentMeasures = _getMaxDiffs();

    //Je 2 Charts in eine Row
    List<Chart> charts = new List();
    for (int i = 0; i < mostDiffentMeasures.length; i++) {
      if (i != 0 && i % 2 == 0) {
        ret.add(new ChartRow(charts));
        charts = new List();
      }
      charts.add(_newOldChart(mostDiffentMeasures[i]));
    }
    ret.add(new ChartRow(charts));
    //Biggest Changes in Solo Diagramm

    return ret;
  }

  Chart _newOldChart(String kennzahl) {
    //Fill data
    List<BarChartData> data = [];
    data.add(new BarChartData("alt", meas.getValue(kennzahl), Colors.blue));
    data.add(new BarChartData("neu", sim.getValue(kennzahl), Colors.green));

    return new Chart(
      ChartType.simpleBarChart,
      data: [
        new charts.Series<BarChartData, String>(
            id: 'Sales',
            colorFn: (BarChartData sales, __) =>
                charts.ColorUtil.fromDartColor(sales.color),
            domainFn: (BarChartData sales, _) => sales.year.substring(0, 3),
            measureFn: (BarChartData sales, _) => sales.sales,
            data: data,
            labelAccessorFn: (BarChartData sales, _) =>
                '${sales.year}: \$${sales.sales.toString()}')
      ],
      animate: true,
      barChartBehaviors: [
        new charts.ChartTitle(kennzahl,
            // subTitle: '',
            behaviorPosition: charts.BehaviorPosition.top,
            titleOutsideJustification: charts.OutsideJustification.start,
            innerPadding: 18,
            titleStyleSpec: new charts.TextStyleSpec(fontSize: 15)),
      ],
    );
  }

  Chart _createPercentDiffChart() {
    //Fill data
    List<BarChartData> data = [];
    diffpercent.forEach((key, value) {
      data.add(new BarChartData(key, value, colors[key]));
    });

    return new Chart(
      ChartType.horizonalBarChart,
      data: [
        new charts.Series<BarChartData, String>(
            id: 'Sales',
            colorFn: (BarChartData sales, __) =>
                charts.ColorUtil.fromDartColor(sales.color),
            domainFn: (BarChartData sales, _) => sales.year.substring(0, 3),
            measureFn: (BarChartData sales, _) => sales.sales,
            data: data,
            labelAccessorFn: (BarChartData sales, _) =>
                '${sales.year}: ${sales.sales.toString()}%',
            insideLabelStyleAccessorFn: (BarChartData sales, _) =>
                new charts.TextStyleSpec(fontSize: 11))
      ],
      animate: true,
      barChartBehaviors: [
        new charts.ChartTitle('Percentage Changes of Measurementvalues',
            // subTitle: '',
            behaviorPosition: charts.BehaviorPosition.top,
            titleOutsideJustification: charts.OutsideJustification.start,
            innerPadding: 18,
            titleStyleSpec: new charts.TextStyleSpec(fontSize: 17)),
      ],
    );
  }

  static List<ChartRow> getExampleCharts() {
    Chart c1 = Chart.getExampleBarChart();
    Chart c2 = Chart.getExamplePieChart();

    List<ChartRow> listItems = new List<ChartRow>();
    listItems.add(new ChartRow([c1]));
    listItems.add(new ChartRow([c2]));
    listItems.add(new ChartRow([c2]));
    return listItems;
  }
}
