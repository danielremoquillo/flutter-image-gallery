import 'dart:io';
import 'package:flutter/material.dart';

class FolderCover extends StatefulWidget {
  final String path;
  const FolderCover({super.key, required this.path});

  @override
  State<FolderCover> createState() => _FolderCoverState();
}

class _FolderCoverState extends State<FolderCover> {
  @override
  Widget build(BuildContext context) {
    return Image.file(
      File(widget.path),
      fit: BoxFit.cover,
      errorBuilder: (context, error, stackTrace) =>
          Image.asset('assets/placeholder.png'),
    );
  }
}
