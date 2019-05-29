import 'data.dart';

class Profile {
  int id;
  String name;
  DateTime lastChanged;
  // measurement data
  Data meas;
  // simulation data
  List<Data> sim;
}
