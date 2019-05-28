import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:scheibner_app/commonWidgets/charts/chartData.dart';
import 'package:scheibner_app/commonWidgets/charts/chartInitializer.dart';
import 'package:charts_flutter/flutter.dart' as charts;
import 'package:scheibner_app/data/appmodel.dart';
import 'package:scoped_model/scoped_model.dart';

class ChartView extends StatelessWidget {
  List<ChartRow> listItems = new List<ChartRow>();
  List<String> legendItems = new List<String>();
  double legendwidth = 150;
  double chartpadding = 10;

  @override
  Widget build(BuildContext context) {
    return new ScopedModelDescendant<AppModel>(
      //LayoutBuilder needed for constraints
      builder: (context, child, model) {
        ChartInitializer init = new ChartInitializer(
            model.getMeasurementData(), model.getSimulationData());
        return new LayoutBuilder(
          builder: (BuildContext context, BoxConstraints constraints) {
            listItems = init.getResultChartViewData();
            legendItems = ["Lenkkopfwinkel =", "gabellänge l"];
            // ListViewBuilder
            return new Stack(
              children: [
                new Container(
                  width: constraints.maxWidth,
                  height: constraints.maxHeight,
                  child: new ListView.builder(
                    itemCount: listItems.length,
                    itemBuilder: (BuildContext ctxt, int index) {
                      return buildCharts(ctxt, index, constraints);
                    },
                  ),
                ),
                // Positioned(
                //   bottom: 0,
                //   left: 0,
                //   child: new Container(
                //     width: legendwidth,
                //     height: 100,
                //     color: Colors.grey,
                //     child: new ListView.builder(
                //       itemCount: legendItems.length,
                //       itemBuilder: (BuildContext ctxt, int index) {
                //         return buildLegend(ctxt, index, constraints);
                //       },
                //     ),
                //   ),
                // ),
              ],
            );
          },
        );
      },
    );

    // ,
    // Positioned(
    //   bottom: 20,
    //   left: 20,
    //   child: Container(height: 20, width: 10, color: Colors.blue),
    // ),
    //   ],
    // )
    ;
  }

  Widget buildLegend(BuildContext ctxt, int index, BoxConstraints constraints) {
    return new Row(
      children: <Widget>[
        Padding(
            padding: EdgeInsets.only(
              left: 10,
              top: 0,
              right: 10,
              bottom: 0,
            ),
            child: Container(
              width: 10,
              height: 10,
              color: Colors.amber,
            )),
        new Text(
          legendItems[index],
          style: new TextStyle(fontSize: 12.0),
        )
      ],
    );

    //  return new Text(legendItems[index]);
  }

  Widget buildCharts(BuildContext ctxt, int index, BoxConstraints constraints) {
    ChartRow row = listItems[index];
    var size = MediaQuery.of(ctxt).size;

    /*24 is for notification bar on Android*/
    // final double height = (size.height - 104 - 24 - 16);
    // final double width = size.width - 16;
    final double height = constraints.maxHeight - 2 * chartpadding;
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

        case ChartType.horizonalBarChart:
          widget = new charts.BarChart(
            chart.data.cast<charts.Series<ChartData, String>>(),
            animate: chart.animate,
            behaviors: chart.barChartBehaviors,
            vertical: false, // Set a bar label decorator.
            // Example configuring different styles for inside/outside:
            //       barRendererDecorator: new charts.BarLabelDecorator(
            //          insideLabelStyleSpec: new charts.TextStyleSpec(...),
            //          outsideLabelStyleSpec: new charts.TextStyleSpec(...)),
            barRendererDecorator: new charts.BarLabelDecorator<String>(),
            // Hide domain axis.
            domainAxis: new charts.OrdinalAxisSpec(
                renderSpec: new charts.NoneRenderSpec()),
          );

          break; //Bitte kein Default einfuegen!
      }

      wList.add(
        Padding(
          padding: EdgeInsets.only(
            left: chartpadding,
            top: chartpadding,
            right: 0,
            bottom: chartpadding,
          ),
          child: new Container(
              width: width / row.charts.length - chartpadding *row.charts.length,
              height: height / 2,
              child: widget),
        ),
      );
    }

    return new Row(children: wList);
  }
}
