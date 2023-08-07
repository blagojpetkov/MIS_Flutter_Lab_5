import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:location/location.dart';
import 'package:provider/provider.dart';

import '../models/exam.dart';
import '../providers/auth.dart';

class MapAllExamsScreen extends StatefulWidget {
  static const routeName = '/map-all-exams';

  const MapAllExamsScreen({this.initialLocation = const PlaceLocation(latitude: 41.99646, longitude: 21.43141), this.isSelecting = false, Key key}) : super(key: key);
  final PlaceLocation initialLocation;
  final bool isSelecting;
  @override
  State<MapAllExamsScreen> createState() => _MapAllExamsScreenState();
}

class _MapAllExamsScreenState extends State<MapAllExamsScreen> {


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
            ...exams.map((e) => Marker(markerId: MarkerId(e.location.latitude.toString() + e.location.longitude.toString()), position: e.location)).toList()
          },
        )
    
    
    );
  }
}