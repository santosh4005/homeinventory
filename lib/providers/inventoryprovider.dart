import 'package:flutter/foundation.dart';
import 'package:home_inventory/models/inventoryitem.dart';

class ProviderInventory with ChangeNotifier {
  List<ModelInventoryItem> _items = [
    ModelInventoryItem(
        id: "1",
        title: 'test title 1',
        description: 'test description 1',
        quantity: 1,
        shelfName: 'test shelfname 1'),
    ModelInventoryItem(
        id: "2",
        title: 'test title 2',
        description: 'test description 2',
        quantity: 2,
        shelfName: 'test shelfname 2'),
    ModelInventoryItem(
        id: "3",
        title: 'test title 3',
        description: 'test description 3',
        quantity: 3,
        shelfName: 'test shelfname 3'),
    ModelInventoryItem(
        id: "4",
        title: 'test title 4',
        description: 'test description 4',
        quantity: 4,
        shelfName: 'test shelfname 4'),
  ];

  List<ModelInventoryItem> get items{
    return [..._items];
  }

  void removeItemFromInventory(int index){
    _items.removeAt(index);
    notifyListeners();
  }
}
