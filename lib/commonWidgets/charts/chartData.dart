import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';

///class ChartRow
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

///class BarChartData
class BarChartData implements ChartData {
  final String year;
  final double sales;
  final Color color;
  ///constructor for BarChartData
  BarChartData(this.year, this.sales, this.color);
}

///class LinearSales
class LinearSales implements ChartData {
  final String year;
  final int sales;

  final Color color;

  ///constructor for LinearSales
  LinearSales(this.year, this.sales, this.color);
}
