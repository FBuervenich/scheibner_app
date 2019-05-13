import 'package:scoped_model/scoped_model.dart';

class AppModel extends Model {
  double _frontwheel = 42;

  double getFrontwheel() {
    return _frontwheel;
  }
  
  void setFrontwheel(double d) {
    _frontwheel = d;
    notifyListeners();
  }
}