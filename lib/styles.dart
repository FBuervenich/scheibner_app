import 'package:flutter/material.dart';

final TextStyle defaultTextStyle = TextStyle(
  fontSize: 20,
  color: Colors.white,
);

final TextStyle greenTextStyle = TextStyle(
  fontSize: 20,
  color: Colors.green[400],
);
final TextStyle redTextStyle = TextStyle(
  fontSize: 20,
  color: Colors.red[400],
);

final TextStyle greyTextStyle = TextStyle(
  fontSize: 20,
  color: backgroundColor
);

final TextStyle highlightTextStyle = TextStyle(
  color: highlightColor
);

final TextStyle settingsStyle = TextStyle(
  color: Colors.white,
  fontWeight: FontWeight.bold
);


final Color backgroundColor = Color.fromRGBO(58, 66, 86, 1.0);
// final Color backgroundColor = Colors.grey[200];
final Color highlightColor = Color.fromRGBO(216, 7, 42, 1);


final Color cardBackgroundColor = Color.fromRGBO(64, 75, 96, .9);