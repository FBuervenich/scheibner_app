import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';

class MenuButton extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return new IconButton(
      icon: Icon(Icons.menu),
      onPressed: () {
        //TODO add menu actions
      },
    );
  }
}
