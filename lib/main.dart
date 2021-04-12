import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:home_inventory/providers/inventoryprovider.dart';
import 'package:home_inventory/providers/providerGoogleSignin.dart';
import 'package:home_inventory/screens/authscreen.dart';
import 'package:home_inventory/screens/splashscreen.dart';
import 'package:provider/provider.dart';
import './screens/myhomepage.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  final primaryColor = Colors.purple;
  final accentColor = Colors.pink;

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider<ProviderGoogleSignin>.value(
            value: ProviderGoogleSignin()),
        ChangeNotifierProvider.value(value: ProviderInventory()),
      ],
      child: MaterialApp(
        debugShowCheckedModeBanner: false,
        title: 'Home Inventory',
        theme: ThemeData(
          primarySwatch: primaryColor,
          backgroundColor: primaryColor,
          errorColor: Colors.white,
          accentColor: accentColor,
          // accentColorBrightness: Brightness.dark,
          buttonTheme: ButtonTheme.of(context).copyWith(
            buttonColor: Colors.white,
            textTheme: ButtonTextTheme.primary,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(20.0),
            ),
          ),
          visualDensity: VisualDensity.adaptivePlatformDensity,
        ),
        home: StreamBuilder(
          stream: FirebaseAuth.instance.authStateChanges(),
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
