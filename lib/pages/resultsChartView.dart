import 'package:flutter/widgets.dart';
import 'package:scheibner_app/commonWidgets/charts/simpleBarChart.dart';
import 'package:charts_flutter/flutter.dart' as charts;

class ChartView extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    var size = MediaQuery.of(context).size;
    /*24 is for notification bar on Android*/
    final double itemHeight = (size.height - 100 - 24) / 2;
    final double itemWidth = size.width / 2;

    return Container(
      child: Center(
        child: ListView(
          padding: const EdgeInsets.all(8.0),
          children: <Widget>[
            Table(
              defaultColumnWidth: FlexColumnWidth(1.0),
              children: [
                TableRow(children: [
                  new Container(child: new SimpleBarChart.withSampleData()),
                  new Container(child: new SimpleBarChart.withSampleData()),
                ])
              ],
            )
          ],
        ),
      ),
    );
  }
}
