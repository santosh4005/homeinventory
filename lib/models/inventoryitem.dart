import 'package:flutter/foundation.dart';

class ModelInventoryItem {
  final String id;
  final String title;
  final String description;
  final String quantity;
  final String shelfName;
  final DateTime createdOn;
  final String createdBy;
  String imageUrl;

  ModelInventoryItem({
    this.id,
    @required this.title,
    @required this.description,
    @required this.quantity,
    @required this.shelfName,
    this.createdBy,
    this.createdOn,
    this.imageUrl,
  });
}
