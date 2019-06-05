import 'dart:collection';

import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:scheibner_app/commonWidgets/charts/chartData.dart';
import 'package:scheibner_app/commonWidgets/charts/chartFactory.dart';
import 'package:scheibner_app/data/data.dart';
import 'package:scheibner_app/localization/app_translations.dart';

import '../../styles.dart';

typedef Widget RowFunction(BoxConstraints, BuildContext);

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

  ChartInitializer(this.meas, this.sim, context) {
    int i = 0;

    Data.chartable.forEach((key) {
      values[key] = new MeasChartValue(
        key,
        meas.getValue(key),
        sim.getValue(key),
        color: defaultColors[i],
        localization: AppTranslations.of(context).text(key),
      );
      i++;
    });
  }

  List<MeasChartValue> _getMaxDiffs(double count) {
    List<MeasChartValue> ret = values.values.toList();
    //Nach groeße Sortieren
    ret.sort((m1, m2) {
      if (m1.getPercentageDiff() > m2.getPercentageDiff()) {
        return 1;
      }
      if (m1.getPercentageDiff() < m2.getPercentageDiff()) {
        return -1;
      }
      return 0;
    });
    return ret.sublist(0, count.toInt());
  }

  List<RowFunction> getResultChartViewData() {
    List<RowFunction> ret = new List();

    //PercentDiff
    List<BarChartData> data = [];
    _getMaxDiffs(6).forEach((MeasChartValue meas) {
      data.add(
        new BarChartData(
            meas.localization, meas.getPercentageDiff(), meas.color),
      );
    });

    ret.add(
      (constraints, ctx) =>
          ChartFactory.createPercentDiffChart(data, constraints, ctx),
    );

    List<MeasChartValue> maxDiff = _getMaxDiffs(4);

    //Je 2 Charts in eine Row
    for (int i = 0; i < maxDiff.length; i++) {
      ret.add(
        (constraints, ctx) => ChartFactory.newOldBarChart(
              maxDiff[i],
              constraints,
              ctx,
              oldcolor: backgroundColor,
              // defaultColors[i], kennzahl.color
              newcolor: highlightColor,
            ),
      );
    }
    //Biggest Changes in Solo Diagramm

    return ret;
  }
}

class MeasChartValue {
  String key;
  String localization;
  String shortcut;
  Color color;
  double measValue;
  double simValue;

  MeasChartValue(this.key, this.measValue, this.simValue,
      {this.color: Colors.blue, this.shortcut, @required this.localization}) {
    if (this.measValue == null) {
      this.measValue = 0;
    }
    if (this.simValue == null) {
      this.simValue = 0;
    }
  }

  double getDiff() {
    return simValue - measValue;
  }

  double getPercentageDiff() {
    if (measValue == 0) {
      return 0;
    }
    return _round(getDiff() / measValue * 100);
  }

  double _round(double x) {
    return (x * 100).round() / 100.0;
  }
}
