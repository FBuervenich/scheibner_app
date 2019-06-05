import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:scheibner_app/commonWidgets/charts/chartData.dart';
import 'package:charts_flutter/flutter.dart' as charts;
import 'package:flutter/widgets.dart';
import 'package:scheibner_app/commonWidgets/charts/chartInitializer.dart'
    as prefix0;
import 'package:scheibner_app/localization/app_translations.dart';

import '../../styles.dart';
import 'chartInitializer.dart';

class ChartFactory {
  static const double chartpadding = 10;
  static const double cardpadding = 8;

  static const double paddingDiff = 2 * chartpadding + cardpadding;

  static const double wertAnzeigeWidth = 150;

  static Widget createPercentDiffChart(
      List<BarChartData> data, BoxConstraints constraints, BuildContext ctx) {
    List<double> range = [];
    range.addAll(data.map<double>((a) => a.sales));
    range.sort();
    range.add(range[range.length - 1] *
        -1); //Maximale positive Zahl negieren und hinzufuegen
    range.add(range[0] * -1); //Maximale negative Zahl negieren und hinzufuegen

    final simpleCurrencyFormatter =
        new charts.BasicNumericTickFormatterSpec.fromNumberFormat(
      new NumberFormat.compact(),
    );

    return getRow(
      constraints,
      ctx,
      widgets: [
        new charts.BarChart(
          [
            new charts.Series<BarChartData, String>(
              id: 'Sales',
              colorFn: (BarChartData sales, __) {
                if (sales.sales < 0) {
                  return charts.ColorUtil.fromDartColor(Colors.red);
                } else {
                  return charts.ColorUtil.fromDartColor(Colors.green);
                }
              },
              domainFn: (BarChartData sales, _) => sales.year.substring(0, 3),
              measureFn: (BarChartData sales, _) => sales.sales,
              data: data,
              labelAccessorFn: (BarChartData sales, _) {
                if (sales.sales < 0) {
                  return '${sales.year}: ${sales.sales.toString()}%';
                } else {
                  return '${sales.year}: ${sales.sales.toString()}%';
                }
              },
              overlaySeries: true,
              insideLabelStyleAccessorFn: (BarChartData sales, _) =>
                  new charts.TextStyleSpec(fontSize: 8),
              outsideLabelStyleAccessorFn: (BarChartData sales, _) =>
                  new charts.TextStyleSpec(fontSize: 12),
            )
          ],
          animate: true,
          behaviors: [
            new charts.ChartTitle(
                AppTranslations.of(ctx)
                    .text("chartFactory_createPercentDiffChart"),
                // subTitle: '',
                behaviorPosition: charts.BehaviorPosition.top,
                titleOutsideJustification: charts.OutsideJustification.start,
                innerPadding: 18,
                titleStyleSpec: new charts.TextStyleSpec(fontSize: 17)),
          ],
          vertical: false,
          barRendererDecorator: new charts.BarLabelDecorator<String>(),
          // Hide domain axis.
          domainAxis: new charts.OrdinalAxisSpec(
              renderSpec: new charts.NoneRenderSpec()),
          primaryMeasureAxis: new charts.NumericAxisSpec(
            viewport: new charts.NumericExtents.fromValues(range),
            tickFormatterSpec: simpleCurrencyFormatter,
          ),
        ),
      ],
    );
  }

  static Widget newOldBarChart(
    MeasChartValue kennzahl,
    BoxConstraints constraints,
    BuildContext ctx, {
    Color oldcolor,
    Color newcolor,
  }) {
    List<BarChartData> data = [
      new BarChartData("alt", kennzahl.measValue, oldcolor),
      new BarChartData("neu", kennzahl.simValue, newcolor),
    ];

    return ChartFactory.getRow(
      constraints,
      ctx,
      widgets: [
        new Column(
          children: [
            new Row(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                //Wertanzeige
                new Column(
                  children: <Widget>[
                    new Row(
                      children: <Widget>[
                        new Container(
                          width: wertAnzeigeWidth,
                          child: new Text(
                            kennzahl.localization,
                            style: new TextStyle(
                              fontWeight: FontWeight.bold,
                              fontSize: 16,
                            ),
                          ),
                        ),
                      ],
                    ),
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
                ),
                // BarChart New Old
                new Column(
                  children: [
                    new Container(
                      width:
                          constraints.maxWidth - wertAnzeigeWidth - paddingDiff,
                      height: constraints.maxHeight - 245, // wegen Column
                      child: new charts.BarChart(
                        [
                          new charts.Series<BarChartData, String>(
                              id: 'Sales',
                              colorFn: (BarChartData sales, __) =>
                                  charts.ColorUtil.fromDartColor(sales.color),
                              domainFn: (BarChartData sales, _) =>
                                  sales.year.substring(0, 3),
                              measureFn: (BarChartData sales, _) => sales.sales,
                              data: data,
                              labelAccessorFn: (BarChartData sales, _) =>
                                  '${sales.year}: \$${sales.sales.toString()}')
                        ],
                        animate: true,
                        behaviors: [
                          new charts.ChartTitle(kennzahl.localization,
                              // subTitle: '',
                              behaviorPosition: charts.BehaviorPosition.top,
                              titleOutsideJustification:
                                  charts.OutsideJustification.start,
                              innerPadding: 18,
                              titleStyleSpec:
                                  new charts.TextStyleSpec(fontSize: 15)),
                        ],
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ],
        ),
      ],
    );
  }

  static Widget _getNewOldChartPercentValueWidget(
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
                  style: new TextStyle(
                    fontSize: 10,
                  ),
                )
              ],
            ),
          ),
        ],
      ),
    );
  }

  static Widget _getNewOldChartValueWidget(
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
                  style: new TextStyle(
                    fontSize: 25,
                  ),
                ),
                new Text(
                  isNew
                      ? AppTranslations.of(context)
                          .text("chatFactory_newOldBarChart_newValue")
                      : AppTranslations.of(context)
                          .text("chatFactory_newOldBarChart_oldValue"),
                  style: new TextStyle(
                    fontSize: 10,
                  ),
                )
              ],
            ),
          ),
        ],
      ),
    );
  }

  static Widget getRow(
    BoxConstraints constraints,
    BuildContext ctxt, {
    @required List<Widget> widgets,
  }) {
    final double height = constraints.maxHeight - 2 * chartpadding;
    final double width = constraints.maxWidth;

    List<Widget> cardList = [];
    //Jedes Chart in Mit Padding umwickeln
    for (Widget widget in widgets) {
      cardList.add(
        new Card(
          color: cardBackgroundColor,
          child: Padding(
            padding: EdgeInsets.only(
              left: chartpadding,
              top: chartpadding,
              right: chartpadding,
              bottom: chartpadding,
            ),
            child: new Row(
              children: [
                new Container(
                  width: width / widgets.length - paddingDiff,
                  height: height / 2,
                  child: widget,
                ),
              ],
            ),
          ),
        ),
      );
    }
    return new Row(children: cardList);
  }
}
