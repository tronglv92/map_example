import 'package:flutter/material.dart';
import 'package:freeletics_running/models/map_location.dart';
import 'package:freeletics_running/models/place_location.dart';
class TextAddress extends StatelessWidget {
  TextAddress({this.onPress,this.location,this.placeHolder});
  final Function onPress;
  final MapLocation location;
  final String placeHolder;

  @override
  Widget build(BuildContext context) {
    final double width=MediaQuery.of(context).size.width;
    return GestureDetector(
      onTap: onPress,
      child: Container(
        height: 50,
        width: width * 0.8,
        padding: EdgeInsets.symmetric(horizontal: 10),
        decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(10),
            color: Colors.white,
            border: Border.all(width: 1, color: Colors.black54)),
        child: Row(
          children: [
            Icon(Icons.looks_one),
            SizedBox(
              width: 15,
            ),
            Expanded(
                child: Text(
                    location != null
                        ? location.formattedAddress
                        :placeHolder,
                    style: TextStyle(
                        fontSize: 16,
                        color: location != null
                            ? Colors.black
                            : Colors.grey),
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis
                )),
            SizedBox(
              width: 15,
            ),
          ],
        ),
      ),
    );
  }
}
