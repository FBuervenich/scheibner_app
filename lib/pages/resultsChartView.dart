import 'package:flutter/widgets.dart';
import 'package:scheibner_app/commonWidgets/charts/chartData.dart';
import 'package:scheibner_app/commonWidgets/charts/chartInitializer.dart';
import 'package:charts_flutter/flutter.dart' as charts;
import 'package:scheibner_app/data/appmodel.dart';
import 'package:scoped_model/scoped_model.dart';

class ChartView extends StatelessWidget {
  List<ChartRow> listItems = new List<ChartRow>();

  @override
  Widget build(BuildContext context) {

    return new ScopedModelDescendant<AppModel>(
      //LayoutBuilder needed for constraints
      builder: (context, child, model) => new LayoutBuilder(
            builder: (BuildContext context, BoxConstraints constraints) {
              // ListViewBuilder
              return new ListView.builder(
                itemCount: listItems.length,
                itemBuilder: (BuildContext ctxt, int index) {
                  listItems = ChartInitializer.getResultChartViewData(model);
                  return buildCharts(ctxt, index, constraints);
                },
              );
            },
          ),
    );
  }

  Widget buildCharts(BuildContext ctxt, int index, BoxConstraints constraints) {
    ChartRow row = listItems[index];
    var size = MediaQuery.of(ctxt).size;

    /*24 is for notification bar on Android*/
    // final double height = (size.height - 104 - 24 - 16);
    // final double width = size.width - 16;
    final double height = constraints.maxHeight;
    final double width = constraints.maxWidth;

    if (row.isWidget()) {
      return new Row(children: [row.widget]);
    }

    List<Widget> wList = [];
    //Jedes ChartData in Widget umwandeln
    for (Chart chart in row.charts) {
      Widget widget;

      switch (chart.chartType) {
        case ChartType.simpleBarChart:
          widget = new charts.BarChart(
            chart.data.cast<charts.Series<ChartData, String>>(),
            animate: chart.animate,
            behaviors: chart.barChartBehaviors,
          );
          break;

        case ChartType.pieChart:
          widget = new charts.PieChart(
            chart.data.cast<charts.Series<ChartData, String>>(),
            animate: chart.animate,
            behaviors: chart.barChartBehaviors,
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
            defaultRenderer: new charts.ArcRendererConfig(
                arcWidth: 50,
                arcRendererDecorators: [
                  new charts.ArcLabelDecorator(
                      // labelPosition: charts.ArcLabelPosition.outside,
                      // showLeaderLines: true
                      )
                ]),
          );
          break;
        //Bitte kein Default einfuegen!
      }

      wList.add(
        new Container(
            width: width / row.charts.length,
            height: height / 2,
            child: widget),
      );
    }

    return new Row(children: wList);
  }
}
