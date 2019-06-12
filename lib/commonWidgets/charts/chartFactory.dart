import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';

import '../../styles.dart';

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

  double getHeight() {
    return constraints.maxHeight - 2 * chartpadding;
  }

  Widget getRow(
    BoxConstraints constraints,
    BuildContext ctxt, {
    @required List<Widget> widgets,
    Widget heading,
    double additionalPadding = 0,
  }) {
    final double height = getHeight();
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
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  new Container(child: heading),
                  new Container(
                    width: width / widgets.length -
                        getPaddingDiff() -
                        additionalPadding,
                    height: height / 2 - headingHeight,
                    child: widget,
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
