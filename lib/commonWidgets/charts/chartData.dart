import 'package:charts_flutter/flutter.dart' as charts;
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';

class ChartRow {
  List<Widget> charts;
  Widget widget;

  ChartRow(this.charts);
  ChartRow.byWidget(this.widget);

  bool isWidget() {
    return widget != null;
  }
}

//Chart Data, its types and its implementations
abstract class ChartData {}

enum ChartType { simpleBarChart, pieChart, horizonalBarChart }

class BarChartData implements ChartData {
  final String year;
  final double sales;
  final Color color;
  BarChartData(this.year, this.sales, this.color);
}

class LinearSales implements ChartData {
  final String year;
  final int sales;

  final Color color;

  LinearSales(this.year, this.sales, this.color);
}
