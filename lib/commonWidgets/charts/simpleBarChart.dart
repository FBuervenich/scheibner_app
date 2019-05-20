import 'package:charts_flutter/flutter.dart' as charts;
import 'package:flutter/material.dart';
import 'package:scheibner_app/data/data.dart';

class SimpleBarChart extends StatelessWidget {
  final List<charts.Series> seriesList;
  final bool animate;

  SimpleBarChart(this.seriesList, {this.animate});

  /// Creates a [BarChart] with sample data and no transition.
  factory SimpleBarChart.withSampleData() {
    return new SimpleBarChart(
      createSampleData(),
      // Disable animations for image tests.
      animate: false,
    );
  }

  @override
  Widget build(BuildContext context) {
    return 
      new charts.BarChart(
        seriesList,
        animate: animate,
      );
    
  }

  /// Create one series with sample hard coded data.
  static List<charts.Series<BarChartData, String>> createSampleData() {
    final data = [
      new BarChartData('2014', 5),
      new BarChartData('2015', 25),
      new BarChartData('2016', 100),
      new BarChartData('2017', 75),
    ];

    return [
      new charts.Series<BarChartData, String>(
        id: 'Sales',
        colorFn: (_, __) => charts.MaterialPalette.blue.shadeDefault,
        domainFn: (BarChartData sales, _) => sales.year,
        measureFn: (BarChartData sales, _) => sales.sales,
        data: data,
      )
    ];
  }
}

/// Sample ordinal data type.
class BarChartData {
  final String year;
  final int sales;

  BarChartData(this.year, this.sales);
}
