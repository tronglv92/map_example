import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:freeletics_running/models/distance_matrix.dart';
import 'package:freeletics_running/models/element_distance.dart';
import 'package:freeletics_running/models/place_location.dart';
import 'package:freeletics_running/models/suggestion.dart';
import 'package:http/http.dart';

import '../../../secrets.dart';

class SearchLocationProvider extends ChangeNotifier {
  SearchLocationProvider({this.sessionToken});

  final client = Client();
  final String sessionToken;
  Future<List<Suggestion>> fetchSuggestions(
      {String input,
      String lang,

      String location,
      String radius}) async {
    Uri uri =
        Uri.https('maps.googleapis.com', '/maps/api/place/autocomplete/json', {
      'input': input,
      'language': lang,
      'key': Secrets.API_KEY,
      'sessiontoken': sessionToken,
      'location': location,
      'radius': radius
    });
    // print("uri " + uri.toString());
    final response = await client.get(uri);
    if (response.statusCode == 200) {
      final result = json.decode(response.body);

      if (result['status'] == 'OK') {
        // compose suggestions in a list
        return result['predictions']
            .map<Suggestion>((p) => Suggestion(p['place_id'], p['description']))
            .toList();
      }
      if (result['status'] == 'ZERO_RESULTS') {
        return [];
      }
      throw Exception(result['error_message']);
    } else {
      throw Exception('Failed to fetch suggestion');
    }
  }

  Future<PlaceLocation> getPlaceDetailFromId(
      String placeId) async {
    Uri uri = Uri.https('maps.googleapis.com', '/maps/api/place/details/json', {
      'place_id': placeId,
      'key': Secrets.API_KEY,
      'sessiontoken': sessionToken
    });
    // print("uri " + uri.toString());
    final response = await client.get(uri);

    if (response.statusCode == 200) {
      final result = json.decode(response.body);
      if (result['status'] == 'OK') {
        final components =
            result['result']['address_components'] as List<dynamic>;
        // build result
        final PlaceLocation place = PlaceLocation();

        components.forEach((c) {
          final List type = c['types'];
          if (type.contains('street_number')) {
            place.streetNumber = c['long_name'];
          }
          if (type.contains('route')) {
            place.street = c['long_name'];
          }
          if (type.contains('locality')) {
            place.city = c['long_name'];
          }
          if (type.contains('postal_code')) {
            place.zipCode = c['long_name'];
          }
        });

        place.latitude=result['result']['geometry']['location']['lat'];
        place.longitude=result['result']['geometry']['location']['lng'];
        place.formattedAddress=result['result']['formatted_address'];
        return place;
      }
      throw Exception(result['error_message']);
    } else {
      throw Exception('Failed to fetch suggestion');
    }
  }

  Future<List<DistanceMatrix>> calculatorDistance(
      String origins, String destinations) async {
    //origins=40.6655101,-73.89188969999998
    //destinations=place_id:
    // EkdIb8OgbmcgSG9hIFRow6FtLCBQaMaw4budbmcgNywgQsOsbmggVGjhuqFuaCwgSG8gQ2hpIE1pbmggQ2l0eSwgVmlldG5hbSIuKiwKFAoSCdE6uZzEKHUxEeNrYY6KIu6iEhQKEgkVh3mZwyh1MREH7xFu74LN2Q|place_id:
    // EkNIb8OgbmcgSG9hIFRow6FtLCBQaMaw4budbmcgMTIsIFRhbiBCaW5oLCBIbyBDaGkgTWluaCBDaXR5LCBWaWV0bmFtIi4qLAoUChIJqRbap0gpdTERhcznRXuNukQSFAoSCdG2wfdIKXUxEQnQztNEMUSC
    Uri uri =
        Uri.https('maps.googleapis.com', '/maps/api/distancematrix/json', {
      'origins': origins,
      'destinations': destinations,
      'key': Secrets.API_KEY,
    });
    // print("calculatorDistance uri " + uri.toString());
    final response = await client.get(uri);
    if (response.statusCode == 200) {
      final result = json.decode(response.body);
      if (result['status'] == 'OK') {
        List<DistanceMatrix> distanceMatrix = [];

        final rows = result['rows'] as List<dynamic>;

        if (rows.length > 0) {
          final elements = rows[0]['elements'] as List<dynamic>;
          for (int i = 0; i < elements.length; i++) {
            if (elements[i]['status'] == 'OK') {
              final distance = elements[i]['distance'];
              final duration = elements[i]['duration'];
              distanceMatrix.add(DistanceMatrix(
                  distance: ElementDistance(
                      text: distance['text'], value: distance['value']),
                  duration: ElementDistance(
                      text: duration['text'], value: duration['value'])));
            } else {
              distanceMatrix.add(null);
            }
          }
        }

        return distanceMatrix;
      }
      throw Exception(result['error_message']);
    } else {
      throw Exception('Failed to fetch suggestion');
    }
  }
}
