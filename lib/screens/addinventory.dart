import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:home_inventory/models/inventoryitem.dart';
import 'package:home_inventory/providers/inventoryprovider.dart';
import 'package:home_inventory/widgets/inventoryimagepicker.dart';
import 'package:provider/provider.dart';
import 'dart:io';

class ScreenAddInventory extends StatefulWidget {
  final bool isEditMode;
  final ModelInventoryItem editItem;
  final String tagValue;
  ScreenAddInventory({this.isEditMode, this.editItem, this.tagValue});

  // static const String name = "/addinventory";

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
  bool _isSubmitting = false;

  final _titleController = TextEditingController();
  final _quantityController = TextEditingController();
  final _shelfController = TextEditingController();
  final _descriptionController = TextEditingController();
  String _currentTagValue = "";

  @override
  void initState() {
    super.initState();
    if (widget.isEditMode) {
      _titleController.text = widget.editItem.title;
      _quantityController.text = widget.editItem.quantity;
      _shelfController.text = widget.editItem.shelfName;
      _descriptionController.text = widget.editItem.description;
      _imageUrl = widget.editItem == null ? "" : widget.editItem.imageUrl;
      _currentTagValue = widget.editItem.tag;
    } else {
      _currentTagValue = widget.tagValue == "" ? "Generic" : widget.tagValue;
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

      await imgRef.putFile(_inventoryImageFile).whenComplete(() async {
        inventoryitem.imageUrl = await imgRef.getDownloadURL();
      });

      await Provider.of<ProviderInventory>(context, listen: false)
          .updateInventory(inventoryitem);
    }
  }

  Future<void> _submitForm() async {
    final isValid = _form.currentState.validate();
    FocusScope.of(context).unfocus();
    if (isValid) {
      var provider = Provider.of<ProviderInventory>(context, listen: false);
      setState(() {
        _isSubmitting = true;
      });
      if (widget.editItem == null) {
        var inventoryitem = await provider.addInventory(
            _titleController.text,
            _shelfController.text,
            _quantityController.text,
            _descriptionController.text,
            _currentTagValue);
        if (inventoryitem != null && _inventoryImageFile != null) {
          await provider.updateImage(inventoryitem, _inventoryImageFile);
        }
      } else {
        await provider.updateImage(widget.editItem, _inventoryImageFile);
        await provider.updateInventory(ModelInventoryItem(
          id: widget.editItem.id,
          tag: _currentTagValue,
          quantity: _quantityController.text,
          description: _descriptionController.text,
          shelfName: _shelfController.text,
          title: _titleController.text,
          createdBy: widget.editItem.createdBy,
          createdOn: widget.editItem.createdOn,
          imageUrl: widget.editItem.imageUrl,
        ));
      }
      Navigator.of(context).pop();
      // Navigator.of(context).pushReplacementNamed(ScreenInventory.name);s
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
            gradient: LinearGradient(colors: [
          Theme.of(context).primaryColor,
          Theme.of(context).accentColor
        ], begin: Alignment.topRight, end: Alignment.bottomLeft)),
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
                          textCapitalization: TextCapitalization.sentences,
                          controller: _titleController,
                          style: TextStyle(color: Colors.white),
                          decoration: InputDecoration(
                              labelText: "Name",
                              labelStyle: TextStyle(
                                  color: Colors.white,
                                  fontStyle: FontStyle.italic)),
                          textInputAction: TextInputAction.next,
                          keyboardType: TextInputType.text,
                          validator: (value) {
                            print("----------------->" + value);
                            if (value.isEmpty) {
                              return "* Please don't leave me empty";
                            }
                            return null;
                          },
                          onFieldSubmitted: (_) {
                            FocusScope.of(context)
                                .requestFocus(_quantityFocusNode);
                          },
                          onSaved: (_) {},
                        ),
                        TextFormField(
                          style: TextStyle(color: Colors.white),
                          controller: _quantityController,
                          decoration: InputDecoration(
                              labelText: "Quantity",
                              labelStyle: TextStyle(
                                  color: Colors.white,
                                  fontStyle: FontStyle.italic)),
                          textInputAction: TextInputAction.next,
                          focusNode: _quantityFocusNode,
                          keyboardType: TextInputType.number,
                          onFieldSubmitted: (_) {
                            FocusScope.of(context)
                                .requestFocus(_descriptionFocusNode);
                          },
                          validator: (value) {
                            if (value.isEmpty) {
                              return "* Please don't leave me empty";
                            }
                            return null;
                          },
                          onSaved: (_) {},
                        ),
                        TextFormField(
                          style: TextStyle(color: Colors.white),
                          textCapitalization: TextCapitalization.sentences,
                          controller: _descriptionController,
                          decoration: InputDecoration(
                              labelText: "Description",
                              labelStyle: TextStyle(
                                  color: Colors.white,
                                  fontStyle: FontStyle.italic)),
                          textInputAction: TextInputAction.next,
                          focusNode: _descriptionFocusNode,
                          keyboardType: TextInputType.multiline,
                          maxLines: 3,
                          onFieldSubmitted: (_) {
                            FocusScope.of(context)
                                .requestFocus(_shelfNameFocusNode);
                          },
                          validator: (value) {
                            if (value.isEmpty) {
                              return "* Please don't leave me empty";
                            }
                            return null;
                          },
                          onSaved: (_) {},
                        ),
                        TextFormField(
                          style: TextStyle(color: Colors.white),
                          textCapitalization: TextCapitalization.sentences,
                          controller: _shelfController,
                          decoration: InputDecoration(
                              labelText: "Shelf Name",
                              labelStyle: TextStyle(
                                  color: Colors.white,
                                  fontStyle: FontStyle.italic)),
                          textInputAction: TextInputAction.done,
                          focusNode: _shelfNameFocusNode,
                          keyboardType: TextInputType.text,
                          validator: (value) {
                            if (value.isEmpty) {
                              return "* Please don't leave me empty";
                            }
                            return null;
                          },
                          onFieldSubmitted: (_) {
                            FocusScope.of(context).unfocus();
                          },
                          onSaved: (_) {},
                        ),
                        SizedBox(
                          height: 10.0,
                        ),
                        Theme(
                          data: Theme.of(context).copyWith(
                            canvasColor: Theme.of(context).primaryColor,
                          ),
                          child: DropdownButtonFormField(
                            style: TextStyle(color: Colors.white),
                            items: _getDropdownList(),
                            value: _currentTagValue,
                            onChanged: (value) {
                              setState(() {
                                _currentTagValue = value;
                              });
                            },
                          ),
                        ),
                        SizedBox(
                          height: 10.0,
                        ),
                        InventoryImagePicker(_pickImage, _imageUrl),
                        Center(
                          child: Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: _isSubmitting
                                ? CircularProgressIndicator()
                                : RaisedButton(
                                    child: Text("Submit"),
                                    onPressed: _submitForm,
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

  List<DropdownMenuItem> _getDropdownList() {
    final tagOptions = [
      "Basement",
      "Bed Room",
      "Generic",
      "Garage",
      "Kitchen",
      "Kitchen Office",
      "Laundry Room",
      "Living Room",
      "Miscelleneous",
      "Office",
    ];
    return tagOptions
        .map((e) => DropdownMenuItem(
              child: Text(e),
              value: e,
            ))
        .toList();
  }
}
