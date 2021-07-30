import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_polyline_points/flutter_polyline_points.dart';
import 'package:freeletics_running/helper/helper.dart';
import 'package:freeletics_running/models/map_location.dart';
import 'package:freeletics_running/models/place_location.dart';
import 'package:freeletics_running/models/suggestion.dart';
import 'package:freeletics_running/pages/route_map/map/my_location_button.dart';
import 'package:freeletics_running/pages/route_map/map/zoom_butotn.dart';
import 'package:freeletics_running/pages/route_map/search_location/search_location_page.dart';
import 'package:freeletics_running/pages/route_map/search_location/search_location_provider.dart';

import 'package:google_maps_flutter/google_maps_flutter.dart';
// import 'package:location/location.dart';
import 'package:geolocator/geolocator.dart';
import '../../../secrets.dart';
import 'address_view.dart';
import 'package:provider/provider.dart';

class MapPage extends StatefulWidget {
  @override
  _MapPageState createState() => _MapPageState();
}

class _MapPageState extends State<MapPage> {
  CameraPosition _initialLocation = CameraPosition(target: LatLng(0.0, 0.0));

  // For controlling the view of the Map
  GoogleMapController mapController;




  Position currentLocation;



  Map<MarkerId, Marker> _markers = Map<MarkerId, Marker>();
  Map<PolylineId, Polyline> _polylines = {};

  // List of coordinates to join
  List<LatLng> polylineCoordinates = [];

// Object for PolylinePoints
  PolylinePoints polylinePoints;
  MapLocation startPosition;
  MapLocation endPosition;
  double distance = 0;
  StreamSubscription streamSubscription;
  @override
  void initState() {
    super.initState();

    // WidgetsBinding.instance.addPostFrameCallback((timeStamp) {
    //   getCurrentLocation();
    // });

  }

  //
  // getCurrentLocation() async{
  //
  //
  //
  // }
  @override
  void dispose() {
    // TODO: implement dispose
    mapController?.dispose();
    streamSubscription?.cancel();
    super.dispose();
  }

  void _onMapCreated(GoogleMapController controller) async {
    print("_onMapCreated ");
    mapController = controller;
    currentLocation=await checkPermission();
    mapController.animateCamera(
      CameraUpdate.newCameraPosition(
        CameraPosition(
          target: LatLng(
              currentLocation.latitude, currentLocation.longitude),
          zoom: 18.0,
        ),
      ),
    );

    print("currentLocation  "+currentLocation.toString());
    try
    {

       streamSubscription= Geolocator.getPositionStream(desiredAccuracy: LocationAccuracy.best).listen(
              (Position position) {
            print("_location.onLocationChanged.listen ");
            if (currentLocation != position)
              setState(() {
                currentLocation = position;

              });
          });

    }on PlatformException catch (e) {
      print("PlatformException ");
      if (e.code == 'PERMISSION_DENIED') {

      } else if (e.code == 'PERMISSION_DENIED_NEVER_ASK') {

      }


    }

    // currentLocation = await _location.getLocation();
    // print("currentLocation "+currentLocation.toString());

  }

  void moveToCurrentLocation() async {
    if ( mapController != null) {
      if (currentLocation != null) {
        mapController.animateCamera(
          CameraUpdate.newCameraPosition(
            CameraPosition(
              target:
                  LatLng(currentLocation.latitude, currentLocation.longitude),
              zoom: 18.0,
            ),
          ),
        );
      }
    }
    // if (startPosition != null && endPosition != null) {
    //   zoomBothPoints();
    // }
  }

  Future<Position> checkPermission() async {
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

    return await Geolocator.getCurrentPosition();
  }

  void gotoSearchPage(bool searchStartPoint) async {
    if (currentLocation != null) {
      // get placeId when click address
      final result = await Navigator.of(context).push(MaterialPageRoute(
          builder: (context) => SearchLocationPage(
                currentLocation: currentLocation,
                startPoint: searchStartPoint,
                searchLocation:
                    searchStartPoint == true ? startPosition : endPosition,
              )));

      if (result != null) {
        MapLocation location;
        if (result is String) {
          // get detail place from placeId
          PlaceLocation place = await context
              .read<SearchLocationProvider>()
              .getPlaceDetailFromId(result);
          location = MapLocation(
              formattedAddress: place.formattedAddress,
              latitude: place.latitude,
              longitude: place.longitude);
        } else if (result is Position) {
          location = MapLocation(
              formattedAddress: "Your location",
              latitude: result.latitude,
              longitude: result.longitude);
        }
        renderMarkerAndMoveCamera(location, searchStartPoint);
      }
    }
  }

