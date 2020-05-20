import 'package:flutter/material.dart';

class ScreenAddInventory extends StatefulWidget {
  static const String name = "/addinventory";

  @override
  _ScreenAddInventoryState createState() => _ScreenAddInventoryState();
}

class _ScreenAddInventoryState extends State<ScreenAddInventory> {
  final _form = GlobalKey<FormState>();
  final _quantityFocusNode = FocusNode();
  final _shelfNameFocusNode = FocusNode();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Add to Inventory"),
      ),
      body: Padding(
        padding: const EdgeInsets.all(10.0),
        child: Form(
          key: _form,
          child: Column(
            children: <Widget>[
              TextFormField(
                decoration: InputDecoration(labelText: "Name"),
                textInputAction: TextInputAction.next,
                keyboardType: TextInputType.text,
                onFieldSubmitted: (_) {
                  FocusScope.of(context).requestFocus(_quantityFocusNode);
                },
                onSaved: (_) {},
              ),
              TextFormField(
                decoration: InputDecoration(labelText: "Quantity"),
                textInputAction: TextInputAction.next,
                focusNode: _quantityFocusNode,
                keyboardType: TextInputType.number,
                onFieldSubmitted: (_) {
                  FocusScope.of(context).requestFocus(_shelfNameFocusNode);
                },
                onSaved: (_) {},
              ),
              TextFormField(
                decoration: InputDecoration(labelText: "Shelf Name"),
                textInputAction: TextInputAction.done,
                focusNode: _shelfNameFocusNode,
                keyboardType: TextInputType.text,
                onFieldSubmitted: (_) {
                  showDialog(
                      context: context,
                      child: AlertDialog(
                        actions: <Widget>[
                          RaisedButton(
                            child: Text("OK"),
                            onPressed: () {
                              Navigator.of(context).pop();
                            },
                          ),
                        ],
                      ));
                },
                onSaved: (_) {},
              ),
              Center(
                child: Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: RaisedButton(
                    child: Text("Submit"),
                    onPressed: null,
                  ),
                ),
              )
            ],
          ),
        ),
      ),
    );
  }
}
