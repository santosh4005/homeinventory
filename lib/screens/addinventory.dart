import 'package:flutter/material.dart';
import 'package:home_inventory/providers/inventoryprovider.dart';
import 'package:home_inventory/screens/inventory.dart';
import 'package:provider/provider.dart';

class ScreenAddInventory extends StatefulWidget {
  static const String name = "/addinventory";

  @override
  _ScreenAddInventoryState createState() => _ScreenAddInventoryState();
}

class _ScreenAddInventoryState extends State<ScreenAddInventory> {
  final _form = GlobalKey<FormState>();
  final _quantityFocusNode = FocusNode();
  final _shelfNameFocusNode = FocusNode();
  final _descriptionFocusNode = FocusNode();

  final _titleController = TextEditingController();
  final _quantityController = TextEditingController();
  final _shelfController = TextEditingController();
  final _descriptionController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold( 
      extendBodyBehindAppBar: true,
      appBar: AppBar(
        elevation: 0, 
        backgroundColor: Colors.transparent,
        title: Text("Add to Inventory"),
        actions: <Widget>[],
      ),
      body: Container(
          decoration: BoxDecoration(
      gradient: LinearGradient(
          colors: [Colors.purple, Colors.white],
          begin: Alignment.topRight,
          end: Alignment.bottomLeft)),
          child: Padding(
            padding: const EdgeInsets.all(10.0),
            child: Form(
      key: _form,
      child: SafeArea(
              child: Column(
          children: <Widget>[
            TextFormField(
              controller: _titleController,
              decoration: InputDecoration(labelText: "Name"),
              textInputAction: TextInputAction.next,
              keyboardType: TextInputType.text,
              onFieldSubmitted: (_) {
                FocusScope.of(context).requestFocus(_quantityFocusNode);
              },
              onSaved: (_) {},
            ),
            TextFormField(
              controller: _quantityController,
              decoration: InputDecoration(labelText: "Quantity"),
              textInputAction: TextInputAction.next,
              focusNode: _quantityFocusNode,
              keyboardType: TextInputType.number,
              onFieldSubmitted: (_) {
                FocusScope.of(context).requestFocus(_descriptionFocusNode);
              },
              onSaved: (_) {},
            ),
            TextFormField(
              controller: _descriptionController,
              decoration: InputDecoration(labelText: "Description"),
              textInputAction: TextInputAction.next,
              focusNode: _descriptionFocusNode,
              keyboardType: TextInputType.multiline,
              maxLines: 3,
              onFieldSubmitted: (_) {
                FocusScope.of(context).requestFocus(_shelfNameFocusNode);
              },
              onSaved: (_) {},
            ),
            TextFormField(
              controller: _shelfController,
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
                  onPressed: () async {
                    await Provider.of<ProviderInventory>(context,
                            listen: false)
                        .addInventory(
                            _titleController.text,
                            _shelfController.text,
                            _quantityController.text,
                            _descriptionController.text);
                    Navigator.of(context)
                        .pushReplacementNamed(ScreenInventory.name);
                  },
                ),
              ),
            )
          ],
        ),
      ),
            ),
          ),
        ),
    );
  }
}
