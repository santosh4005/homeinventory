import 'package:flutter/material.dart';
import 'package:home_inventory/models/inventoryitem.dart';

class ScreenInventoryItem extends StatelessWidget {
  final ModelInventoryItem modelInventoryItem;

  ScreenInventoryItem({@required this.modelInventoryItem});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(modelInventoryItem.title),
      ),
      body: Center(child: Text(modelInventoryItem.description)),
    );
  }
}
