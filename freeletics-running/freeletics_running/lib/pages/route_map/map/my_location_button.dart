import 'package:flutter/material.dart';
class MyLocationButton extends StatelessWidget {
  final Function onPress;
  MyLocationButton({this.onPress});
  @override
  Widget build(BuildContext context) {
    return  Positioned(
      right: 10,
      bottom: 10,
      child: ClipOval(
        child: Material(
          color: Colors.orange[100], // button color
          child: InkWell(
            splashColor: Colors.orange, // inkwell color
            child: SizedBox(
              width: 56,
              height: 56,
              child: Icon(Icons.my_location),
            ),
            onTap: onPress,
          ),
        ),
      ),
    );
  }
}
