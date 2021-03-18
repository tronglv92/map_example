import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_polyline_points/flutter_polyline_points.dart';
import 'package:freeletics_running/helper/helper.dart';
import 'package:freeletics_running/pages/monitor.dart';
import 'package:freeletics_running/widgets/appbar_empty.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:location/location.dart';


import '../secrets.dart';

const double CAMERA_ZOOM = 14;

const LatLng SOURCE_LOCATION = LatLng(10.802772, 106.64535);
const LatLng DEST_LOCATION = LatLng(10.8115425, 106.6620336);

class HomePage extends StatefulWidget {
  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  Completer<GoogleMapController> _completer = Completer();
  GoogleMapController _controller;


  Location _location;
  bool _serviceEnabled = false;
  PermissionStatus _permissionGranted;



  CameraPosition cameraPosition =
      CameraPosition(target: SOURCE_LOCATION, zoom: CAMERA_ZOOM);
  BitmapDescriptor sourceIcon;
  BitmapDescriptor destinationIcon;
  LocationData _currentLocation;


  List<LocationData> listPositions = [];
  int totalDistance=200;
  int runDistance = 0;
  double runDuration=0;
  double runSpace=0;
  Map<MarkerId, Marker> _markers = Map<MarkerId, Marker>();
  Map<PolylineId, Polyline> polylines = {};
  PolylinePoints polylinePoints;

  bool firstTimeMapCreated=false;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    _currentLocation = LocationData.fromMap({
      'latitude': SOURCE_LOCATION.latitude,
      'longitude': SOURCE_LOCATION.longitude
    });

    setSourceAndDesIcons();
  }

  void _onMapCreated(GoogleMapController controller) async {
    _completer.complete(controller);
    _controller = controller;

    _location = new Location();
    await checkPermission();

    _location.changeSettings(interval: 1000);
    _location.onLocationChanged.listen((LocationData currentLocation) {

      if (_currentLocation != currentLocation)
        moveToCurrentLocation(currentLocation);
    });
  }

  void moveToCurrentLocation(LocationData currentLocation) {

    _currentLocation = currentLocation;

    if (_controller != null) {
      if(firstTimeMapCreated==false)
        {
          _controller.animateCamera(CameraUpdate.newLatLng(
              LatLng(_currentLocation.latitude, _currentLocation.longitude)));
          firstTimeMapCreated=true;
        }

      setState(() {
        if(runDistance<totalDistance)
          {
            setUpPolyline(currentLocation);
          }

        showCurrentMark();
      });
    }
  }

  setUpPolyline(LocationData position) async {
    listPositions.add(position);

    List<LatLng> results = [];
    for (int i = 0; i < listPositions.length; i++) {
      results
          .add(LatLng(listPositions[i].latitude, listPositions[i].longitude));
    }

    PolylineId polylineId = PolylineId('poly');
    polylines[polylineId] = Polyline(
      points: results, width: 2, // set the width of the polylines
      polylineId: PolylineId("poly"),
      color: Color.fromARGB(255, 40, 122, 198),
    );

    if (listPositions.length > 1) {
      LocationData lastLocation = listPositions[listPositions.length - 1];
      LocationData beforeLocation = listPositions[listPositions.length - 2];
      LocationData firstLocation=listPositions[0];

      int runDistance = Helper.calculateDistance(lastLocation.latitude, lastLocation.longitude,
              beforeLocation.latitude, beforeLocation.longitude).round();


       runDuration=lastLocation.time-firstLocation.time;
       runSpace=Helper.spaceBetween(runDistance, beforeLocation, lastLocation);

      this.runDistance=this.runDistance+runDistance;

    }
    else{
      runDuration=0;
      runSpace=0;

    }
  }

  Future<void> checkPermission() async {
    if (!_serviceEnabled) {
      _serviceEnabled = await _location.requestService();
      if (!_serviceEnabled) {
        return;
      }
    }

    _permissionGranted = await _location.hasPermission();
    if (_permissionGranted == PermissionStatus.denied) {
      _permissionGranted = await _location.requestPermission();
      if (_permissionGranted != PermissionStatus.granted) {
        return;
      }
    }
  }

  void setSourceAndDesIcons() async {
    BitmapDescriptor.fromAssetImage(
            ImageConfiguration(devicePixelRatio: 2.0, size: Size(10, 10)),
            'assets/driving_pin.png')
        .then((onValue) {
      sourceIcon = onValue;
    });

    BitmapDescriptor.fromAssetImage(
            ImageConfiguration(devicePixelRatio: 2.0, size: Size(10, 10)),
            'assets/driving_pin.png')
        .then((value) {
      destinationIcon = value;
    });
  }

  void showCurrentMark() {
    if (_currentLocation != null) {
      LatLng currentPosition =
          LatLng(_currentLocation.latitude, _currentLocation.longitude);
      _markers[MarkerId('currentLocation')] = Marker(
        markerId: MarkerId('currentLocation'),
        position: currentPosition,
      );
    }
  }



  @override
  void dispose() {
    // TODO: implement dispose
    super.dispose();
    _controller?.dispose();

  }

  @override
  Widget build(BuildContext context) {
    return AppBarEmpty(
      child: Column(
        children: [
          Monitor(totalDistance: totalDistance,runDistance: runDistance,runSpace: runSpace,),
          Expanded(
            flex: 3,
            child: GoogleMap(
              mapType: MapType.normal,
              initialCameraPosition: cameraPosition,
              onMapCreated: _onMapCreated,
              markers: Set<Marker>.of(_markers.values),
              myLocationEnabled: true,
              polylines: Set<Polyline>.of(polylines.values),
            ),
          )
        ],
      ),
    );
  }
}
