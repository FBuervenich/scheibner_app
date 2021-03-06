import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:ScheibnerSim/commonWidgets/charts/chartData.dart';
import 'package:ScheibnerSim/commonWidgets/charts/simOverviewChart.dart';
import 'package:ScheibnerSim/commonWidgets/charts/singleMeasChangeChart.dart';
import 'package:ScheibnerSim/data/data.dart';
import 'package:ScheibnerSim/localization/app_translations.dart';

import '../../styles.dart';

typedef Widget RowFunction(BoxConstraints, BuildContext);

///class ChartInitializer
class ChartInitializer {
  Data meas;
  Data sim;
  List<Color> defaultColors = [
    Colors.red,
    Colors.amber,
    Colors.yellow,
    Colors.green,
    Colors.cyan,
    Colors.blue,
    Colors.indigo,
    Colors.purple,
    Colors.purple,
    Colors.purple,
    Colors.purple,
    Colors.purple,
    Colors.purple,
    Colors.purple,
    Colors.purple,
    Colors.pink
  ];
  Map<String, MeasChartValue> values = new Map();

  ///constructor for ChartInitializer
  ChartInitializer(this.meas, this.sim, context) {
    int i = 0;

    Data.chartable.forEach((valInfo) {
      String key = valInfo.name;
      values[key] = new MeasChartValue(
        key,
        meas.getValue(key),
        sim.getValue(key),
        color: defaultColors[i],
        localization: AppTranslations.of(context).text(key),
        unit: valInfo.unit

      );
      i++;
    });
  }

  ///gets the max diffs
  List<MeasChartValue> _getMaxDiffs(double count) {
    List<MeasChartValue> ret = values.values.toList();
    //Nach groeße Sortieren
    ret.sort((m1, m2) {
      if (m1.getDiff().abs() < m2.getDiff().abs()) {
        return 1;
      }
      if (m1.getDiff().abs() > m2.getDiff().abs()) {
        return -1;
      }
      return 0;
    });
    return ret.sublist(0, count.toInt());
  }

  ///gets all result diagrams
  List<RowFunction> getResultChartViewData() {
    List<RowFunction> ret = new List();

    //PercentDiff
    List<BarChartData> data = [];
    _getMaxDiffs(4).forEach((MeasChartValue meas) {
      if (meas.getPercentageDiff().abs() > 0) {
        data.add(
          new BarChartData(
              meas.localization, meas.getPercentageDiff(), meas.color),
        );
      }
    });

    ret.add(
      (constraints, ctx) =>
          new SimOverviewChart(constraints, ctx).createView(data),
    );

    List<MeasChartValue> maxDiff = _getMaxDiffs(4);

    //Je 2 Charts in eine Row
    for (int i = 0; i < maxDiff.length; i++) {
      ret.add(
        (constraints, ctx) => SingleMeasChangeChart(constraints, ctx).getView(
              maxDiff[i],
              oldcolor: Colors.grey,
              // defaultColors[i], kennzahl.color
              newcolor: maxDiff[i].getDiff()>0? Colors.lightGreen: highlightColor,
            ),
      );
    }
    //Biggest Changes in Solo Diagramm

    return ret;
  }
}

///class MeasChartValue
class MeasChartValue {
  String key;
  String localization;
  String shortcut;
  String unit;
  Color color;
  double measValue;
  double simValue;

  ///constructor for MeasChartValue
  MeasChartValue(this.key, this.measValue, this.simValue,
      {this.color: Colors.blue, this.shortcut, @required this.localization, @required this.unit}) {
    if (this.measValue == null) {
      this.measValue = 0;
    }
    if (this.simValue == null) {
      this.simValue = 0;
    }
  }

  ///returns the diff
  double getDiff() {
    return simValue - measValue;
  }

  ///returns the diff in percent
  double getPercentageDiff() {
    if (measValue == 0) {
      return 0;
    }
    return _round(getDiff() / measValue * 100);
  }

  ///round a given double [x] to two digits after the comma
  double _round(double x) {
    return (x * 100).round() / 100.0;
  }
}
