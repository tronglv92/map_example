import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_polyline_points/flutter_polyline_points.dart';
import 'package:freeletics_running/helper/helper.dart';
import 'package:freeletics_running/pages/freeletics/monitor.dart';
import 'package:freeletics_running/widgets/appbar_empty.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
// import 'package:location/location.dart';
import 'package:geolocator/geolocator.dart';



const double CAMERA_ZOOM = 14;

const LatLng SOURCE_LOCATION = LatLng(10.802772, 106.64535);
const LatLng DEST_LOCATION = LatLng(10.8115425, 106.6620336);

class FreeleticsRunningPage extends StatefulWidget {
  @override
  _FreeleticsRunningPageState createState() => _FreeleticsRunningPageState();
}

class _FreeleticsRunningPageState extends State<FreeleticsRunningPage> {
  Completer<GoogleMapController> _completer = Completer();
  GoogleMapController _controller;




  CameraPosition cameraPosition =
      CameraPosition(target: SOURCE_LOCATION, zoom: CAMERA_ZOOM);
  BitmapDescriptor sourceIcon;
  BitmapDescriptor destinationIcon;
  // LocationData _currentLocation;
  Position _currentLocation;


  List<Position> listPositions = [];
  // List<LocationData> listPositions = [];
  int totalDistance=500;
  int runDistance = 0;
  // double runDuration=0;
  double runSpace=0;
  Map<MarkerId, Marker> _markers = Map<MarkerId, Marker>();
  Map<PolylineId, Polyline> polylines = {};
  PolylinePoints polylinePoints;

  bool firstTimeMapCreated=false;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    _currentLocation = Position.fromMap({
      'latitude': SOURCE_LOCATION.latitude,
      'longitude': SOURCE_LOCATION.longitude
    });


  }

  void _onMapCreated(GoogleMapController controller) async {
    _completer.complete(controller);
    _controller = controller;


    await checkPermission();


     Geolocator.getPositionStream(desiredAccuracy: LocationAccuracy.best).listen(
            (Position position) {
              print("_location.onLocationChanged.listen ");
              if (_currentLocation != position)
                moveToCurrentLocation(position);
        });

    // _location.onLocationChanged.listen((LocationData currentLocation) {
    //
    //   print("_location.onLocationChanged.listen ");
    //   if (_currentLocation != currentLocation)
    //     moveToCurrentLocation(currentLocation);
    // });
  }

  void moveToCurrentLocation(Position currentLocation) {

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

  setUpPolyline(Position position) async {
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
      Position lastLocation = listPositions[listPositions.length - 1];
      Position beforeLocation = listPositions[listPositions.length - 2];
      Position firstLocation=listPositions[0];

      int runDistance = Helper.calculateDistance(lastLocation.latitude, lastLocation.longitude,
              beforeLocation.latitude, beforeLocation.longitude).round();



       runSpace=Helper.spaceBetween(runDistance, beforeLocation, lastLocation);
       print("run space "+runSpace.toString());

      this.runDistance=this.runDistance+runDistance;

    }
    else{

      runSpace=0;

    }
  }

  Future<void> checkPermission() async {
    bool serviceEnabled;
    LocationPermission permission;

    // Test if location services are enabled.
    serviceEnabled = await Geolocator.isLocationServiceEnabled();
    if (!serviceEnabled) {
      // Location services are not enabled don't continue
      // accessing the position and request users of the
      // App to enable the location services.
      return Future.error('Location services are disabled.');
    }

    permission = await Geolocator.checkPermission();
    if (permission == LocationPermission.denied) {
      permission = await Geolocator.requestPermission();
      if (permission == LocationPermission.deniedForever) {
        // Permissions are denied forever, handle appropriately.
        return Future.error(
            'Location permissions are permanently denied, we cannot request permissions.');
      }

      if (permission == LocationPermission.denied) {
        // Permissions are denied, next time you could try
        // requesting permissions again (this is also where
        // Android's shouldShowRequestPermissionRationale
        // returned true. According to Android guidelines
        // your App should show an explanatory UI now.
        return Future.error(
            'Location permissions are denied');
      }
    }

    return;
  }

  // void setSourceAndDesIcons() async {
  //   BitmapDescriptor.fromAssetImage(
  //           ImageConfiguration(devicePixelRatio: 2.0, size: Size(10, 10)),
  //           'assets/driving_pin.png')
  //       .then((onValue) {
  //     sourceIcon = onValue;
  //   });
  //
  //   BitmapDescriptor.fromAssetImage(
  //           ImageConfiguration(devicePixelRatio: 2.0, size: Size(10, 10)),
  //           'assets/driving_pin.png')
  //       .then((value) {
  //     destinationIcon = value;
  //   });
  // }

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

  onPressClose(){
    Navigator.of(context).pop();
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
          Monitor(totalDistance: totalDistance,runDistance: runDistance,runSpace: runSpace,onPressClose:onPressClose),
          Expanded(
            flex: 1,
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