  void renderMarkerAndMoveCamera(MapLocation place, bool searchStartPoint) {
    if (place != null) {
      if (place.latitude != null && place.longitude != null) {
        Future.delayed(const Duration(milliseconds: 500), () {
          setState(() {
            //render marker
            renderMarkerAddress(
                place.latitude, place.longitude, searchStartPoint);

            // check if search start point or end point
            if (searchStartPoint == true) {
              startPosition = place;
            } else {
              endPosition = place;
            }

            if (startPosition != null && endPosition != null) {
              // if have 2 address zoom map we can view 2 location
              zoomBothPoints();
            } else {
              // else move camera to place
              mapController.animateCamera(
                CameraUpdate.newLatLng(LatLng(place.latitude, place.longitude)),
              );
            }
          });
        });
      }
    }
  }

  void zoomBothPoints() {
// Define two position variables
    MapLocation _northeastCoordinates;
    MapLocation _southwestCoordinates;

    // Calculating to check that
    // southwest coordinate <= northeast coordinate
    if (startPosition.latitude <= endPosition.latitude) {
      _southwestCoordinates = startPosition;
      _northeastCoordinates = endPosition;
    } else {
      _southwestCoordinates = endPosition;
      _northeastCoordinates = startPosition;
    }
    mapController.animateCamera(
      CameraUpdate.newLatLngBounds(
          LatLngBounds(
            northeast: LatLng(
              _northeastCoordinates.latitude,
              _northeastCoordinates.longitude,
            ),
            southwest: LatLng(
              _southwestCoordinates.latitude,
              _southwestCoordinates.longitude,
            ),
          ),
          100.0),
    );
  }

  onPressShowRoute() async {
    if (startPosition != null && endPosition != null) {
      await _showPolylines(startPosition, endPosition);
    }
  }

  _showPolylines(MapLocation start, MapLocation end) async {
    // Initializing PolylinePoints
    polylinePoints = PolylinePoints();
    polylineCoordinates = [];
    // Generating the list of coordinates to be used for
    // drawing the polylines
    PolylineResult result = await polylinePoints.getRouteBetweenCoordinates(
      Secrets.API_KEY, // Google Maps API Key
      PointLatLng(start.latitude, start.longitude),
      PointLatLng(end.latitude, end.longitude),
      travelMode: TravelMode.driving,
    );

    // Adding the coordinates to the list
    if (result.points.isNotEmpty) {
      result.points.forEach((PointLatLng point) {
        polylineCoordinates.add(LatLng(point.latitude, point.longitude));
      });
    }

    // Defining an ID
    PolylineId id = PolylineId('poly');

    // Initializing Polyline
    Polyline polyline = Polyline(
      polylineId: id,
      color: Colors.red,
      points: polylineCoordinates,
      width: 3,
    );

    // Adding the polyline to the map
    setState(() {
      _polylines[id] = polyline;
      distance = _calculatorDistanceFromRoute();
    });
  }

  double _calculatorDistanceFromRoute() {
    double distances = 0;
    for (int i = 0; i < polylineCoordinates.length - 1; i++) {
      LatLng nextLatLng = polylineCoordinates[i + 1];
      LatLng currentLatLng = polylineCoordinates[i];
      distances = distances +
          Helper.calculateDistance(nextLatLng.latitude, nextLatLng.longitude,
              currentLatLng.latitude, currentLatLng.longitude);
    }
    return distances;
  }

  renderMarkerAddress(double lat, double lng, bool startPoint) {
    _markers[MarkerId(startPoint == true ? 'startPoint' : 'endPoint')] = Marker(
      markerId: MarkerId(startPoint == true ? 'startPoint' : 'endPoint'),
      position: LatLng(lat, lng),
    );
  }

  @override
  Widget build(BuildContext context) {
    var height = MediaQuery.of(context).size.height;
    var width = MediaQuery.of(context).size.width;
    return Container(
      height: height,
      width: width,
      child: Scaffold(
        body: Stack(
          children: <Widget>[
            GoogleMap(
              initialCameraPosition: _initialLocation,
              myLocationEnabled: true,
              myLocationButtonEnabled: false,
              mapType: MapType.normal,
              zoomGesturesEnabled: true,
              zoomControlsEnabled: false,
              onMapCreated: _onMapCreated,
              markers: Set<Marker>.of(_markers.values),
              polylines: Set<Polyline>.of(_polylines.values),
            ),
            ZoomButton(
              zoomIn: () {
                mapController.animateCamera(
                  CameraUpdate.zoomIn(),
                );
              },
              zoomOut: () {
                mapController.animateCamera(
                  CameraUpdate.zoomOut(),
                );
              },
            ),

            // Show the place input fields & button for
            // showing the route
            AddressView(
                onPressStartPoint: () {
                  print("vao trong nay 1");
                  gotoSearchPage(true);
                },
                onPressEndPoint: () {
                  gotoSearchPage(false);
                },
                onPressShowRoute: onPressShowRoute,
                startPoint: startPosition,
                endPoint: endPosition,
                distance: distance,
                onPressClose:(){
                  Navigator.of(context).pop();
                }),
            MyLocationButton(
              onPress: moveToCurrentLocation,
            )
          ],
        ),
      ),
    );
  }
}
