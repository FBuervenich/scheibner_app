import 'package:flutter/material.dart';
import 'package:ScheibnerSim/localization/app_translations.dart';

class ThreePointWidget extends StatefulWidget {
  CustomPopupMenu createState() => CustomPopupMenu();
}

class CustomPopupMenu extends State<ThreePointWidget> {
  CustomPopupMenu({this.title, this.icon, this.selectedChoice});

  String title;
  IconData icon;
  int selectedChoice;

  void _select(CustomPopupMenu choice) {
    setState(() {
      if (choice.selectedChoice == 1) {
        Navigator.popUntil(context, ModalRoute.withName(Navigator.defaultRouteName));
      }
      if (choice.selectedChoice == 2) {
        Navigator.pushNamed(context, '/preferences');
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    List<CustomPopupMenu> choices = <CustomPopupMenu>[
      CustomPopupMenu(
          title: AppTranslations.of(context).text("profileTitle"),
          icon: Icons.account_circle,
          selectedChoice: 1),
      CustomPopupMenu(
          title: AppTranslations.of(context).text("preferences"),
          icon: Icons.settings,
          selectedChoice: 2),
    ];

    return new PopupMenuButton<CustomPopupMenu>(
      elevation: 3.2,
      onCanceled: () {
        // nothing needed here
      },
      onSelected: _select,
      itemBuilder: (BuildContext context) {
        return choices.map((CustomPopupMenu choice) {
          return PopupMenuItem<CustomPopupMenu>(
            value: choice,
            child: Text(choice.title),
          );
        }).toList();
      },
    );
  }
}

class SelectedOption extends StatelessWidget {
  CustomPopupMenu choice;

  SelectedOption({Key key, this.choice}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      child: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            Icon(choice.icon, size: 140.0, color: Colors.white),
            Text(
              choice.title,
              style: TextStyle(color: Colors.white, fontSize: 30),
            )
          ],
        ),
      ),
    );
  }
}
