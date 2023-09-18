import 'package:enough_giphy_flutter/enough_giphy_flutter.dart';
import 'package:flutter/material.dart';
import 'dart:io';

import 'package:image_picker/image_picker.dart';

void showsnackbar(BuildContext context, String content) {
  ScaffoldMessenger.of(context).showSnackBar(
    SnackBar(
      content: Text(content),
    ),
  );
}

Future<File?> PickImageFromGallery(BuildContext context) async {
  File? image;
  try {
    final pickedimage = await ImagePicker().pickImage(
      source: ImageSource.gallery,
    );
    if (pickedimage != null) {
      image = File(pickedimage.path);
    }
  } catch (e) {
    showsnackbar(context, e.toString());
  }
  return image;
}

Future<File?> PickVideoFromGallery(BuildContext context) async {
  File? video;
  try {
    final pickedvideo = await ImagePicker().pickVideo(
      source: ImageSource.gallery,
    );
    if (pickedvideo != null) {
      video = File(pickedvideo.path);
    }
  } catch (e) {
    showsnackbar(context, e.toString());
  }
  return video;
}

Future<GiphyGif?> pickGIF(BuildContext context) async {
  final apikey = 'auRgT0tCcds0UciLkObp00OYW4q5cRvQ';
  GiphyGif? gif;
  try {
    gif = await Giphy.getGif(
      context: context,
      apiKey: apikey,
    );
  } catch (e) {
    showsnackbar(context, e.toString());
  }
  return gif;
}
