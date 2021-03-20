import 'package:flutter/material.dart';
import 'package:freeletics_running/pages/freeletics/circle_painter.dart';
import 'package:freeletics_running/pages/freeletics/time_count.dart';
import 'package:intl/intl.dart';

class Monitor extends StatelessWidget {
  final int totalDistance;
  final int runDistance;
  final double runSpace;


  Monitor({this.runDistance, this.totalDistance, this.runSpace=0});

  String toFormatDateTime(double second) {
    DateTime dateTime = (DateTime.fromMicrosecondsSinceEpoch((second*1000000).round()));


    return DateFormat('mm:ss').format(dateTime);
  }

  @override
  Widget build(BuildContext context) {
    double currentProgress = (runDistance / totalDistance) * 100;
    if (currentProgress >= 100) currentProgress = 100;
    return Container(
      height: 260,
      color: Color.fromRGBO(41, 36, 45, 1),
      child: Column(
        children: [
          _buildAppbar(),
          SizedBox(
              height: 150,
              width: 150,
              child: Stack(
                children: [
                  Positioned.fill(
                    child: CustomPaint(
                      painter: CirclePainter(currentProgress: currentProgress),
                    ),
                  ),
                  Center(
                    child: Text(
                      runDistance >= totalDistance
                          ? totalDistance.toString()
                          : runDistance.toInt().toString(),
                      style: TextStyle(
                          fontSize: 30,
                          color: Colors.white,
                          fontWeight: FontWeight.bold),
                    ),
                  )
                ],
              )),
          _buildFooter()
        ],
      ),
    );
  }

  Widget _buildAppbar() {
    return Container(
      height: 50,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Container(
            width: 100,
            alignment: Alignment.topLeft,
            child: IconButton(
                icon: Icon(
                  Icons.close,
                  color: Colors.white,
                ),
                iconSize: 25,
                onPressed: () {}),
          ),
          Text(
            totalDistance.toString() + ' M',
            style: TextStyle(
                fontSize: 20, color: Colors.white, fontWeight: FontWeight.bold),
          ),
          Container(
            width: 100,
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                IconButton(
                    icon: Icon(
                      Icons.settings,
                      color: Colors.white,
                    ),
                    iconSize: 25,
                    onPressed: () {}),
                IconButton(
                    icon: Icon(
                      Icons.lock_open_rounded,
                      color: Colors.white,
                    ),
                    iconSize: 25,
                    onPressed: () {}),
              ],
            ),
          )
        ],
      ),
    );
  }

  Widget _buildFooter() {
    return Container(
      padding: EdgeInsets.only(bottom: 20, top: 10),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        children: [
          Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              Icon(
                Icons.access_time,
                color: Colors.white,
                size: 18,
              ),
              SizedBox(
                width: 5,
              ),
              Text(
                toFormatDateTime(runSpace),
                style: TextStyle(fontSize: 18, color: Colors.white),
              ),
            ],
          ),
          TimeCount(complete: runDistance>=totalDistance,)
        ],
      ),
    );
  }
}
