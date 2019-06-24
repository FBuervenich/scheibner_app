import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:intl/intl.dart';
import 'package:ScheibnerSim/commonWidgets/charts/chartData.dart';
import 'package:ScheibnerSim/commonWidgets/charts/chartFactory.dart';

import 'package:charts_flutter/flutter.dart' as charts;
import 'package:ScheibnerSim/localization/app_translations.dart';

///class SimOverviewChart
class SimOverviewChart extends ChartFactory {
  SimOverviewChart(constraints, ctx) : super(constraints, ctx);

  ///creates the view with all charts
  Widget createView(List<BarChartData> data) {
    List<double> range = _getRange(data);

    return getRow(
      constraints,
      ctx,
      additionalPadding: 20,
      heading: getHeading(
        AppTranslations.of(ctx).text("chartFactory_createPercentDiffChart"),
      ),
      widgets: [
        new charts.BarChart(
          [
            _getChartSeries(data),
          ],

          barGroupingType: charts.BarGroupingType.grouped,
          animate: true,
          behaviors: [
            // _getTitle(),
          ],
          vertical: false,
          barRendererDecorator: new charts.BarLabelDecorator<String>(
            labelPosition: charts.BarLabelPosition.outside,
          ),

          // Hide domain axis.
          domainAxis: new charts.OrdinalAxisSpec(
            renderSpec: new charts.NoneRenderSpec(),
          ),

          primaryMeasureAxis: _getXaxisOptions(range),
        ),
      ],
    );
  }

  /// Calculates the Range of the diagramm. The biggest absolute value 
  ///will be set into the range once positive and once negative.
  List<double> _getRange(List<BarChartData> data) {
    List<double> range = [];
    range.addAll(data.map<double>((a) => a.sales));
    range.sort();
    range.add(range[range.length - 1] *
        -1); //Maximale positive Zahl negieren und hinzufuegen
    range.add(range[0] * -1); //Maximale negative Zahl negieren und hinzufuegen
    return range;
  }

  ///Returns the ChartSeries for the Diagramm
  charts.Series<BarChartData, String> _getChartSeries(List<BarChartData> data) {
    return new charts.Series<BarChartData, String>(
      data: data,
      id: 'HorizontalBarchart',
      colorFn: (BarChartData sales, __) {
        if (sales.sales < 0) {
          return charts.ColorUtil.fromDartColor(Colors.red);
        } else {
          return charts.ColorUtil.fromDartColor(Colors.green);
        }
      },
      domainFn: (BarChartData sales, _) => sales.year,
      measureFn: (BarChartData sales, _) => sales.sales,

      labelAccessorFn: (BarChartData sales, _) {
        return '${sales.year}: ${sales.sales.toString()}%';
      },
      // overlaySeries: true,
      insideLabelStyleAccessorFn: (BarChartData sales, _) =>
          new charts.TextStyleSpec(fontSize: 10, color: charts.Color.white),
      outsideLabelStyleAccessorFn: (BarChartData sales, _) =>
          new charts.TextStyleSpec(fontSize: 12, color: charts.Color.white),
    );
  }

  ///Returns the ChartTitle-Object
  charts.ChartTitle _getTitle() {
    return new charts.ChartTitle(
      AppTranslations.of(ctx).text("chartFactory_createPercentDiffChart"),
      // subTitle: '',
      behaviorPosition: charts.BehaviorPosition.top,
      titleOutsideJustification: charts.OutsideJustification.start,
      innerPadding: 18,
      titleStyleSpec:
          new charts.TextStyleSpec(fontSize: 17, color: charts.Color.white),
    );
  }

  ///Sets the X-Axis, its Fontsize and color and its viewport
  charts.NumericAxisSpec _getXaxisOptions(List<double> range) {
    final simpleCurrencyFormatter =
        new charts.BasicNumericTickFormatterSpec.fromNumberFormat(
      new NumberFormat.compact(),
    );

    /// Assign a custom style for the measure axis.
    return new charts.NumericAxisSpec(
      renderSpec: new charts.GridlineRendererSpec(
        // Tick and Label styling here.
        labelStyle: new charts.TextStyleSpec(
            fontSize: 18, // size in Pts.
            color: charts.MaterialPalette.white),

        // Change the line colors to match text color.
        lineStyle:
            new charts.LineStyleSpec(color: charts.MaterialPalette.white),
      ),
      viewport: new charts.NumericExtents.fromValues(range),
      tickFormatterSpec: simpleCurrencyFormatter,
    );
  }
}
