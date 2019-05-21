/// Simple pie chart with outside labels example.
import 'package:charts_flutter/flutter.dart' as charts;
import 'package:scheibner_app/commonWidgets/charts/chartData.dart';
import 'package:flutter/material.dart';

class PieChart extends StatelessWidget {
  final List<charts.Series> seriesList;
  final bool animate;
  final List<charts.ChartTitle> behaviors;

  PieChart(this.seriesList, {this.animate, this.behaviors});

  /// Creates a [PieChart] with sample data and no transition.
  factory PieChart.withSampleData() {
    return new PieChart(
      _createSampleData(),
      // Disable animations for image tests.
      animate: false,
    );
  }

  @override
  Widget build(BuildContext context) {
    return new charts.PieChart(seriesList,
        animate: animate,
        behaviors: behaviors,
        // Add an [ArcLabelDecorator] configured to render labels outside of the
        // arc with a leader line.
        //
        // Text style for inside / outside can be controlled independently by
        // setting [insideLabelStyleSpec] and [outsideLabelStyleSpec].
        //
        // Example configuring different styles for inside/outside:
        //       new charts.ArcLabelDecorator(
        //          insideLabelStyleSpec: new charts.TextStyleSpec(...),
        //          outsideLabelStyleSpec: new charts.TextStyleSpec(...)),
        defaultRenderer:
            new charts.ArcRendererConfig(arcWidth: 50, arcRendererDecorators: [
          new charts.ArcLabelDecorator(
              // labelPosition: charts.ArcLabelPosition.outside,
              // showLeaderLines: true
              )
        ]));
  }

  static Chart getExampleChart() {
    final data = [
      new LinearSales("Lenkkopfwinkel", 100),
      new LinearSales("1", 75),
      new LinearSales("2", 25),
      new LinearSales("3", 5),
    ];

    return new Chart(
      ChartType.pieChart,
      data: [
        new charts.Series<LinearSales, String>(
          id: 'Sales',
          domainFn: (LinearSales sales, _) => sales.year,
          measureFn: (LinearSales sales, _) => sales.sales,
          data: data,
          // Set a label accessor to control the text of the arc label.
          labelAccessorFn: (LinearSales row, _) => '${row.year}: ${row.sales}',
        )
      ],
      animate: true,
    );
  }

  /// Create one series with sample hard coded data.
  static List<charts.Series<LinearSales, String>> _createSampleData() {
    final data = [
      new LinearSales("", 100),
      new LinearSales("1", 75),
      new LinearSales("2", 25),
      new LinearSales("3", 5),
    ];

    return [
      new charts.Series<LinearSales, String>(
        id: 'Sales',
        domainFn: (LinearSales sales, _) => sales.year,
        measureFn: (LinearSales sales, _) => sales.sales,
        data: data,
        // Set a label accessor to control the text of the arc label.
        labelAccessorFn: (LinearSales row, _) => '${row.year}: ${row.sales}',
      )
    ];
  }
}

/// Sample linear data type.
class LinearSales implements ChartData {
  final String year;
  final int sales;

  LinearSales(this.year, this.sales);
}
