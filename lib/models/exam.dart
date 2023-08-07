import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';

class Exam {
  final String id;
  final String name;
  final DateTime dateTime;
  final LatLng location;
  Exam({@required this.id, @required this.name, @required this.dateTime, this.location});
}

class PlaceLocation{
  final double latitude;
  final double longitude;

  const PlaceLocation({@required this.latitude, @required this.longitude});
}