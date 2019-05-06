import 'package:flutter/material.dart';
import 'package:scheibner_app/Localizations.dart';

class metadataPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Container(
      child: Center(
        //TODO add metadataPage
        child: Text(DemoLocalizations.of(context).getValue("title2"))
      ),
    );
  }
}