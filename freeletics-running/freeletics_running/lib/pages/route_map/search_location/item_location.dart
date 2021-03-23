import 'package:flutter/material.dart';
import 'package:freeletics_running/models/distance_matrix.dart';


class ItemLocation extends StatelessWidget {
  ItemLocation({this.address, this.distanceMatrix,this.onPressItem});

  final String address;
  final DistanceMatrix distanceMatrix;
  final Function onPressItem;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onPressItem,
      child: Padding(
        padding: const EdgeInsets.only(top: 15, left: 10),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Container(
              width: 40,
              child: Column(
                children: [
                  Container(
                    height: 30,
                    width: 30,
                    decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(15),
                        color: Color.fromRGBO(229, 231, 233, 1.0)),
                    child: Center(
                      child: Icon(
                        Icons.access_time,
                        size: 20,
                        color: Colors.black,
                      ),
                    ),
                  ),
                  SizedBox(
                    height: 4,
                  ),
                  Text(
                    distanceMatrix != null ? distanceMatrix.distance.text : '',
                    style: TextStyle(fontSize: 12, color: Colors.grey),
                    textAlign: TextAlign.center,
                  ),
                ],
              ),
            ),
            SizedBox(
              width: 18,
            ),
            Expanded(
                child: Column(
              mainAxisAlignment: MainAxisAlignment.start,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  address,
                  style: TextStyle(fontSize: 14, color: Colors.black),
                ),

                SizedBox(
                  height: 10,
                ),
                Divider(
                  height: 1,
                  color: Colors.grey,
                )
              ],
            ))
          ],
        ),
      ),
    );
  }
}
