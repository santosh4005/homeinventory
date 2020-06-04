import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/foundation.dart';
import 'package:home_inventory/models/inventoryitem.dart';

class ProviderInventory with ChangeNotifier {
  List<ModelInventoryItem> _items = [
    // ModelInventoryItem(
    //     id: "1",
    //     title: 'test title 1',
    //     description: 'test description 1',
    //     quantity: 1,
    //     shelfName: 'test shelfname 1'),
    // ModelInventoryItem(
    //     id: "2",
    //     title: 'test title 2',
    //     description: 'test description 2',
    //     quantity: 2,
    //     shelfName: 'test shelfname 2'),
    // ModelInventoryItem(
    //     id: "3",
    //     title: 'test title 3',
    //     description: 'test description 3',
    //     quantity: 3,
    //     shelfName: 'test shelfname 3'),
    // ModelInventoryItem(
    //     id: "4",
    //     title: 'test title 4',
    //     description: 'test description 4',
    //     quantity: 4,
    //     shelfName: 'test shelfname 4'),
  ];

  List<ModelInventoryItem> get items {
    return [..._items];
  }

  Future<void> fetchAndSetInventory() async {
    if (_items.length == 0) {
      var loggedInUser = await FirebaseAuth.instance.currentUser();

      var inventory = await Firestore.instance
          .collection("inventory")
          .where("createdBy", isEqualTo: loggedInUser.uid)
          .orderBy("createdOn", descending: true)
          .getDocuments();

      inventory.documents.forEach((element) {
        _items.add(ModelInventoryItem(
            createdBy: element.data["createdBy"],
            description: element.data["description"],
            id: element.documentID,
            quantity: element.data["quantity"],
            shelfName: element.data["shelfName"],
            title: element.data["title"],
            imageUrl: element.data["imageUrl"],
            createdOn: (element.data["createdOn"] as Timestamp).toDate()));
      });
      notifyListeners();
    }
  }

  Future<void> updateInventory(ModelInventoryItem inventoryItem) async {
    if (inventoryItem.id.isNotEmpty) {
      await Firestore.instance
          .collection("inventory")
          .document(inventoryItem.id)
          .setData({
        "title": inventoryItem.title,
        "shelfName": inventoryItem.shelfName,
        "quantity": inventoryItem.quantity,
        "description": inventoryItem.description,
        "createdOn": inventoryItem.createdOn,
        "createdBy": inventoryItem.createdBy,
        "imageUrl": inventoryItem.imageUrl,
      });

      final prodIndex =
          _items.indexWhere((prod) => prod.id == inventoryItem.id);
      _items[prodIndex] = inventoryItem;
    }
  }

  Future<ModelInventoryItem> addInventory(String title, String shelfName,
      String quantity, String description) async {
    var loggedInUser = await FirebaseAuth.instance.currentUser();

    var createdon = DateTime.now();

    var addedInventory = await Firestore.instance.collection("inventory").add({
      "title": title,
      "shelfName": shelfName,
      "quantity": quantity,
      "description": description,
      "createdOn": createdon,
      "createdBy": loggedInUser.uid,
    });

    var newInventoryItem = ModelInventoryItem(
      createdBy: loggedInUser.uid,
      description: description,
      quantity: quantity,
      shelfName: shelfName,
      title: title,
      createdOn: createdon,
      id: addedInventory.documentID,
    );

    _items.add(newInventoryItem);
    notifyListeners();
    return newInventoryItem;
  }

  void removeItemFromInventory(int index) {
    _items.removeAt(index);
    notifyListeners();
  }
}
