import 'package:charts_flutter/flutter.dart' as charts;
import 'package:flutter/widgets.dart';



class Chart {
  List<charts.Series<ChartData, String>> data;
  ChartType chartType;
  bool animate;
  List<charts.ChartTitle> barChartBehaviors;
  List<charts.ChartBehavior> pieChartBehaviors;

  Chart(this.chartType,
      {@required this.data,
      this.animate,
      this.barChartBehaviors,
      this.pieChartBehaviors});

  static Chart getExampleBarChart() {
    final data = [
      new BarChartData('2014', 5),
      new BarChartData('2015', 25),
      new BarChartData('2016', 100),
      new BarChartData('2017', 75),
    ];

    return new Chart(
      ChartType.simpleBarChart,
      data: [
        new charts.Series<BarChartData, String>(
          id: 'Sales',
          colorFn: (_, __) => charts.MaterialPalette.blue.shadeDefault,
          domainFn: (BarChartData sales, _) => sales.year,
          measureFn: (BarChartData sales, _) => sales.sales,
          data: data,
        )
      ],
      animate: true,
      barChartBehaviors: [
        new charts.ChartTitle('Top title text',
            subTitle: 'Top sub-title text',
            behaviorPosition: charts.BehaviorPosition.top,
            titleOutsideJustification: charts.OutsideJustification.start,
            // titleStyleSpec: new charts.TextStyleSpec(fontSize: 14)
            // Set a larger inner padding than the default (10) to avoid
            // rendering the text too close to the top measure axis tick label.
            // The top tick label may extend upwards into the top margin region
            // if it is located at the top of the draw area.
            innerPadding: 18),
        new charts.ChartTitle('Bottom title text',
            behaviorPosition: charts.BehaviorPosition.bottom,
            titleOutsideJustification:
                charts.OutsideJustification.middleDrawArea),
        new charts.ChartTitle('Start title',
            behaviorPosition: charts.BehaviorPosition.start,
            titleOutsideJustification:
                charts.OutsideJustification.middleDrawArea),
        new charts.ChartTitle('End title',
            behaviorPosition: charts.BehaviorPosition.end,
            titleOutsideJustification:
                charts.OutsideJustification.middleDrawArea),
      ],
    );
  }

  static Chart getExamplePieChart() {
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
}

class ChartRow {
  List<Chart> charts;
  Widget widget;

  ChartRow(this.charts);
  ChartRow.byWidget(this.widget);

  bool isWidget() {
    return widget == null;
  }
}

//Chart Data, its types and its implementations
abstract class ChartData {}

enum ChartType { simpleBarChart, pieChart }

class BarChartData implements ChartData {
  final String year;
  final int sales;
  BarChartData(this.year, this.sales);
}

class LinearSales implements ChartData {
  final String year;
  final int sales;

  LinearSales(this.year, this.sales);
}
