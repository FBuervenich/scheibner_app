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
  double chartpadding = 10;
  double cardpadding = 8;
  final double headingHeight = 19;

  BoxConstraints constraints;
  BuildContext ctx;

  ChartFactory(this.constraints, this.ctx);

  double getPaddingDiff() {
    return 2 * chartpadding + cardpadding;
  }

  Widget getRow(
    BoxConstraints constraints,
    BuildContext ctxt, {
    @required List<Widget> widgets,
    Widget heading,
    double additionalPadding = 0,
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
            child: Container(
              height: height / 2,
              width: width / widgets.length - getPaddingDiff(),
              child: Column(
                children: [
                  new Row( mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      new Container(child: heading),
                    ],
                  ),
                  new Row(
                    children: [
                      new Container(
                        width: width / widgets.length -
                            getPaddingDiff() -
                            additionalPadding,
                        height: height / 2 - headingHeight,
                        child: widget,
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ),
        ),
      );
    }
    return new Row(children: cardList);
  }

  /**
   * Returns the Text-Widget including the String heading
   */
  Widget getHeading(String heading) {
    return new Text(heading,
        style: new TextStyle(
          fontWeight: FontWeight.bold,
          fontSize: 16,
          color: Colors.white,
        ));
  }
}
