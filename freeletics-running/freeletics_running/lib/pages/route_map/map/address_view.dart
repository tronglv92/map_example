import 'package:flutter/material.dart';
import 'package:freeletics_running/models/map_location.dart';
import 'package:freeletics_running/models/place_location.dart';
import 'package:freeletics_running/pages/route_map/map/text_address.dart';

class AddressView extends StatelessWidget {
  AddressView(
      {this.onPressStartPoint,
      this.onPressEndPoint,
      this.startPoint,
      this.endPoint,
      this.onPressShowRoute,
      this.distance,
      this.onPressClose});

  final Function onPressStartPoint;
  final Function onPressEndPoint;
  final MapLocation startPoint;
  final MapLocation endPoint;
  final double distance;
  final Function onPressShowRoute;
  final Function onPressClose;

  @override
  Widget build(BuildContext context) {
    final width = MediaQuery.of(context).size.width;
    return SafeArea(
      child: Align(
        alignment: Alignment.topCenter,
        child: Padding(
          padding: const EdgeInsets.only(top: 10.0),
          child: Container(
            decoration: BoxDecoration(
              color: Colors.white70,
              borderRadius: BorderRadius.all(
                Radius.circular(20.0),
              ),
            ),
            width: width * 0.9,
            child: Padding(
              padding: const EdgeInsets.only(top: 10.0, bottom: 10.0),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: <Widget>[
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      GestureDetector(
                        onTap: onPressClose,
                        child: Container(
                            width: 100,
                            child: Icon(
                              Icons.close,
                              size: 30,
                              color: Colors.black,
                            )),
                      ),
                      Text(
                        'Places',
                        style: TextStyle(fontSize: 20.0),
                      ),
                      Container(width: 100)
                    ],
                  ),
                  SizedBox(height: 10),
                  TextAddress(
                    onPress: onPressStartPoint,
                    location: startPoint,
                    placeHolder: "Start point",
                  ),
                  SizedBox(height: 10),
                  TextAddress(
                    onPress: onPressEndPoint,
                    location: endPoint,
                    placeHolder: "End point",
                  ),
                  SizedBox(height: 10),
                  SizedBox(
                    width: 150,
                    child: ElevatedButton(
                      onPressed: onPressShowRoute,
                      style: ElevatedButton.styleFrom(
                          primary: Colors.red,
                          shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(18))),
                      child: Center(
                        child: Text(
                          "SHOW ROUTE",
                          style: TextStyle(fontSize: 14, color: Colors.white),
                        ),
                      ),
                    ),
                  ),
                  Visibility(
                    visible: true,
                    child: Text(
                      'DISTANCE:' + (distance / 1000).toStringAsFixed(2) + 'km',
                      style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                  SizedBox(height: 5),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
