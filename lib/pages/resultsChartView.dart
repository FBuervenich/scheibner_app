import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:scheibner_app/commonWidgets/charts/chartInitializer.dart';
import 'package:scheibner_app/data/appmodel.dart';
import 'package:scoped_model/scoped_model.dart';

class ChartView extends StatelessWidget {
  List<RowFunction> listItems = new List<RowFunction>();

  List<String> legendItems = new List<String>();
  double legendwidth = 150;

  @override
  Widget build(BuildContext context) {
    //close Keyboard if available
    FocusScope.of(context).requestFocus(new FocusNode());
    return new ScopedModelDescendant<AppModel>(
      //LayoutBuilder needed for constraints
      builder: (context, child, model) {
        ChartInitializer init = new ChartInitializer(
          model.getMeasurementData(),
          model.getSimulationData(),
          context,
        );
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
          ),
        ),
        new Text(
          legendItems[index],
          style: new TextStyle(fontSize: 12.0),
        )
      ],
    );

    //  return new Text(legendItems[index]);
  }

  Widget buildCharts(BuildContext ctxt, int index, BoxConstraints constraints) {
    return listItems[index](constraints, ctxt);
  }
}
