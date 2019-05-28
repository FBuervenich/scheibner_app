import 'package:scheibner_app/data/data.dart';
import 'package:scheibner_app/data/profile.dart';
import 'package:scoped_model/scoped_model.dart';

class AppModel extends Model {
  Profile _profile = new Profile(); //TODO for testing

  AppModel() {
    _profile.sim = new List<Data>();
  }

  Data getMeasurementData() {
    if (_profile.meas == null) {
      return null;
    }
    return Data.clone(_profile.meas);
  }

  void setMeasurementData(Data d) {
    _profile.meas = d;
    notifyListeners();
  }

  Data getSimulationData() {
    if (_profile.sim == null) {
      return null;
    }
    return Data.clone(_profile.sim[0]);
  }

  double getMeasValue(String name) {
    return _profile.meas.getValue(name);
  }

  double getSimValue(String name) {
    return _profile.sim[0].getValue(name);
  }

  void setSimValue(String name, double value) {
    _profile.sim[0].setValue(name, value);
    notifyListeners();
  }

  void setSimulationData(Data d) {
    _profile.sim = new List<Data>();
    _profile.sim.add(d);
    notifyListeners();
  }

  void simulate() {
    _profile.sim[0].simulate();
  }

  Profile getProfile() {
    return _profile;
  }

  void setProfile(Profile profile) {
    _profile = profile;
    notifyListeners();
  }
}
