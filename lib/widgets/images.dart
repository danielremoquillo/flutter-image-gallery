import 'dart:io';
import 'package:flutter/material.dart';

class ImageFiles extends StatefulWidget {
  final String path;
  const ImageFiles({super.key, required this.path});

  @override
  State<ImageFiles> createState() => _ImageFilesState();
}

class _ImageFilesState extends State<ImageFiles> {
  @override
  Widget build(BuildContext context) {
    return Container(
      height: 200,
      width: 200,
      child: Image.file(
        File(widget.path),
        fit: BoxFit.cover,
        errorBuilder: (context, error, stackTrace) =>
            Image.asset('assets/placeholder.png'),
      ),
    );
  }
}
