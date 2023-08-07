import 'package:flutter/material.dart';
import 'package:flutter_lab_3/screens/map_all_exams_screen.dart';
import 'package:flutter_lab_3/widgets/MyAppBar.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';

import '../models/exam.dart';
import '../models/user.dart';
import '../providers/auth.dart';

class MyHomePage extends StatefulWidget {
  const MyHomePage({@required this.title, @required this.authenticatedUser});

  final User authenticatedUser;

  final String title;

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  DateTime selectedDate;

  

  void logout(){
    Provider.of<Auth>(context, listen: false).logout();
    Navigator.of(context).pushReplacementNamed("/auth");
  }
  void openMap(){
    Navigator.of(context).pushNamed(MapAllExamsScreen.routeName);
  }

  
  void setSelectedDate(DateTime pickedDate){
    setState(() {
      selectedDate = pickedDate;
    });
  }

  void resetSelectedDate(){
    setState(() {
      selectedDate = null;
    });
  }

  void deleteItem(String id) {
    setState(() {
      widget.authenticatedUser.exams.removeWhere((element) => element.id == id);
    });
  }


  Widget ListOfSubjects() {

    List<Exam> appropriateSubjects = [];
    if (selectedDate == null)
      appropriateSubjects = widget.authenticatedUser.exams;
    else {
      appropriateSubjects = widget.authenticatedUser.exams.where((element) {
        return element.dateTime.day == selectedDate?.day &&
            element.dateTime.month == selectedDate?.month &&
            element.dateTime.year == selectedDate?.year;
      }).toList();
    }

    return widget.authenticatedUser.exams.length == 0
        ? Text("You haven't added any exams in the list")
        : ListView.builder(
            itemBuilder: (cntx, index) {
              return Card(
                elevation: 3,
                margin: EdgeInsets.symmetric(
                  vertical: 8,
                  horizontal: 10,
                ),
                child: ListTile(
                  title: Text(appropriateSubjects[index].name,
                      style: TextStyle(fontWeight: FontWeight.bold)),
                  subtitle: Text(appropriateSubjects[index]
                      .dateTime
                      .toString()
                      .substring(0, 16)),
                  trailing: IconButton(
                    icon: Icon(Icons.delete),
                    onPressed: () => deleteItem(appropriateSubjects[index].id),
                  ),
                ),
              );
            },
            itemCount: appropriateSubjects.length,
          );
  }

  @override
  Widget build(BuildContext context) {

    return Scaffold(
      appBar: MyAppBar(widget.title, context, selectedDate, setSelectedDate),
      body: SingleChildScrollView(
        child: Column(
            children: [
              Container(height: 10),
              Container(child: Text("Welcome, ${Provider.of<Auth>(context, listen: false).username}"),),

              TextButton(onPressed: openMap, child: Text('Open Map to view location of all exams')),

              TextButton(onPressed: logout, child: Text('Log out')),
              Container(height: 20,),
              TextButton(onPressed: resetSelectedDate, child: Text('View all of your courses')),
              Text('Open calendar to find courses on a specific date!'),
              Text(selectedDate==null? 'No date chosen' : 'Chosen date is ' + DateFormat().add_yMMMd().format(selectedDate)),
              Container(
                height: MediaQuery.of(context).size.height * 0.6,
                child: ListOfSubjects(),
              ),
            ]),
      ),
    );
  }
}
