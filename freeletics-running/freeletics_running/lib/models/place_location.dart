import 'dart:convert';

import 'package:equatable/equatable.dart';
import 'package:flutter/material.dart';

class PlaceLocation  {
   String streetNumber;
   String street;

   String city;
   String zipCode;
   double latitude;
   double longitude;
   String formattedAddress;

  PlaceLocation(
      {this.streetNumber,
      this.street,
      this.city,
      this.zipCode,
      this.latitude,
      this.longitude,
      this.formattedAddress});

  @override
  String toString() {
    return 'Place(streetNumber: $streetNumber, street: $street, city: $city,'
        ' zipCode: $zipCode,latitude: $latitude,longitude: $longitude,'
        'formattedAddress: $formattedAddress)';
  }



}
