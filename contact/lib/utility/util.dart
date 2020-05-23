
import 'dart:io';
import 'dart:typed_data';
import 'package:flutter/material.dart';
import 'dart:convert';

import 'package:image_picker/image_picker.dart';

class Utility {

  static Image imageFromBase64String(String base64String) {
    return Image.memory(
      base64Decode(base64String),
      fit: BoxFit.fill,
    );
  }

  static Uint8List dataFromBase64String(String base64String) {
    return base64Decode(base64String);
  }

  static String base64String(Uint8List data) {
    return base64Encode(data);
  }

  static Future<File> pickImage(BuildContext context) async {
    var imageSource = await showDialog<ImageSource>(
        context: context,
        builder: (context) =>
            AlertDialog(
              title: Text("Select the image source"),
              actions: <Widget>[
                MaterialButton(
                  child: Text("Camera"),
                  onPressed: () => Navigator.pop(context, ImageSource.camera),
                ),
                MaterialButton(
                  child: Text("Gallery"),
                  onPressed: () => Navigator.pop(context, ImageSource.gallery),
                )
              ],
            )
    );

    if(imageSource != null) {
      var file = await ImagePicker.pickImage(source: imageSource, maxHeight: 120.0, maxWidth: 120.0);
      if(file != null) {
        return file;
      }
      return null;
    }
  }


  static Widget loadUserImage(String image, double widthValue, double heightValue) {
    if (image != null && image.isNotEmpty) {
      return ClipRRect(
        borderRadius: BorderRadius.circular(8.0),
        child: Image.memory(Utility.dataFromBase64String(image),
          fit: BoxFit.fill,
          height: heightValue,
          width: widthValue,
        ),
      );
    } else {
      return Container(
        child: placeholderImageWidget(),
      );
    }
  }

  static Image placeholderImageWidget() {
    AssetImage assetImage = AssetImage('assets/images/placeholder.png');
    Image image = Image(image: assetImage, width: 60.0, height: 60.0);
    return image;
  }
}