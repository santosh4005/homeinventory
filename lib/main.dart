import 'package:flutter/material.dart';
import 'package:home_inventory/screens/addinventory.dart';
import 'package:home_inventory/screens/inventory.dart';
import './screens/myhomepage.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Home Inventory',
      theme: ThemeData(
        primarySwatch: Colors.blue,
        visualDensity: VisualDensity.adaptivePlatformDensity,
      ),
      initialRoute: "/",
      routes: {
        "/": (ctx) => MyHomePage(title: 'Home Inventory'),
        Inventory.name: (ctx) => Inventory(),
        AddInventory.name: (ctx)=>AddInventory()
      },
    );
  }
}
