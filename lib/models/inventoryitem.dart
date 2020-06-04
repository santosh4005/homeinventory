import 'package:flutter/foundation.dart';

class ModelInventoryItem {
  final String id;
  final String title;
  final String description;
  final String quantity;
  final String shelfName;
  final String createdBy;

  ModelInventoryItem(
      {@required this.id,
      @required this.title,
      @required this.description,
      @required this.quantity,
      @required this.shelfName,
      @required this.createdBy});
}
