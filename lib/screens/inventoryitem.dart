import 'package:flutter/material.dart';
import 'package:home_inventory/models/inventoryitem.dart';

class ScreenInventoryItem extends StatelessWidget {
  final ModelInventoryItem modelInventoryItem;

  ScreenInventoryItem({@required this.modelInventoryItem});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      extendBodyBehindAppBar: true,
      appBar: AppBar(
        elevation: 0,
        backgroundColor: Colors.transparent,
        title: Text(modelInventoryItem.title),
      ),
      body: Container(
          decoration: BoxDecoration(
              gradient: LinearGradient(
                  colors: [Theme.of(context).primaryColor, Colors.white],
                  begin: Alignment.topRight,
                  end: Alignment.bottomLeft)),
          child: SafeArea(
              child: Center(child: Text(modelInventoryItem.description)))),
    );
  }
}
