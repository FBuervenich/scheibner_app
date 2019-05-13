import 'package:scheibner_app/helpers/Measurement.dart';
import 'package:scoped_model/scoped_model.dart';

class AppModel extends Model {
  Measurement _meas = new Measurement();

  double getFrontwheel() {
    return _meas.frontwheel;
  }
  
  void setFrontwheel(double d) {
    _meas.frontwheel = d;
    notifyListeners();
  }

  double getRearwheel() {
    return _meas.rearwheel;
  }

  void setRearwheel(double d) {
    _meas.rearwheel = d;
    notifyListeners();
  }

  double getFrontfork() {
    return _meas.frontfork;
  }

  void setFrontfork(double d) {
    _meas.frontfork = d;
    notifyListeners();
  }

  double getRearheight() {
    return _meas.rearheight;
  }

  void setRearheight(double d) {
    _meas.rearheight = d;
    notifyListeners();
  }

  double getSwingarmlength() {
    return _meas.swingarmlength;
  }

  void setSwingarmlength(double d) {
    _meas.swingarmlength = d;
    notifyListeners();
  }
}