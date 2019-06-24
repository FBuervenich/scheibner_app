import 'package:ScheibnerSim/data/data.dart';
import 'package:ScheibnerSim/data/profile.dart';
import 'package:scoped_model/scoped_model.dart';

///class AppModel
class AppModel extends Model {
  Profile _profile;

  AppModel();

  ///returns the measurement data
  Data getMeasurementData() {
    if (_profile.meas == null) {
      return null;
    }
    return Data.clone(_profile.meas);
  }

///sets simulation data for a given data [d]
  void setMeasurementData(Data d) {
    _profile.meas = d;
    notifyListeners();
  }

  ///gets simulation data
  Data getSimulationData() {
    if (_profile.sim == null) {
      return null;
    }
    return Data.clone(_profile.sim);
  }

  ///gets measurement value for given [name]
  double getMeasValue(String name) {
    return _profile.meas.getValue(name);
  }

  ///gets simulation value for given [name]
  double getSimValue(String name) {
    return _profile.sim.getValue(name);
  }

  ///sets the simulation value for given [name] to [value]
  void setSimValue(String name, double value) {
    _profile.sim.setValue(name, value);
    notifyListeners();
  }

  ///sets the simulation data to [d]
  void setSimulationData(Data d) {
    _profile.sim = d;
    notifyListeners();
  }

  ///simulates results
  void simulate() {
    _profile.sim.simulate();
  }

  ///returns the current profile
  Profile getProfile() {
    return _profile;
  }

  ///sets current profile to [profile]
  void setProfile(Profile profile) {
    _profile = profile;
    notifyListeners();
  }

  ///sets measurement id to [measId]
  void setMeasurementId(int measId) {
    _profile?.serverId = measId;
    notifyListeners();
  }

  ///sets comment to [comment]
  void setComment(String comment) {
    _profile?.comment = comment;
    notifyListeners();
  }
}
