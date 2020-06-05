import 'package:flutter/material.dart';
import 'package:home_inventory/models/inventoryitem.dart';
import 'package:home_inventory/providers/inventoryprovider.dart';
import 'package:home_inventory/screens/inventory.dart';
import 'package:provider/provider.dart';
import '../widgets/maindrawer.dart';

class MyHomePage extends StatefulWidget {
  MyHomePage({Key key, this.title}) : super(key: key);

  final String title;

  @override
  _MyHomePageState createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  List<ModelInventoryItem> inventoryItems = [];

  @override
  Widget build(BuildContext context) {
    inventoryItems = Provider.of<ProviderInventory>(context).items;

    return Scaffold(
      extendBodyBehindAppBar: true,
      appBar: AppBar(
        title: Text(widget.title),
        backgroundColor: Colors.transparent,
        elevation: 0,
      ),
      drawer: MainDrawer(),
      body: Container(
        decoration: BoxDecoration(
            gradient: LinearGradient(colors: [
          Theme.of(context).primaryColor,
          Colors.white,
        ], begin: Alignment.topRight, end: Alignment.bottomLeft)),
        child: SafeArea(
          child: Padding(
            padding: EdgeInsets.symmetric(horizontal: 20.0),
            child: ListView(
              children: <Widget>[
                _getCard(
                    name: "Full Inventory",
                    smallDescription: "Everything",
                    icon: Icon(
                      Icons.playlist_add,
                      size: 70,
                    ),
                    tag: ""),
                _getCard(
                  name: "Garage Inventory",
                  smallDescription: "Everything from Garage",
                  tag: "Garage",
                  icon: Icon(
                    Icons.directions_car,
                    size: 70,
                  ),
                ),
                _getCard(
                    icon: Icon(
                      Icons.local_dining,
                      size: 70,
                    ),
                    name: "Kitchen Inventory",
                    smallDescription: "Everything from Kitchen",
                    tag: "Kitchen"),
                _getCard(
                    icon: Icon(
                      Icons.work,
                      size: 70,
                    ),
                    name: "Office Inventory",
                    smallDescription: "Everything from Office",
                    tag: "Office"),
                _getCard(
                    icon: Icon(
                      Icons.airline_seat_individual_suite,
                      size: 70,
                    ),
                    name: "Bed Room Inventory",
                    smallDescription: "Everything from Bed Room",
                    tag: "Bed Room"),
                _getCard(
                    icon: Icon(
                      Icons.home,
                      size: 70,
                    ),
                    name: "Basement Inventory",
                    smallDescription: "Everything from Basement",
                    tag: "Basement"),
                _getCard(
                    icon: Icon(
                      Icons.tv,
                      size: 70,
                    ),
                    name: "Living Room Inventory",
                    smallDescription: "Everything from Living Room",
                    tag: "Living Room"),
                _getCard(
                    icon: Icon(
                      Icons.restaurant,
                      size: 70,
                    ),
                    name: "Kitchen Office Inventory",
                    smallDescription: "Everything from Kitchen Office",
                    tag: "Kitchen Office"),
                _getCard(
                    icon: Icon(
                      Icons.assignment,
                      size: 70,
                    ),
                    name: "Miscelleneous Inventory",
                    smallDescription: "Everything Miscelleneous",
                    tag: "Miscelleneous"),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _getCard(
      {String name, String smallDescription, String tag, Icon icon}) {
    var totalTagItems = [];
    if (tag == "") {
      totalTagItems = inventoryItems;
    } else {
      totalTagItems =
          inventoryItems.where((element) => element.tag == tag).toList();
    }

    return Card(
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(15.0),
      ),
      color: Theme.of(context).primaryColor,
      elevation: 10,
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: <Widget>[
          ListTile(
            trailing: totalTagItems.length > 0
                ? Text(
                    totalTagItems.length.toString(),
                    style: TextStyle(
                        fontSize: 20.0,
                        fontWeight: FontWeight.bold,
                        color: Colors.white),
                  )
                : null,
            leading: icon,
            title: Text(name, style: TextStyle(color: Colors.white)),
            subtitle:
                Text(smallDescription, style: TextStyle(color: Colors.white)),
            onTap: () {
              Navigator.of(context).push(
                MaterialPageRoute(
                  builder: (context) => ScreenInventory(tag),
                ),
              );
            },
          ),
          SizedBox(
            height: 10.0,
          )
        ],
      ),
    );
  }
}
