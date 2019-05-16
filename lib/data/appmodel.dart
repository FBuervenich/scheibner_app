import 'package:scheibner_app/algorithm/simulation.dart';
import 'package:scheibner_app/data/data.dart';
import 'package:scoped_model/scoped_model.dart';

class AppModel extends Model {
  Data _meas = new Simulation().calcAdditionalData(Data()); //TODO for testing
  Data _sim;

  Data getMeasurementData() {
    return Data.clone(_meas);
  }

  void setMeasurementData(Data d) {
    _meas = d;
    notifyListeners();
  }

  Data getSimulationData() {
    return Data.clone(_sim);
  }

  void setSimulationData(Data d) {
    _sim = d;
    notifyListeners();
  }
}
