import 'package:flutter/material.dart';
import 'package:home_inventory/providers/inventoryprovider.dart';
import 'package:home_inventory/screens/addinventory.dart';
import 'package:home_inventory/screens/inventory.dart';
import 'package:home_inventory/screens/loginpage.dart';
import 'package:home_inventory/screens/splashscreen.dart';
import 'package:home_inventory/services.dart/auth.dart';
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
            value: AuthService(),
          ),
          ChangeNotifierProvider.value(
            value: ProviderInventory(),
          ),
        ],
        child: Consumer<AuthService>(
            builder: (ctx, auth, _) => MaterialApp(
                  debugShowCheckedModeBanner: false,
                  title: 'Home Inventory',
                  theme: ThemeData(
                    primarySwatch: Colors.blue,
                    visualDensity: VisualDensity.adaptivePlatformDensity,
                  ),
                  home: auth.isLoggedIn
                      ? MyHomePage(
                          title: "My Home Inventory",
                        )
                      : FutureBuilder(
                          future: auth.signInAutomatically(),
                          builder: (ctx, resultsnapshot) =>
                              resultsnapshot.connectionState ==
                                      ConnectionState.waiting
                                  ? SplashScreen()
                                  : LoginPage(),
                        ),
                  // initialRoute: "/",
                  routes: {
                    // "/": (ctx) => LoginPage(), //MyHomePage(title: 'Home Inventory'),
                    ScreenInventory.name: (ctx) => ScreenInventory(),
                    ScreenAddInventory.name: (ctx) => ScreenAddInventory()
                  },
                )));
  }
}
