import 'package:flutter/material.dart';

class ThreePointWidget extends StatefulWidget {
  CustomPopupMenu createState() => CustomPopupMenu();
}

List<CustomPopupMenu> choices = <CustomPopupMenu>[
  CustomPopupMenu(title: 'Profile page', icon: Icons.account_circle),
  CustomPopupMenu(title: 'Settings', icon: Icons.settings),
];

class CustomPopupMenu extends State<ThreePointWidget> {
  CustomPopupMenu({this.title, this.icon});

  String title;
  IconData icon;

  CustomPopupMenu _selectedChoices = choices[0];
  void _select(CustomPopupMenu choice) {
    setState(() {
      _selectedChoices = choice;
    });
  }

  @override
  Widget build(BuildContext context) {
    return new PopupMenuButton<CustomPopupMenu>(
      elevation: 3.2,
      initialValue: choices[1],
      onCanceled: () {
        print('You have not chossed anything');
      },
      tooltip: 'This is tooltip',
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
