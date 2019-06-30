import 'package:flutter/material.dart';

/// default font style
final TextStyle defaultTextStyle = TextStyle(
  fontSize: 20,
  color: Colors.white,
);

final TextStyle titleTextStyle = TextStyle(
  fontSize: 22,
  color: highlightColor,
);

/// green font style
final TextStyle greenTextStyle = TextStyle(
  fontSize: 20,
  color: Colors.green[400],
);

/// red font style
final TextStyle redTextStyle = TextStyle(
  fontSize: 20,
  color: Colors.red[400],
);

/// grey font style
final TextStyle greyTextStyle = TextStyle(
  fontSize: 20,
  color: backgroundColor
);

/// hightlighted font style
final TextStyle highlightTextStyle = TextStyle(
  color: highlightColor
);

/// font style for settings page
final TextStyle settingsStyle = TextStyle(
  color: Colors.white,
  fontWeight: FontWeight.bold
);

/// scheibner background color
final Color backgroundColor = Color.fromRGBO(58, 66, 86, 1.0);

/// scheibner red
final Color highlightColor = Color.fromRGBO(216, 7, 42, 1);

///scheiber second background
final Color cardBackgroundColor = Color.fromRGBO(64, 75, 96, .9);