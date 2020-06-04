import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:home_inventory/models/inventoryitem.dart';
import 'package:home_inventory/providers/inventoryprovider.dart';
import 'package:home_inventory/screens/inventory.dart';
import 'package:home_inventory/widgets/inventoryimagepicker.dart';
import 'package:provider/provider.dart';
import 'dart:io';

class ScreenAddInventory extends StatefulWidget {
  final bool isEditMode;
  final ModelInventoryItem editItem;
  ScreenAddInventory({this.isEditMode, this.editItem});

  static const String name = "/addinventory";

  @override
  _ScreenAddInventoryState createState() => _ScreenAddInventoryState();
}

class _ScreenAddInventoryState extends State<ScreenAddInventory> {
  final _form = GlobalKey<FormState>();
  final _quantityFocusNode = FocusNode();
  final _shelfNameFocusNode = FocusNode();
  final _descriptionFocusNode = FocusNode();
  File _inventoryImageFile;
  String _imageUrl = "";

  final _titleController = TextEditingController();
  final _quantityController = TextEditingController();
  final _shelfController = TextEditingController();
  final _descriptionController = TextEditingController();

  @override
  void initState() {
    super.initState();
    if (widget.isEditMode) {
      _titleController.text = widget.editItem.title;
      _quantityController.text = widget.editItem.quantity;
      _shelfController.text = widget.editItem.shelfName;
      _descriptionController.text = widget.editItem.description;
      _imageUrl = widget.editItem == null ? "" : widget.editItem.imageUrl;
    }
  }

  void _pickImage(File pickedImage) {
    _inventoryImageFile = pickedImage;
  }

  Future<void> _updateImage(ModelInventoryItem inventoryitem) async {
    if (_inventoryImageFile != null) {
      var imgRef = FirebaseStorage.instance
          .ref()
          .child('inventory_image')
          .child(inventoryitem.id + '.jpg');

      await imgRef.putFile(_inventoryImageFile).onComplete;

      inventoryitem.imageUrl = await imgRef.getDownloadURL();
      await Provider.of<ProviderInventory>(context, listen: false)
          .updateInventory(inventoryitem);
    }
  }

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
        padding: EdgeInsets.all(10.0),
        decoration: BoxDecoration(
            gradient: LinearGradient(
                colors: [Theme.of(context).primaryColor, Colors.white],
                begin: Alignment.topRight,
                end: Alignment.bottomLeft)),
        child: SafeArea(
          child: Column(
            children: <Widget>[
              Expanded(
                child: SingleChildScrollView(
                  child: Form(
                    key: _form,
                    child: Column(
                      children: <Widget>[
                        TextFormField(
                          controller: _titleController,
                          decoration: InputDecoration(labelText: "Name"),
                          textInputAction: TextInputAction.next,
                          keyboardType: TextInputType.text,
                          onFieldSubmitted: (_) {
                            FocusScope.of(context)
                                .requestFocus(_quantityFocusNode);
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
                            FocusScope.of(context)
                                .requestFocus(_descriptionFocusNode);
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
                            FocusScope.of(context)
                                .requestFocus(_shelfNameFocusNode);
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
                        SizedBox(
                          height: 10.0,
                        ),
                        InventoryImagePicker(_pickImage, _imageUrl),
                        Center(
                          child: Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: RaisedButton(
                              child: Text("Submit"),
                              onPressed: () async {
                                if (widget.editItem == null) {
                                  var inventoryitem =
                                      await Provider.of<ProviderInventory>(
                                              context,
                                              listen: false)
                                          .addInventory(
                                              _titleController.text,
                                              _shelfController.text,
                                              _quantityController.text,
                                              _descriptionController.text);
                                  if (inventoryitem != null &&
                                      _inventoryImageFile != null) {
                                    await _updateImage(inventoryitem);
                                  }
                                } else {
                                  await _updateImage(widget.editItem);
                                  await Provider.of<ProviderInventory>(context,
                                          listen: false)
                                      .updateInventory(ModelInventoryItem(
                                    id: widget.editItem.id,
                                    quantity: _quantityController.text,
                                    description: _descriptionController.text,
                                    shelfName: _shelfController.text,
                                    title: _titleController.text,
                                    createdBy: widget.editItem.createdBy,
                                    createdOn: widget.editItem.createdOn,
                                    imageUrl: widget.editItem.imageUrl,
                                  ));
                                }

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
            ],
          ),
        ),
      ),
    );
  }
}
