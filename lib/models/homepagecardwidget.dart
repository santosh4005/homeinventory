import 'package:flutter/material.dart';

class HomePageCardWidget {
  final Icon icon;
  final int totalInventory;
  final String name;
  final String description;
  final String tag;

  HomePageCardWidget({
    @required this.icon,
    @required this.totalInventory,
    @required this.name,
    @required this.description,
    @required this.tag,
  });
}
