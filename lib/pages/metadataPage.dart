import 'package:flutter/material.dart';
import 'package:scheibner_app/Localizations.dart';

class metadataPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Container(
      child: Center(
        //TODO add metadataPage
        child: Text(ScheibnerLocalizations.of(context).getValue("title2"))
      ),
    );
  }
}