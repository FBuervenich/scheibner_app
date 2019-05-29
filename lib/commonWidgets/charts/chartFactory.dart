import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:scheibner_app/commonWidgets/charts/chartData.dart';
import 'package:charts_flutter/flutter.dart' as charts;
import 'package:flutter/widgets.dart';
import 'package:scheibner_app/commonWidgets/charts/chartInitializer.dart'
    as prefix0;
import 'package:scheibner_app/localization/app_translations.dart';

import 'chartInitializer.dart';

class ChartFactory {
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

  static Widget newOldBarChart(MeasChartValue kennzahl, Color oldcolor,
      BoxConstraints constraints, BuildContext ctx) {
    List<BarChartData> data = [
      new BarChartData("alt", kennzahl.measValue, oldcolor),
      new BarChartData("neu", kennzahl.simValue, kennzahl.color),
    ];
    return ChartFactory.getRow(
      constraints,
      ctx,
      widgets: [
        //Wertanzeige
        new Column(
          children: <Widget>[
            new Row(
              children: <Widget>[
                new Container(
                  child: new Text(kennzahl.localization),
                ),
              ],
            ),
            new Row(
              children: <Widget>[
                new Container(
                  child: new Text(data[0].sales.toString()),
                ),
              ],
            )
          ],
        ),
        // BarChart New Old
        new charts.BarChart(
          [
            new charts.Series<BarChartData, String>(
                id: 'Sales',
                colorFn: (BarChartData sales, __) =>
                    charts.ColorUtil.fromDartColor(sales.color),
                domainFn: (BarChartData sales, _) => sales.year.substring(0, 3),
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
                titleOutsideJustification: charts.OutsideJustification.start,
                innerPadding: 18,
                titleStyleSpec: new charts.TextStyleSpec(fontSize: 15)),
          ],
        ),
      ],
    );
  }

  static Widget getRow(
    BoxConstraints constraints,
    BuildContext ctxt, {
    @required List<Widget> widgets,
  }) {
    double chartpadding = 10;

    final double height = constraints.maxHeight - 2 * chartpadding;
    final double width = constraints.maxWidth;

    List<Widget> cardList = [];
    //Jedes Chart in Mit Padding umwickeln
    for (Widget widget in widgets) {
      cardList.add(
        new Card(
          child: Padding(
            padding: EdgeInsets.only(
              left: chartpadding,
              top: chartpadding,
              right: chartpadding,
              bottom: chartpadding,
            ),
            child: new Container(
              width: width / widgets.length - chartpadding * 2 - 8,
              height: height / 2,
              child: widget,
            ),
          ),
        ),
      );
    }
    return new Row(children: cardList);
  }
}
