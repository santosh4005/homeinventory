import 'package:flutter/material.dart';
import 'package:home_inventory/models/inventoryitem.dart';
import 'package:home_inventory/providers/inventoryprovider.dart';
import 'package:home_inventory/screens/inventory.dart';
import 'package:provider/provider.dart';
import '../widgets/maindrawer.dart';
import '../models/homepagecardwidget.dart';

class MyHomePage extends StatefulWidget {
  MyHomePage({Key key, this.title}) : super(key: key);

  final String title;

  @override
  _MyHomePageState createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  List<ModelInventoryItem> inventoryItems = [];

  var _isInit = true;
  var _isLoading = false;

  @override
  void didChangeDependencies() async {
    if (_isInit) {
      setState(() {
        _isLoading = true;
      });
      await Provider.of<ProviderInventory>(context, listen: false)
          .fetchAndSetInventory();
      if (!mounted) return;
      setState(() {
        _isLoading = false;
      });
    }
    _isInit = false;
    super.didChangeDependencies();
  }

  List<Widget> _getListOfCards() {
    var listofcards = [
      HomePageCardWidget(
          name: "Full Inventory",
          description: "Everything Inventory",
          icon: Icon(
            Icons.playlist_add,
            size: 70,
            color: Theme.of(context).primaryColor,
          ),
          tag: "",
          totalInventory: inventoryItems.length),
      HomePageCardWidget(
          name: "Basement Inventory",
          description: "Basement Inventory",
          icon: Icon(
            Icons.home,
            size: 70,
            color: Theme.of(context).primaryColor,
          ),
          tag: "Basement",
          totalInventory: inventoryItems
              .where((element) => element.tag == "Basement")
              .length),
      HomePageCardWidget(
          name: "Bed Room Inventory",
          description: "Bed Room Inventory",
          icon: Icon(
            Icons.airline_seat_individual_suite,
            size: 70,
            color: Theme.of(context).primaryColor,
          ),
          tag: "Bed Room",
          totalInventory: inventoryItems
              .where((element) => element.tag == "Bed Room")
              .length),
      HomePageCardWidget(
          name: "Garage Inventory",
          description: "Garage Inventory",
          icon: Icon(
            Icons.directions_car,
            size: 70,
            color: Theme.of(context).primaryColor,
          ),
          tag: "Garage",
          totalInventory: inventoryItems
              .where((element) => element.tag == "Garage")
              .length),
      HomePageCardWidget(
          name: "Kitchen Inventory",
          description: "Kitchen Inventory",
          icon: Icon(
            Icons.local_dining,
            size: 70,
            color: Theme.of(context).primaryColor,
          ),
          tag: "Kitchen",
          totalInventory: inventoryItems
              .where((element) => element.tag == "Kitchen")
              .length),
      HomePageCardWidget(
          name: "Kitchen Office Inventory",
          description: "Kitchen Office Inventory",
          icon: Icon(
            Icons.restaurant,
            size: 70,
            color: Theme.of(context).primaryColor,
          ),
          tag: "Kitchen Office",
          totalInventory: inventoryItems
              .where((element) => element.tag == "Kitchen Office")
              .length),
      HomePageCardWidget(
          name: "Laundry Room Inventory",
          description: "Laundry Room Inventory",
          icon: Icon(
            Icons.home,
            size: 70,
            color: Theme.of(context).primaryColor,
          ),
          tag: "Laundry Room",
          totalInventory: inventoryItems
              .where((element) => element.tag == "Laundry Room")
              .length),
      HomePageCardWidget(
          name: "Living Room Inventory",
          description: "Living Room Inventory",
          icon: Icon(
            Icons.tv,
            size: 70,
            color: Theme.of(context).primaryColor,
          ),
          tag: "Living Room",
          totalInventory: inventoryItems
              .where((element) => element.tag == "Living Room")
              .length),
      HomePageCardWidget(
          name: "Office Inventory",
          description: "Office Inventory",
          icon: Icon(
            Icons.work,
            size: 70,
            color: Theme.of(context).primaryColor,
          ),
          tag: "Office",
          totalInventory: inventoryItems
              .where((element) => element.tag == "Office")
              .length),
      HomePageCardWidget(
          name: "Miscelleneous Inventory",
          description: "Miscelleneous Inventory",
          icon: Icon(
            Icons.assignment,
            size: 70,
            color: Theme.of(context).primaryColor,
          ),
          tag: "Miscelleneous",
          totalInventory: inventoryItems
              .where((element) => element.tag == "Miscelleneous")
              .length),
    ];
    listofcards.sort((a, b) => b.totalInventory.compareTo(a.totalInventory));

    var result = listofcards
        .map((e) => _getCard(
            name: e.name,
            icon: e.icon,
            smallDescription: e.description,
            totalTagItemslength: e.totalInventory,
            tag: e.tag))
        .toList();

    return result;
  }

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
      body: _isLoading
          ? Center(
              child: CircularProgressIndicator(
                backgroundColor: Colors.white,
              ),
            )
          : Container(
              decoration: BoxDecoration(
                  gradient: LinearGradient(colors: [
                Theme.of(context).primaryColor,
                Theme.of(context).accentColor,
              ], begin: Alignment.topRight, end: Alignment.bottomLeft)),
              child: SafeArea(
                child: Padding(
                  padding: EdgeInsets.symmetric(horizontal: 20.0),
                  child: ListView(
                    children: _getListOfCards(),
                  ),
                ),
              ),
            ),
    );
  }

  Widget _getCard(
      {String name,
      String smallDescription,
      int totalTagItemslength,
      Icon icon,
      String tag}) {
    return Card(
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(15.0),
      ),
      color: Colors.white,
      elevation: 10,
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: <Widget>[
          ListTile(
            trailing: totalTagItemslength > 0
                ? Text(
                    totalTagItemslength.toString(),
                    style: TextStyle(
                        fontSize: 20.0,
                        fontWeight: FontWeight.bold,
                        color: Theme.of(context).primaryColor),
                  )
                : null,
            leading: icon,
            title: Text(name,
                style: TextStyle(color: Theme.of(context).primaryColor)),
            subtitle: Text(smallDescription,
                style: TextStyle(color: Theme.of(context).primaryColor)),
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
