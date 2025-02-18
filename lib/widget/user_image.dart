import 'dart:io';

import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';

class UserImage extends StatefulWidget {
  const UserImage({super.key});

  @override
  _UserImageState createState() => _UserImageState();
}

class _UserImageState extends State<UserImage> {
  File? _pickimagefile;
  void _pickimage() async {
    final XFile? pickedimage = await ImagePicker().pickImage(
      source: ImageSource.camera,
      maxWidth: 150,
      imageQuality: 50,
    );
    if (pickedimage == null) {
      return;
    }
    setState(() {
      _pickimagefile = File(pickedimage.path);
    });
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        CircleAvatar(
          radius: 40,
          backgroundColor: Colors.grey,
          backgroundImage:
              _pickimagefile == null ? null : FileImage(_pickimagefile!),
        ),
        TextButton.icon(
          onPressed: _pickimage,
          label: Text(
            'add image',
            style: TextStyle(
              color: Theme.of(context).primaryColor,
            ),
          ),
          icon: const Icon(Icons.image),
        )
      ],
    );
  }
}
