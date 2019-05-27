import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';

class FramedButton extends StatelessWidget {
  final String text;
  final void Function() onPressed;

  const FramedButton({Key key, this.text, this.onPressed}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return new RaisedButton(
      padding: EdgeInsets.symmetric(horizontal: 15, vertical: 10),
      color: Colors.white,
      child: new Text(
        text,
        style: new TextStyle(fontSize: 20, color: Colors.amber[600]),
      ),
      shape: new RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(5),
        side: BorderSide(
          width: 1.5,
          color: Colors.amber[600],
        ),
      ),
      onPressed: onPressed,
    );
  }
}
