import 'package:flutter/material.dart';



class MyAppBar extends StatelessWidget implements PreferredSizeWidget {

  final BuildContext context;
  final String title;
  final DateTime selectedDate;
  final Function setSelectedDate;
  const MyAppBar(this.title, this.context, this.selectedDate, this.setSelectedDate, {Key key}) : super(key: key);


  void presentDatePicker() {
    showDatePicker(
            context: context,
            initialDate: selectedDate != null ? selectedDate : DateTime.now(),
            firstDate: DateTime(2019),
            lastDate: DateTime.now().add(const Duration(days: 50)))
        .then((pickedDate) {
      if (pickedDate == null) {
        return;
      }
      setSelectedDate(pickedDate);
    });
  }

  void addItemFunction(BuildContext ct) {
    Navigator.of(context).pushNamed("/add-exam");
    
  }

  @override
  Widget build(BuildContext context) {
    return AppBar(
        title: Text(title),
        actions: <Widget>[
          IconButton(
              icon: Icon(Icons.calendar_month), onPressed: presentDatePicker),
          IconButton(
              icon: Icon(Icons.add), onPressed: () => addItemFunction(context)),
        ],
      );
  }
  
  @override
  Size get preferredSize => Size.fromHeight(kToolbarHeight);
}