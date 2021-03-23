import 'package:flutter/material.dart';
import 'package:freeletics_running/pages/freeletics/freeletics_running_page.dart';
import 'package:freeletics_running/pages/route_map/map/map_page.dart';

class MenuPage extends StatefulWidget {
  @override
  _MenuPageState createState() => _MenuPageState();
}

class _MenuPageState extends State<MenuPage> {
  void onPressedFreeleticsRun() {
    Navigator.of(context)
        .push(MaterialPageRoute(builder: (context) => FreeleticsRunningPage()));
  }

  void onPressShowRouteMap() {
    Navigator.of(context)
        .push(MaterialPageRoute(builder: (context) => MapPage()));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          'Menu',
          style: TextStyle(color: Colors.white),
        ),
      ),
      body: Container(
        width: MediaQuery.of(context).size.width,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          mainAxisSize: MainAxisSize.max,
          children: [
            ElevatedButton(
              onPressed: onPressedFreeleticsRun,
              child: Text(
                "Show Freeletics run",
                style: TextStyle(fontSize: 14, color: Colors.white),
              ),
              style: ElevatedButton.styleFrom(
                  primary: Colors.red,
                  shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(14))),
            ),
            SizedBox(
              height: 10,
            ),
            ElevatedButton(
              onPressed: onPressShowRouteMap,
              child: Text(
                "Show route map",
                style: TextStyle(fontSize: 14, color: Colors.white),
              ),
              style: ElevatedButton.styleFrom(
                  primary: Colors.blue,
                  shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(14))),
            ),
          ],
        ),
      ),
    );
  }
}
