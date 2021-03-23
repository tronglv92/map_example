import 'dart:math' show cos, sqrt, asin;

import 'package:geolocator/geolocator.dart';
class Helper{
  static double calculateDistance(lat1, lon1, lat2, lon2) {
    var p = 0.017453292519943295;
    var c = cos;
    var a = 0.5 -
        c((lat2 - lat1) * p) / 2 +
        c(lat1 * p) * c(lat2 * p) * (1 - c((lon2 - lon1) * p)) / 2;
    var distance= 12742 * asin(sqrt(a));
    return distance*1000;
  }
  static double spaceBetween(int distance, Position from,Position to)
  {
    print("distance "+distance.toString());
    print("to.timestamp.difference(from.timestamp).inSeconds "+to.timestamp.difference(from.timestamp).inSeconds.toString());
    double timeDif=(to.timestamp.difference(from.timestamp).inMilliseconds).toDouble();
    double pace = timeDif/distance;

    return pace;
  }

}