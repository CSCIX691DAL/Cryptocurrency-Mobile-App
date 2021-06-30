import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:dal_app/Authentication/authentication_screen.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import 'Main Interface/base_screen.dart';

void main()  {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Crypto Traders',
      theme: ThemeData(
        primarySwatch: Colors.orange,
        accentColor: Colors.blueGrey,
      ),
      home: MyHomePage(title: 'Dal App'),
    );
  }
}

class MyHomePage extends StatefulWidget {
  MyHomePage({Key key, this.title}) : super(key: key);

  // This widget is the home page of your application. It is stateful, meaning
  // that it has a State object (defined below) that contains fields that affect
  // how it looks.

  // This class is the configuration for the state. It holds the values (in this
  // case the title) provided by the parent (in this case the App widget) and
  // used by the build method of the State. Fields in a Widget subclass are
  // always marked "final".

  final String title;

  @override
  _MyHomePageState createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {


  @override
  Widget build(BuildContext context) {

    // A FutureBuilder is a widget that will fetch data, then create a child
    // widget and pass the data down to it. This is helpful when you want to get
    // information from the internet. Here, we are just using it to initialize
    // Firebase in our project. Once the app has successfully connected to Firebase,
    // it will return our UI

    return FutureBuilder<FirebaseApp>(
      future: Firebase.initializeApp(),
      builder: (context, snapshot) {
        //If this snapshot is not finished, return a view with only a spinning
        //loading wheel in the center.
        if(snapshot.connectionState != ConnectionState.done) {
          return Scaffold(
            body: Center(
              child: CircularProgressIndicator(),
            ),
          );
        }
        if(snapshot.hasError) {
          return Scaffold(
             body: Center(
               child: Icon(Icons.error_outline, size: 100)
             ),
          );
        }
        return StreamBuilder<User>(
          stream: FirebaseAuth.instance.userChanges(),
          builder: (context, snap) {
            if(FirebaseAuth.instance.currentUser != null) {
              return BaseScreen();
            } else {
              return AuthenticationScreen();
            }
          },
        );
      }
    );
  }
}
