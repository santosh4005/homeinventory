import 'package:flutter/material.dart';
import 'dart:io';

import 'package:image_picker/image_picker.dart';

class InventoryImagePicker extends StatefulWidget {
  final String imageUrl;
  final Function(File pickedImage) imagePickFn;
  InventoryImagePicker(this.imagePickFn, this.imageUrl);

  @override
  _InventoryImagePickerState createState() => _InventoryImagePickerState();
}

class _InventoryImagePickerState extends State<InventoryImagePicker> {
  File _image;
  final imagePicker = ImagePicker();

  void _pickImage() async {
    final pickedFile = await imagePicker.getImage(
      source: ImageSource.camera,
      imageQuality: 50,
      maxWidth: 150,
    );
    if (pickedFile != null) {
      setState(() {
        _image = File(pickedFile.path);
      });

      widget.imagePickFn(_image);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Row(
      children: <Widget>[
        CircleAvatar(
          radius: 60,
          backgroundColor: Colors.grey,
          backgroundImage: _image != null
              ? FileImage(_image)
              : widget.imageUrl == null || widget.imageUrl.isEmpty
                  ? AssetImage('assets/images/original.png')
                  : NetworkImage(widget.imageUrl),
        ),
        FlatButton.icon(
          textColor: Theme.of(context).primaryColor,
          onPressed: _pickImage,
          icon: Icon(
            Icons.image,
            color: Colors.white,
          ),
          label: Text(
            "Add Image",
            style: TextStyle(color: Colors.white),
          ),
        ),
      ],
    );
  }
}
