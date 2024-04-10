import 'package:flutter/material.dart';
import 'weather.dart';
import 'world_destination.dart';
import 'world_place.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false, // Set this to false
      home: Scaffold(
        appBar: AppBar(
          title: const Text('VyBe'),
          backgroundColor: Colors.yellow,
        ),
        body:  WorldDestination(),
      ),
    );
  }
}

