import 'dart:io';
import 'package:flutter/material.dart';
import 'package:file_picker/file_picker.dart';

final GlobalKey<ScaffoldMessengerState> rootScaffoldMessengerKey =
    GlobalKey<ScaffoldMessengerState>();

void showSnackBar(BuildContext context, String text) {
  rootScaffoldMessengerKey.currentState!
      .showSnackBar(SnackBar(content: Text(text)));
}

Future<List<File>> pickImages() async {
  List<File> images = [];
  try {
    
    var files = await FilePicker.platform.pickFiles(
      type: FileType.image,
      allowMultiple: true,
    );
    if (files != null && files.files.isNotEmpty) {
      for (int i = 0; i < files.files.length; i++) {
        images.add(File(files.files[i].path!));
      }
    }
  } catch (e) {
    debugPrint(e.toString());
  }
  return images;
}
