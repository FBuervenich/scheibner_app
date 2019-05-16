import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';

class BackButton extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return new IconButton(
      icon: Icon(Icons.arrow_back),
      onPressed: () {
        Navigator.pop(context);
      },
    );
  }
}
