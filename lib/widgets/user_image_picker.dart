import 'dart:io';

import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';

class UserImagePicker extends StatefulWidget {
  UserImagePicker(this.pickedImageFn);
  final void Function(File pickedImage) pickedImageFn;
  @override
  _UserImagePickerState createState() => _UserImagePickerState();
}

class _UserImagePickerState extends State<UserImagePicker> {
  File _pickedImage;

  void _pickImage() {
    showDialog(
      context: context,
      builder: (ctx) {
        return AlertDialog(
          content: Text(
            'Please choose picking method',
          ),
          actions: [
            TextButton(
              onPressed: () async {
                final _pickedImageFile =
                    await ImagePicker.pickImage(source: ImageSource.gallery);
                setState(() {
                  _pickedImage = _pickedImageFile;
                });

                widget.pickedImageFn(_pickedImageFile);
                Navigator.of(ctx).pop();
              },
              child: Text('Gallery'),
            ),
            TextButton(
              onPressed: () async {
                final _pickedImageFile = await ImagePicker.pickImage(
                  source: ImageSource.camera,
                  imageQuality: 50,
                  maxWidth: 150,
                );
                setState(() {
                  _pickedImage = _pickedImageFile;
                });

                widget.pickedImageFn(_pickedImageFile);
                Navigator.of(ctx).pop();
              },
              child: Text('Camera'),
            ),
          ],
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        CircleAvatar(
          radius: 40,
          backgroundColor: Colors.grey,
          backgroundImage:
              _pickedImage != null ? FileImage(_pickedImage) : null,
        ),
        TextButton.icon(
          style: ButtonStyle(
            foregroundColor:
                MaterialStateProperty.all(Theme.of(context).primaryColor),
          ),
          onPressed: _pickImage,
          icon: Icon(Icons.image),
          label: Text('Pick an Image'),
        ),
      ],
    );
  }
}
