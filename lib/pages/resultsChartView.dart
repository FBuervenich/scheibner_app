import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:ScheibnerSim/commonWidgets/charts/chartInitializer.dart';
import 'package:ScheibnerSim/data/appmodel.dart';
import 'package:scoped_model/scoped_model.dart';

///class ChartView
class ChartView extends StatelessWidget {
  List<RowFunction> listItems = new List<RowFunction>();

  List<String> legendItems = new List<String>();
  double legendwidth = 150;

  ///build for ChartView
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
            // ListViewBuilder
            return 
                new Container(
                  width: constraints.maxWidth,
                  height: constraints.maxHeight,
                  child: new ListView.builder(
                    physics: new BouncingScrollPhysics(),
                    itemCount: listItems.length,
                    itemBuilder: (BuildContext ctxt, int index) {
                      return buildCharts(ctxt, index, constraints);
                    },
                  ),
              
            );
          },
        );
      },
    );
  }


  ///builds a chart at a given [index]
  Widget buildCharts(BuildContext ctxt, int index, BoxConstraints constraints) {
    return listItems[index](constraints, ctxt);
  }
}
