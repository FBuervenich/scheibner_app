import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:scheibner_app/commonWidgets/charts/chartData.dart';
import 'package:scheibner_app/commonWidgets/charts/chartFactory.dart';
import 'package:scheibner_app/commonWidgets/charts/chartInitializer.dart';

import 'package:charts_flutter/flutter.dart' as charts;
import 'package:scheibner_app/localization/app_translations.dart';

class SingleMeasChangeChart extends ChartFactory {
  SingleMeasChangeChart(BoxConstraints constraints, BuildContext ctx)
      : super(constraints, ctx);

  double wertAnzeigeWidth = 112;
  List<BarChartData> data;
  MeasChartValue kennzahl;

/**
 * Returns the View of a SingleMeasChangeChart. This includes
 * a left side containing the total numbers and a right side
 * containing a BarChart diagramm
 */
  Widget getView(
    MeasChartValue kennzahl, {
    Color oldcolor,
    Color newcolor,
  }) {
    this.kennzahl = kennzahl;
    data = [
      new BarChartData(
        AppTranslations.of(ctx).text("old"),
        kennzahl.measValue,
        oldcolor,
      ),
      new BarChartData(
        AppTranslations.of(ctx).text("new"),
        kennzahl.simValue,
        newcolor,
      ),
    ];

    return getRow(
      constraints,
      ctx,
      heading: getHeading(kennzahl.localization),
      widgets: [
        new Row(
          // mainAxisAlignment: MainAxisAlignment.center,
          // crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            _getLeftSide(),
            // BarChart New Old
            _getRightSide(),
          ],
        ),
      ],
    );
  }

/**
 * Returns a column containing the Values of old and new Data
 */
  Widget _getLeftSide() {
    return new Column(
      children: <Widget>[
        _getNewOldChartValueWidget(
          ctx,
          data[0].sales.toStringAsFixed(2),
          false,
        ),
        _getNewOldChartValueWidget(
          ctx,
          data[1].sales.toStringAsFixed(2),
          true,
        ),
        _getNewOldChartPercentValueWidget(
          ctx,
          kennzahl.getPercentageDiff(),
        )
      ],
    );
  }

  Widget _getNewOldChartPercentValueWidget(
      BuildContext context, double percentage) {
    return new Expanded(
      child: new Row(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: <Widget>[
          new Container(
            child: new Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Align(
                  alignment: Alignment.center,
                  child: new Text(
                    percentage.toStringAsFixed(2) + "%",
                    textAlign: TextAlign.center,
                    style: new TextStyle(
                      fontSize: 16,
                      color: percentage < 0 ? Colors.red : Colors.green,
                    ),
                  ),
                ),
                new Text(
                  AppTranslations.of(context).text("differenzInPercent"),
                  style: new TextStyle(fontSize: 10, color: Colors.white),
                )
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _getNewOldChartValueWidget(
      BuildContext context, String value, bool isNew) {
    return new Expanded(
      flex: 2,
      child: new Row(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: <Widget>[
          new Container(
            child: new Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                new Text(
                  value,
                  style: new TextStyle(fontSize: 25, color: Colors.white),
                ),
                new Text(
                  isNew
                      ? AppTranslations.of(context)
                          .text("chatFactory_newOldBarChart_newValue")
                      : AppTranslations.of(context)
                          .text("chatFactory_newOldBarChart_oldValue"),
                  style: new TextStyle(fontSize: 10, color: Colors.white),
                )
              ],
            ),
          ),
        ],
      ),
    );
  }

  /**
 * Returns a Column containing the Barchart
 */
  Widget _getRightSide() {
    return new Column(
      // mainAxisAlignment: MainAxisAlignment.end,
      // crossAxisAlignment: CrossAxisAlignment.end,
      children: [
        new Padding(
          padding: EdgeInsets.only(
            left: 30,
            top: 20,
          ),
          child: new Container(
            width:
                constraints.maxWidth - wertAnzeigeWidth - getPaddingDiff() - 30,
            height: constraints.maxHeight - 275 - headingHeight, // wegen Column
            child: new charts.BarChart(
              [
                new charts.Series<BarChartData, String>(
                    id: 'Sales',
                    colorFn: (BarChartData sales, __) =>
                        charts.ColorUtil.fromDartColor(sales.color),
                    domainFn: (BarChartData sales, _) =>
                        sales.year,
                    measureFn: (BarChartData sales, _) => sales.sales,
                    data: data,
                    labelAccessorFn: (BarChartData sales, _) =>
                        '${sales.year}: \$${sales.sales.toString()}')
              ],
              animate: true,
              behaviors: [
                // new charts.ChartTitle(kennzahl.localization,
                //     // subTitle: '',
                //     behaviorPosition: charts.BehaviorPosition.top,
                //     titleOutsideJustification: charts.OutsideJustification.start,
                //     innerPadding: 18,
                //     titleStyleSpec: new charts.TextStyleSpec(
                //         fontSize: 15, color: charts.Color.white)),
              ],
              domainAxis: new charts.OrdinalAxisSpec(
                  renderSpec: new charts.SmallTickRendererSpec(

                      // Tick and Label styling here.
                      labelStyle: new charts.TextStyleSpec(
                          fontSize: 13, // size in Pts.
                          color: charts.MaterialPalette.white),

                      // Change the line colors to match text color.
                      lineStyle: new charts.LineStyleSpec(
                          color: charts.MaterialPalette.white))),

              /// Assign a custom style for the measure axis.
              primaryMeasureAxis: new charts.NumericAxisSpec(
                  renderSpec: new charts.GridlineRendererSpec(

                      // Tick and Label styling here.
                      labelStyle: new charts.TextStyleSpec(
                          fontSize: 18, // size in Pts.
                          color: charts.MaterialPalette.white),

                      // Change the line colors to match text color.
                      lineStyle: new charts.LineStyleSpec(
                          color: charts.MaterialPalette.white))),
            ),
          ),
        ),
      ],
    );
  }
}
