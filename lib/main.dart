import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:home_inventory/providers/inventoryprovider.dart';
import 'package:home_inventory/screens/addinventory.dart';
import 'package:home_inventory/screens/authscreen.dart';
import 'package:home_inventory/screens/inventory.dart';
import 'package:home_inventory/screens/splashscreen.dart';
import 'package:provider/provider.dart';
import './screens/myhomepage.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  final primaryColor = Colors.deepPurple;
  final accentColor = Colors.white;

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [ChangeNotifierProvider.value(value: ProviderInventory())],
      child: MaterialApp(
        debugShowCheckedModeBanner: false,
        title: 'Home Inventory',
        theme: ThemeData(
          primarySwatch: primaryColor,
          backgroundColor: primaryColor,
          accentColor: accentColor,
          // accentColorBrightness: Brightness.dark,
          buttonTheme: ButtonTheme.of(context).copyWith(
            buttonColor: primaryColor,
            textTheme: ButtonTextTheme.primary,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(20.0),
            ),
          ),
          visualDensity: VisualDensity.adaptivePlatformDensity,
        ),
        home: StreamBuilder(
          stream: FirebaseAuth.instance.onAuthStateChanged,
          builder: (context, snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting) {
              return SplashScreen();
            }

            if (snapshot.hasData) {
              return MyHomePage(
                title: "Home Inventory",
              );
            } else {
              return AuthScreen();
            }
          },
        ),
        // routes: {
        //   // "/": (ctx) => MyHomePage(title: 'Home Inventory'),
        //   ScreenInventory.name: (ctx) => ScreenInventory("All"),
        //   ScreenAddInventory.name: (ctx) => ScreenAddInventory()
        // },
      ),
    );
  }
}
