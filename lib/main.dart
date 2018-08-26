import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:limastar_controller/screen/login/loginScreen.dart';
import 'package:limastar_controller/screen/home/HomeScreen.dart';

void main() => runApp(new MyApp());

class MyApp extends StatelessWidget {
  final _auth = FirebaseAuth.instance;
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return new MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        primaryColor: Colors.blueAccent
      ),
      home: StreamBuilder(
        stream: _auth.onAuthStateChanged,
        builder: (BuildContext context, AsyncSnapshot<FirebaseUser> user) {
          if (user.data != null) return HomeScreen();
          return LoginScreen();
        }
      )
    );
  }
}