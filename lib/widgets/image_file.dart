import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter_image_gallery/screens/image.dart';

class ImageFiles extends StatefulWidget {
  final String path;
  final int index;
  final Color? backgroundColor;
  const ImageFiles(
      {super.key,
      required this.path,
      required this.index,
      this.backgroundColor});

  @override
  State<ImageFiles> createState() => _ImageFilesState();
}

class _ImageFilesState extends State<ImageFiles> {
  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        Navigator.push(
            context,
            MaterialPageRoute(
              builder: (_) => ImageScreen(
                selectedImage: Image.file(File(widget.path)),
                index: widget.index,
              ),
            ));
      },
      child: Hero(
        tag: 'selectedImage${widget.index}',
        child: Container(
          height: 200,
          width: 200,
          color: widget.backgroundColor,
          child: Image.file(
            File(widget.path),
            fit: BoxFit.cover,
            errorBuilder: (context, error, stackTrace) =>
                Image.asset('assets/placeholder.png'),
          ),
        ),
      ),
    );
  }
}
