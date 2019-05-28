import 'package:flutter/widgets.dart';
import 'package:scheibner_app/commonWidgets/charts/chartData.dart';
import 'package:charts_flutter/flutter.dart' as charts;
import 'package:scheibner_app/data/appmodel.dart';
import 'package:scheibner_app/data/data.dart';
import 'package:scoped_model/scoped_model.dart';

class ChartInitializer {

  static List<ChartRow> getResultChartViewData(AppModel model){

    Data meas = model.getMeasurementData();
    Data sim = model.getSimulationData();

    return getExampleCharts();
  }
  static List<ChartRow> getExampleCharts() {
    //BarChart
    final data = [
      new BarChartData('2014', 5),
      new BarChartData('2015', 25),
      new BarChartData('2016', 100),
      new BarChartData('2017', 75),
    ];

    Chart c1 = new Chart(
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
        new charts.ChartTitle(
          'Veränderung des Lenkkopfwinkels',
          // subTitle: '',
          behaviorPosition: charts.BehaviorPosition.top,
          titleOutsideJustification: charts.OutsideJustification.start,
          innerPadding: 18,
          // titleStyleSpec: new charts.TextStyleSpec(fontSize: 14)
        ),
      ],
    );

    Chart c2 = Chart.getExamplePieChart();

    List<ChartRow> listItems = new List<ChartRow>();
    listItems.add(new ChartRow([c1, c2]));
    listItems.add(new ChartRow([c2]));
    return listItems;
  }
}
