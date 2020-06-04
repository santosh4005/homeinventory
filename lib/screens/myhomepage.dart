import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:home_inventory/providers/inventoryprovider.dart';
import 'package:home_inventory/screens/addinventory.dart';
import 'package:home_inventory/screens/inventory.dart';
import 'package:provider/provider.dart';

class MyHomePage extends StatefulWidget {
  MyHomePage({Key key, this.title}) : super(key: key);

  final String title;

  @override
  _MyHomePageState createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      extendBodyBehindAppBar: true,
      appBar: AppBar(
        title: Text(widget.title),
        backgroundColor: Colors.transparent,
         elevation: 0,
      ),
      drawer: Drawer(
        child: Column(
          children: <Widget>[
            AppBar(
              title: Text("Menu"),
              automaticallyImplyLeading: false,
            ),
            ListTile(
              leading: CircleAvatar(
                child: Icon(Icons.supervised_user_circle),
              ),
              title: Text("Logout"),
              onTap: () {
                Navigator.of(context).pop();
                FirebaseAuth.instance.signOut();
              },
            )
          ],
        ),
      ),
      body: Container(
        decoration: BoxDecoration(
            gradient: LinearGradient(
                colors: [ Colors.purple, Colors.white],
                begin: Alignment.topRight,
                end: Alignment.bottomLeft)),
        child: SafeArea(
                  child: Padding(
            padding: EdgeInsets.all(20.0),
            child: GridView(
              gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: 3,
                  childAspectRatio: 3 / 2,
                  crossAxisSpacing: 10.0,
                  mainAxisSpacing: 10.0),
              children: <Widget>[
                InkWell(
                  child: Container(
                    color: Colors.grey,
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: <Widget>[
                        Icon(Icons.list),
                        Text("My Inventory!"),
                      ],
                    ),
                  ),
                  onTap: () {
                    Navigator.of(context).pushNamed(ScreenInventory.name);
                  },
                ),
              ],
            ),
          ),
        ),
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerFloat,
      floatingActionButton: FloatingActionButton(
        onPressed: () =>
            {Navigator.of(context).pushNamed(ScreenAddInventory.name)},
        tooltip: 'Increment',
        child: Icon(Icons.add),
      ),
    );
  }
}
