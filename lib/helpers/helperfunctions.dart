class Helper {
  static const EPS = 5e-2;

  static String valToString(double d) {
    return d != null
        ? d.toStringAsFixed(1)
        : "Null";
  }

  static String createDifferenceText(double a, double b) {
    if (a == null || b == null) {
      return "Null";
    }
    String text = "";
    if ((a - b).abs() < EPS) {
      return "0.0";
    } else {
      if (a > b) {
        text += "+";
      }
      text += (a - b).toStringAsFixed(1);
    }
    return text;
  }
}
