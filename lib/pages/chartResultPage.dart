import 'package:flutter/material.dart';

class ChartResultPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    var size = MediaQuery.of(context).size;
    /*24 is for notification bar on Android*/
    final double itemHeight = (size.height - kToolbarHeight - 70 - 24) / 2;
    final double itemWidth = size.width / 2;

    return Container(
      child: Center(
        child: ListView(
          padding: const EdgeInsets.all(8.0),
          children: <Widget>[
            GridView.count(
              primary: false,
              shrinkWrap: true,
              padding: const EdgeInsets.all(8.0),
              childAspectRatio: (itemWidth / itemHeight),
              crossAxisSpacing: 10.0,
              crossAxisCount: 2,
              children: <Widget>[
                const Text('He\'d have you all unravel at the'),
                const Text('Heed not the rabble'),
              ],
            ),
            GridView.count(
              primary: false,
              shrinkWrap: true,
              padding: const EdgeInsets.all(8.0),
              childAspectRatio: (itemWidth / itemHeight),
              crossAxisSpacing: 10.0,
              crossAxisCount: 2,
              children: <Widget>[
                const Text('He\'d have you all unravel at the'),
                const Text('Heed not the rabble'),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
