import 'package:flutter/material.dart';
import 'package:home_inventory/providers/inventoryprovider.dart';
import 'package:home_inventory/screens/addinventory.dart';
import 'package:home_inventory/screens/inventory.dart';
import 'package:provider/provider.dart';
import './screens/myhomepage.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MultiProvider(
        providers: [
          ChangeNotifierProvider.value(
            value: ProviderInventory(),
          )
        ],
        child: MaterialApp(
          debugShowCheckedModeBanner: false,
          title: 'Home Inventory',
          theme: ThemeData(
            primarySwatch: Colors.blue,
            visualDensity: VisualDensity.adaptivePlatformDensity,
          ),
          initialRoute: "/",
          routes: {
            "/": (ctx) => MyHomePage(title: 'Home Inventory'),
            ScreenInventory.name: (ctx) => ScreenInventory(),
            ScreenAddInventory.name: (ctx) => ScreenAddInventory()
          },
        ));
  }
}
