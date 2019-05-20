import 'package:flutter/widgets.dart';
import 'package:scheibner_app/commonWidgets/charts/chartData.dart';
import 'package:scheibner_app/commonWidgets/charts/simpleBarChart.dart';
import 'package:charts_flutter/flutter.dart' as charts;

class ChartView extends StatelessWidget {

  ChartData c1 = new ChartData(SimpleBarChart.createSampleData(), "simpleBarChart", true);
  ChartData c2 = new ChartData(SimpleBarChart.createSampleData(), "simpleBarChart", true);
  ChartData c3 = new ChartData(SimpleBarChart.createSampleData(), "simpleBarChart", true);
  ChartDataRow x = new ChartDataRow();
  x.addChartData(c1);

  List<ChartDataRow> listItems = [c1, c2, c3];
  @override
  Widget build(BuildContext context) {
    return new ListView.builder(
        itemCount: listItems.length,
        itemBuilder: (BuildContext ctxt, int index) => buildCharts(ctxt, index)
        // ListView(
        //   padding: const EdgeInsets.all(8.0),
        //   children: <Widget>[
        //     new Row(
        //       children: <Widget>[
        //         Container(
        //             width: (size.width - 16) / 2,
        //             height: height,
        //             child: SimpleBarChart.withSampleData()),
        //         Container(
        //             width: (size.width - 16) / 2,
        //             height: height,
        //             child: SimpleBarChart.withSampleData()),
        //       ],
        //     ),
        //   ],
        );
  }

  Widget buildCharts(BuildContext ctxt, int index) {
    ChartDataRow row = listItems[index];
    var size = MediaQuery.of(ctxt).size;

    /*24 is for notification bar on Android*/
    final double height = (size.height - 104 - 24 - 16);
    final double width = size.width - 16;

    List<Widget> wList;
    //Jedes ChartData in Widget umwandeln
    for (ChartData chartData in row.chartList) {
      Widget widget;
      switch (chartData.chartType) {
        case "simpleBarChart":
          {
            widget = SimpleBarChart.withSampleData();
            break;
          }
      }

      wList.add(
        new Container(
            width: width / row.length(), height: height / 2, child: widget),
      );
    }

    return new Row(children: wList);
  }
}
