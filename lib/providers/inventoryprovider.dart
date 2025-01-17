import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/foundation.dart';
import 'package:home_inventory/models/inventoryitem.dart';
import 'package:home_inventory/models/user.dart';

class ProviderInventory with ChangeNotifier {
  List<ModelInventoryItem> _items = [];
  UserData _userData;

  List<ModelInventoryItem> get items {
    return [..._items];
  }

  void clearInventory() {
    _items.clear();
  }

  Future<void> fetchAndSetInventory({bool hardrefresh = false}) async {
    if (_items.length == 0 || hardrefresh) {
      var loggedInUser = FirebaseAuth.instance.currentUser;

      var inventory = await FirebaseFirestore.instance
          .collection("inventory")
          .where("createdBy", isEqualTo: loggedInUser.uid)
          .orderBy("createdOn", descending: true)
          .get();
      _items.clear();
      inventory.docs.forEach((element) {
        _items.add(ModelInventoryItem(
            tag: element.data()['tag'],
            createdBy: element.data()["createdBy"],
            description: element.data()["description"],
            id: element.id,
            quantity: element.data()["quantity"],
            shelfName: element.data()["shelfName"],
            title: element.data()["title"],
            imageUrl: element.data()["imageUrl"],
            createdOn: (element.data()["createdOn"] as Timestamp).toDate()));
      });
      notifyListeners();
    }
  }

  Future<UserData> fetchUserDetails() async {
    if (_userData == null) {
      var loggedInUser = FirebaseAuth.instance.currentUser;
      var currentUserDetials = await FirebaseFirestore.instance
          .collection("users")
          .doc(loggedInUser.uid)
          .get();

      _userData = UserData(
          imageurl: currentUserDetials.data()['imageurl'],
          name: currentUserDetials.data()['username'],
          uid: loggedInUser.uid);

      return _userData;
    }
  }

  Future<void> updateImage(
      ModelInventoryItem inventoryitem, File _inventoryImageFile) async {
    if (_inventoryImageFile != null) {
      var imgRef = FirebaseStorage.instance
          .ref()
          .child('inventory_image')
          .child(inventoryitem.id + '.jpg');

      await imgRef.putFile(_inventoryImageFile).whenComplete(() async {
        inventoryitem.imageUrl = await imgRef.getDownloadURL();
      });
      await FirebaseFirestore.instance
          .collection("inventory")
          .doc(inventoryitem.id)
          .update({
        "imageUrl": inventoryitem.imageUrl,
      });

      var iteminQuestion =
          _items.firstWhere((element) => element.id == inventoryitem.id);
      iteminQuestion.imageUrl = inventoryitem.imageUrl;
      notifyListeners();
    }
  }

  Future<void> updateInventory(ModelInventoryItem inventoryItem) async {
    if (inventoryItem.id.isNotEmpty) {
      await FirebaseFirestore.instance
          .collection("inventory")
          .doc(inventoryItem.id)
          .update({
        "tag": inventoryItem.tag,
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
      if (prodIndex != -1) _items[prodIndex] = inventoryItem;

      notifyListeners();
    }
  }

  Future<ModelInventoryItem> addInventory(String title, String shelfName,
      String quantity, String description, String tag) async {
    var loggedInUser = FirebaseAuth.instance.currentUser;

    var createdon = DateTime.now();

    var addedInventory =
        await FirebaseFirestore.instance.collection("inventory").add({
      "title": title,
      "shelfName": shelfName,
      "quantity": quantity,
      "description": description,
      "createdOn": createdon,
      "createdBy": loggedInUser.uid,
      "tag": tag,
    });

    var newInventoryItem = ModelInventoryItem(
      tag: tag,
      createdBy: loggedInUser.uid,
      description: description,
      quantity: quantity,
      shelfName: shelfName,
      title: title,
      createdOn: createdon,
      id: addedInventory.id,
    );

    _items.add(newInventoryItem);
    notifyListeners();
    return newInventoryItem;
  }

  Future<void> removeItemFromInventory(int index) async {
    final id = _items[index].id;
    await FirebaseFirestore.instance.collection("inventory").doc(id).delete();
    if (_items[index].imageUrl != null && _items[index].imageUrl.isNotEmpty)
      await FirebaseStorage.instance
          .ref()
          .child('inventory_image')
          .child(id + '.jpg')
          .delete();

    _items.removeAt(index);
    notifyListeners();
  }
}
