import 'dart:io';

import 'package:flutter/material.dart';

class UserProfile extends StatelessWidget {
  final String? profileImageurl;
  final File? image;
  final double radius;
  final String name;
  final double? fontSize;

  const UserProfile({
    Key? key,
    this.profileImageurl,
    this.image,
    required this.radius,
    required this.name,
    this.fontSize,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return CircleAvatar(
      backgroundColor: Colors.grey[200],
      radius: radius,
      backgroundImage: _backGroundImage(),
      child: profileImageurl == null
          ? Text(
              name == '' ? 'Pic' : name[0],
              style: TextStyle(color: Colors.black, fontSize: fontSize),
            )
          : null,
    );
  }

  _backGroundImage() {
    if (image != null) {
      return FileImage(
        image!,
      ) as ImageProvider;
    } else if (profileImageurl != null) {
      return NetworkImage(profileImageurl!);
    } else {
      return null;
    }
  }
}
