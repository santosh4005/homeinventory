import 'package:flutter/foundation.dart';

class ModelInventoryItem {
  final String id;
  final String title;
  final String description;
  final double quantity;
  final String shelfName;

  ModelInventoryItem(
      {@required this.id,
      @required this.title,
      @required this.description,
      @required this.quantity,
      @required this.shelfName});
}
