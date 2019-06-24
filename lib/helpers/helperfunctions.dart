import 'package:flutter/cupertino.dart';
import 'package:ScheibnerSim/data/appmodel.dart';
import 'package:ScheibnerSim/styles.dart';
import 'package:scoped_model/scoped_model.dart';

///class Helper
class Helper {
  static const EPS = 5e-2;

  ///converts a given double [d] to a string 
  static String valToString(double d) {
    if(d == null){
      return "Null";
    }
    if(d.abs() < EPS){
      return "0.0";
    }
    return d.toStringAsFixed(1);
  }

  ///creates a Text that indicated the difference between two doubles [a] and [b]
  static Text createDifferenceText(double a, double b) {
    assert(a != null && b != null);
    String text = "";
    TextStyle style = defaultTextStyle;
    if ((a - b).abs() < EPS) {
      text = "0.0";
    } else {
      if (a > b) {
        text += "+";
        style = greenTextStyle;
      } else {
        style = redTextStyle;
      }
      text += (a - b).toStringAsFixed(1);
    }
    return new Text(text, style: style);
  }

  ///returns the name of the current profile
  static String getCurrentProfileName(BuildContext context) {
    return ScopedModel.of<AppModel>(context).getProfile().name;
  }
}
