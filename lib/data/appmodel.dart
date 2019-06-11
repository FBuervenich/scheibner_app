import 'package:scheibner_app/data/data.dart';
import 'package:scheibner_app/data/profile.dart';
import 'package:scoped_model/scoped_model.dart';

class AppModel extends Model {
  Profile _profile;

  AppModel();

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
    return Data.clone(_profile.sim);
  }

  double getMeasValue(String name) {
    return _profile.meas.getValue(name);
  }

  double getSimValue(String name) {
    return _profile.sim.getValue(name);
  }

  void setSimValue(String name, double value) {
    _profile.sim.setValue(name, value);
    notifyListeners();
  }

  void setSimulationData(Data d) {
    _profile.sim = d;
    notifyListeners();
  }

  void simulate() {
    _profile.sim.simulate();
  }

  Profile getProfile() {
    return _profile;
  }

  void setProfile(Profile profile) {
    _profile = profile;
    notifyListeners();
  }

  void setMeasurementId(int measId) {
    _profile?.serverId = measId;
    notifyListeners();
  }

  void setComment(String comment) {
    _profile?.comment = comment;
    notifyListeners();
  }
}
