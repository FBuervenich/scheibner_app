import 'package:flutter/widgets.dart';
import 'package:scheibner_app/commonWidgets/charts/chartData.dart';
import 'package:scheibner_app/commonWidgets/charts/pieChart.dart';
import 'package:scheibner_app/commonWidgets/charts/simpleBarChart.dart';
import 'package:charts_flutter/flutter.dart' as charts;

class ChartView extends StatelessWidget {
  List<ChartViewRow> listItems = new List();

  @override
  Widget build(BuildContext context) {
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

    Chart c2 = PieChart.getExampleChart();

    listItems.add(new ChartViewRow([c1, c2]));
    listItems.add(new ChartViewRow([c2]));

    return new ListView.builder(
        itemCount: listItems.length,
        itemBuilder: (BuildContext ctxt, int index) => buildCharts(ctxt, index)
      
        );
  }

  Widget buildCharts(BuildContext ctxt, int index) {
    ChartViewRow row = listItems[index];
    var size = MediaQuery.of(ctxt).size;

    /*24 is for notification bar on Android*/
    final double height = (size.height - 104 - 24 - 16);
    final double width = size.width - 16;

    List<Widget> wList = [];
    //Jedes ChartData in Widget umwandeln
    for (Chart chart in row.chartList) {
      Widget widget;

      switch (chart.chartType) {
        case ChartType.simpleBarChart:
          widget = new SimpleBarChart(
            chart.data.cast<charts.Series<ChartData, String>>(),
            animate: chart.animate,
            behaviors: chart.barChartBehaviors,
          );
          break;

        case ChartType.pieChart:
          widget = new PieChart(
            chart.data.cast<charts.Series<ChartData, String>>(),
            animate: chart.animate,
            behaviors: chart.barChartBehaviors,
          );
          break;
          //Bitte kein Default einfuegen!
      }

      wList.add(
        new Container(
            width: width / row.chartList.length,
            height: height / 2,
            child: widget),
      );
    }

    return new Row(children: wList);
  }
}
