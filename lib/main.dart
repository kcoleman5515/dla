import 'package:flutter/material.dart';

import 'controller/home.dart';

void main() {
  runApp(const DlaApp());
}

class DlaApp extends StatelessWidget {

  const DlaApp({Key? key}) : super(key: key);

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'DLA',
      theme: ThemeData(
        // This is the theme of your application.
        //
        // Try running your application with "flutter run". You'll see the
        // application has a blue toolbar. Then, without quitting the app, try
        // changing the primarySwatch below to Colors.green and then invoke
        // "hot reload" (press "r" in the console where you ran "flutter run",
        // or simply save your changes to "hot reload" in a Flutter IDE).
        // Notice that the counter didn't reset back to zero; the application
        // is not restarted.
        primarySwatch: Colors.red,
        primaryColorDark: Colors.redAccent
      ),
      home: const DlaHomePage(title: 'DLA'),
      debugShowCheckedModeBanner: false,
    );
  }
}

