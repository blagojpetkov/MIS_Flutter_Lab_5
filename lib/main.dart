import 'package:flutter/material.dart';
import 'package:flutter_lab_3/providers/auth.dart';
import 'package:flutter_lab_3/screens/add_exam_screen.dart';
import 'package:flutter_lab_3/screens/auth_screen.dart';
import 'package:flutter_lab_3/screens/home_screen.dart';
import 'package:flutter_lab_3/screens/map_all_exams_screen.dart';
import 'package:flutter_lab_3/screens/map_screen.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';
import 'models/exam.dart';
import 'models/user.dart';

import 'package:flutter_local_notifications/flutter_local_notifications.dart';

final FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin = FlutterLocalNotificationsPlugin();

void main() {
  WidgetsFlutterBinding.ensureInitialized();
  // Initialize the local notifications plugin
  initializeLocalNotifications();
  runApp(const MyApp());
}

void initializeLocalNotifications() {
  var initializationSettingsAndroid =
      AndroidInitializationSettings('@mipmap/ic_launcher');
  var initializationSettingsIOS = IOSInitializationSettings();
  var initializationSettings = InitializationSettings(
    android: initializationSettingsAndroid,
    iOS: initializationSettingsIOS,
  );
  flutterLocalNotificationsPlugin.initialize(initializationSettings);
}

class MyApp extends StatelessWidget {
  const MyApp();

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (context) => Auth(),
      child: MaterialApp(
        routes: {
          "/home": (context) => MyHomePage(authenticatedUser: Provider.of<Auth>(context).authenticatedUser),
          "/auth": (context) => AuthScreen(),
          "/map": (context) => MapScreen(),
          MapAllExamsScreen.routeName: (context) => MapAllExamsScreen(),
          "/add-exam" : (context) => AddExamScreen()
        },
        title: 'Flutter Demo',
        theme: ThemeData(
          primarySwatch: Colors.purple,
          accentColor: Colors.amber,
        ),
        home: AuthScreen(),
      ),
    );
  }
}

