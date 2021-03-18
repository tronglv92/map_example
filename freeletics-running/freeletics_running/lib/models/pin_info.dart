import 'dart:ui';

import 'package:google_maps_flutter/google_maps_flutter.dart';

class PinInfo{
  String pinPath;
  String avatarPath;
  LatLng location;
  String locationName;
  Color labelColor;
  PinInfo({this.pinPath, this.avatarPath, this.location, this.locationName, this.labelColor});
}