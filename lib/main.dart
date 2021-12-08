// root package contain all material design widgets
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter_time_tracker_app/app/landing_page.dart';
import 'package:flutter_time_tracker_app/services/auth.dart';
import 'package:provider/provider.dart';


/*main() method is the starting point of the execution and it one method called runApp() which 
contain one parameter called widget name in our case it is MyApp()*/
Future<void> main() async{
  WidgetsFlutterBinding.ensureInitialized();
  /*
  Below statement is used to initialize flutterFire to use firebase services after initialisation is complete
  of firebase variable. 
  */
  await Firebase.initializeApp();
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) 
  {
    /*
    Provider is a predefine class or widget or flutter library and it is a generic type.
    It is used to inject dependency (means passing user define objects from parent class to child class) and
    to manage the state of the widgets.
     */
    return Provider<AuthBase>
    (
      create: (context)=> Auth(), 
      child: MaterialApp
            ( 
              title: "Time Tracker",
              debugShowCheckedModeBanner: false,
              theme: ThemeData
             (
               primarySwatch: Colors.purple //main color which is used in whole app
             ),
             home:LandingPage(),
           )
    );

   
  }
}