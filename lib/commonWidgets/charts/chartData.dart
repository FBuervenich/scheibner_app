import 'package:charts_flutter/flutter.dart' as charts;

class ChartData {
  List<charts.Series> seriesList;
  String chartType;
  bool animate;

  ChartData(this.seriesList,this.chartType, this.animate);
}

class ChartDataRow {
  List<ChartData> chartList =new List();

  ChartDataRow(){
    this.chartList =new List();
  }

  int addChartData(ChartData d) {
    if (chartList.length < 2) {
      chartList.add(d);
    }
  }

  int length() {
    return chartList.length;
  }
}
