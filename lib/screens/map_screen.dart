import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:location/location.dart';

import '../models/exam.dart';

class MapScreen extends StatefulWidget {
  const MapScreen({this.initialLocation = const PlaceLocation(latitude: 41.99646, longitude: 21.43141), this.isSelecting = false, Key key}) : super(key: key);
  final PlaceLocation initialLocation;
  final bool isSelecting;
  @override
  State<MapScreen> createState() => _MapScreenState();
}

class _MapScreenState extends State<MapScreen> {

  LatLng pickedLocation;

  void selectLocation(LatLng position){
    setState(() {
      pickedLocation = position;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(appBar: AppBar(
      title: Text("Map"),
          actions: [
            if (widget.isSelecting)
              IconButton(
                onPressed: pickedLocation == null
                    ? null : () {
                        Navigator.of(context).pop(pickedLocation);
                      },
                icon: Icon(Icons.check),
              )
          ],
    
    
    ), 
        body: GoogleMap(
          initialCameraPosition: CameraPosition(
            target: LatLng(widget.initialLocation.latitude,
              widget.initialLocation.longitude,
            ),
            zoom: 12
          ),
          onTap: widget.isSelecting ? selectLocation : null,
          markers: pickedLocation ==null ? null : {
            Marker(markerId: MarkerId("m1"), position: pickedLocation)
          },
        )
    
    
    );
  }
}