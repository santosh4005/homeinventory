import 'package:flutter/material.dart';

class Inventory extends StatelessWidget {
  static const String name = "/inventory";

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("My Inventory"),
      ),
      body: ListView(
        children: <Widget>[
          Text("Test 1"),
          Text("Test 1"),
          Text("Test 1"),
          Text("Test 1"),
        ],
      ),
    );
  }
}
