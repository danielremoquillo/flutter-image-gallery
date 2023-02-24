import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter_image_gallery/screens/image.dart';

class ImageFiles extends StatelessWidget {
  final String path;
  final int index;
  final Color? backgroundColor;
  const ImageFiles(
      {super.key,
      required this.path,
      required this.index,
      this.backgroundColor});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        Navigator.push(
            context,
            MaterialPageRoute(
              builder: (_) => ImageScreen(
                selectedImage: Image.file(File(path)),
                index: index,
              ),
            ));
      },
      child: Hero(
        tag: 'selectedImage$index',
        child: Container(
          height: 200,
          width: 200,
          color: backgroundColor,
          child: Image.file(
            File(path),
            fit: BoxFit.cover,
            errorBuilder: (context, error, stackTrace) =>
                Image.asset('assets/placeholder.png'),
          ),
        ),
      ),
    );
  }
}
