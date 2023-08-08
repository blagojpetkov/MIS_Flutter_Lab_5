import 'dart:async';
import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter_lab_3/helpers/location_helper.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:location/location.dart';
import 'package:provider/provider.dart';
import 'package:flutter_polyline_points/flutter_polyline_points.dart';
import '../models/exam.dart';
import '../providers/auth.dart';
import 'package:http/http.dart' as http;

class MapAllExamsScreen extends StatefulWidget {
  static const routeName = '/map-all-exams';

  const MapAllExamsScreen({this.initialLocation = const PlaceLocation(latitude: 41.99646, longitude: 21.43141), this.isSelecting = false, Key key}) : super(key: key);
  final PlaceLocation initialLocation;
  final bool isSelecting;
  @override
  State<MapAllExamsScreen> createState() => _MapAllExamsScreenState();
}

class _MapAllExamsScreenState extends State<MapAllExamsScreen> {

  Polyline polyline;
  LocationData _currentLocation;

  @override
  void initState() {
    super.initState();
    _getCurrentLocation();
  }

  Future<void> _getCurrentLocation() async {
    LocationData locationData;
    var location = Location();

    try {
      // locationData = await location.getLocation();
      locationData = LocationData.fromMap({
    'latitude': 42.00500213279011,
    'longitude': 21.39220055728363,
  });
    } catch (e) {
      locationData = null;
    }

    if (!mounted) return;

    setState(() {
      _currentLocation = locationData;
    });
  }


  void _onMarkerTapped(LatLng position) async {
  final String apiKey = API_KEY;
  final String apiUrl = 'https://maps.googleapis.com/maps/api/directions/json';
  final String origin = '${_currentLocation.latitude},${_currentLocation.longitude}';
  final String destination = '${position.latitude},${position.longitude}';
  final String requestUrl =
      '$apiUrl?origin=$origin&destination=$destination&key=$apiKey';

  try {
    final response = await http.get(Uri.parse(requestUrl));
    if (response.statusCode == 200) {
      final Map<String, dynamic> data = json.decode(response.body);

      if(data["status"] == "ZERO_RESULTS"){
        ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        content: Text("Location is too far away to create a route. Try a location that is somewhere in Macedonia."),
        duration: Duration(seconds: 3),
      ),);
      return;
      }


      final directions = {
      'start_location': data['routes'][0]['legs'][0]['start_location'],
      'end_location': data['routes'][0]['legs'][0]['end_location'],
      'polyline': data['routes'][0]['overview_polyline']['points'],
      'polyline_decoded': PolylinePoints()
          .decodePolyline(data['routes'][0]['overview_polyline']['points'])
    };

    
    setState(() {
      polyline = Polyline(
        polylineId: PolylineId('id'),
        width: 4,
        color: Colors.purple,
        points: (directions['polyline_decoded'] as List<PointLatLng>).map((p) => LatLng(p.latitude, p.longitude)).toList()
        );
    }
    );


    } else {
      print('Error: ${response.statusCode}');
    }
  } catch (e) {
    print('Error: $e');
  }
}




  @override
  Widget build(BuildContext context) {
    List<Exam> exams = Provider.of<Auth>(context).authenticatedUser.exams;
    return Scaffold(appBar: AppBar(
      title: Text("Map"),
    ), 
        body: GoogleMap(
          initialCameraPosition: CameraPosition(
            target: LatLng(widget.initialLocation.latitude,
              widget.initialLocation.longitude,
            ),
            zoom: 12
          ),
          markers: {
            ...exams
                .map((e) => Marker(
                    markerId: MarkerId(e.location.latitude.toString() +
                        e.location.longitude.toString()),
                    position: e.location,
                    infoWindow: InfoWindow(title: e.name),
                    onTap: () => _onMarkerTapped(e.location)))
                .toList()
          },
          polylines: polyline == null ? {} : {polyline},
        )
    
    
    );
  }
}