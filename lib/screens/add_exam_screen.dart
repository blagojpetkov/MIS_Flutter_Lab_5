
import 'package:flutter_lab_3/helpers/location_helper.dart';
import 'package:flutter_lab_3/screens/map_screen.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:intl/intl.dart';
import 'package:location/location.dart';
import 'package:flutter/material.dart';
import 'package:flutter_lab_3/widgets/MyAppBar.dart';
import 'package:nanoid/nanoid.dart';
import 'package:provider/provider.dart';

import '../models/exam.dart';
import '../providers/auth.dart';

class AddExamScreen extends StatefulWidget {
  final String title;
  const AddExamScreen(this.title, {Key key}) : super(key: key);

  @override
  State<AddExamScreen> createState() => _AddExamScreenState();
}

class _AddExamScreenState extends State<AddExamScreen> {

// String previewImageUrl;
// Future<void> getCurrentLocation() async {
//     final locData = await Location().getLocation();
//     setState(() {
//     previewImageUrl = LocationHelper.generateLocationPreviewImage(latitude: locData.latitude, longitude: locData.longitude);
//     });
//   }


final nameController = TextEditingController();

  String name = '';
  DateTime selectedDate = DateTime.now();
  TimeOfDay selectedTime = TimeOfDay.now();
  LatLng selectedLocation;

  void presentDatePicker() {
    showDatePicker(
            context: context,
            initialDate: DateTime.now(),
            firstDate: DateTime(2019),
            lastDate: DateTime.now().add(const Duration(days: 50)))
        .then((pickedDate) {
      if (pickedDate == null) {
        return;
      }
      setState(() {
        selectedDate = pickedDate;
      });
    });
  }

  void presentTimePicker() {
    showTimePicker(
        context: context,
        initialTime: selectedTime == null ? TimeOfDay(
          hour: 10,
          minute: 10,
        ) : selectedTime).then((pickedTime) {
          if (pickedTime == null) {
            return;
          }
          setState(() {
            selectedTime = pickedTime;
          });
        });
  }

  void submitData() {
    if (nameController.text.isEmpty) {
      return;
    }
    final vnesenoIme = nameController.text;
    final vnesenDatum = DateTime(selectedDate.year, selectedDate.month, selectedDate.day, selectedTime.hour, selectedTime.minute);
    final newExam =
        Exam(id: nanoid(5), name: vnesenoIme, dateTime: vnesenDatum, location: selectedLocation);
    Provider.of<Auth>(context, listen: false).addNewItemToList(newExam);

    Provider.of<Auth>(context, listen: false).scheduleNotificationsForLoggedInUser();
    
    Navigator.of(context).pop();
  }




  
  Future<void> selectOnMap() async {
    
    LatLng newSelectedLocation = await Navigator.of(context).push(
      MaterialPageRoute(
        fullscreenDialog: true,
        builder: (context) => MapScreen(isSelecting: true,),
      ),
    );


    setState(() {
      selectedLocation = newSelectedLocation; 
    });


    if(selectedLocation == null) {
      return;
    }

    
    

  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
      title: Text(widget.title),
      actions: <Widget>[
          IconButton(
              icon: Icon(Icons.map), onPressed: selectOnMap),
        ],
    ),
    body: Container(
      padding: EdgeInsets.all(8),
      child: Column(
        children: [
          TextField(
            controller: nameController,
            decoration: InputDecoration(labelText: "Име на предметот"),
            onSubmitted: (_) => submitData(),
          ),
          Container(
            height: 50,
            child: Row(
              children: [
                Expanded(child: Text(selectedDate == null ? 'No date chosen' :  DateFormat().add_yMMMd().format(selectedDate))),
                TextButton(child: Text('Choose date', style: TextStyle(color: Theme.of(context).primaryColorDark, fontWeight: FontWeight.bold),), onPressed: presentDatePicker,),
              ],
            ),
          ),

          Container(
            height: 50,
            child: Row(
              children: [
                Expanded(child: Text(selectedTime == null ? 'No time chosen' : '${selectedTime.hour}:${selectedTime.minute}')),
                TextButton(child: Text('Choose time', style: TextStyle(color: Theme.of(context).primaryColorDark, fontWeight: FontWeight.bold),), onPressed: presentTimePicker,),
              ],
            ),
          ),
          Container(height: 10,),
          TextButton(child: Text(selectedLocation == null ? "Open map to set location" : "Location set. Tap to change."), onPressed: () => selectOnMap(),),

          Container(height: 10),
          ElevatedButton(
            style: ElevatedButton.styleFrom(
                backgroundColor: Theme.of(context).primaryColor),
            child: Text("Add"),
            onPressed: () => submitData(),
          )
        ],
      ),
    )
    // body: previewImageUrl != null ? Image.network(previewImageUrl) : Center(child: Text("No image yet"),)
    );
  }
}