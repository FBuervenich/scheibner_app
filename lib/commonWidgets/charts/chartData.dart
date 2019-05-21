import 'package:charts_flutter/flutter.dart' as charts;
import 'package:flutter/widgets.dart';

class ChartViewRow {
  List<Chart> chartList;
  ChartViewRow(this.chartList);
}

class Chart {
  List<charts.Series<ChartData, String>> data;
  ChartType chartType;
  bool animate;
  List<charts.ChartTitle> barChartBehaviors;
  List<charts.ChartBehavior> pieChartBehaviors;

  Chart(this.chartType, {@required this.data, this.animate, this.barChartBehaviors, this.pieChartBehaviors});
}

abstract class ChartData {}

enum ChartType { simpleBarChart, pieChart }
