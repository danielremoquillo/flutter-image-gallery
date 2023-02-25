import 'dart:io';

import 'package:flutter/material.dart';
import 'package:easy_image_viewer/easy_image_viewer.dart';

class FilesImageProvider extends EasyImageProvider {
  final List<String>? folderFiles;
  final int initialIndex;

  FilesImageProvider({required this.folderFiles, this.initialIndex = 0});

  @override
  ImageProvider<Object> imageBuilder(BuildContext context, int index) {
    String? localImagePath = folderFiles![index];
    File? imageFile;
    bool isCompatible = true;
    imageFile = File(localImagePath);

//Checks if the following file is compatible to fileimage
    FileImage(imageFile).resolve(const ImageConfiguration()).addListener(
          ImageStreamListener(
            (ImageInfo imageInfo, bool synchronousCall) {
              // Do something with the loaded image, such as display it in an `Image` widget
            },
            onError: (dynamic exception, StackTrace? stackTrace) {
              // Handle the error, such as displaying a default image or showing an error message
              isCompatible = false;
            },
          ),
        );

    ImageProvider imageProvider = isCompatible
        ? FileImage(imageFile)
        : const AssetImage('assets/placeholder.png') as ImageProvider;

    return imageProvider;
  }

  @override
  int get imageCount => folderFiles!.length;
}
