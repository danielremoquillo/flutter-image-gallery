import 'dart:io';
import 'package:flutter/material.dart';

class FolderCover extends StatelessWidget {
  final String imagePath;
  final int? imageCount;

  final String folderName;
  const FolderCover(
      {super.key,
      required this.imagePath,
      required this.imageCount,
      required this.folderName});

  @override
  Widget build(BuildContext context) {
    return GridTile(
      footer: GridTileBar(
        backgroundColor: const Color.fromARGB(120, 0, 0, 0),
        title: Text(
          folderName,
          style: const TextStyle(color: Colors.white),
          maxLines: 1,
        ),
        subtitle: Text(
          '$imageCount images',
          style: const TextStyle(color: Colors.white),
        ),
      ),
      child: Image.file(
        File(imagePath),
        cacheHeight: 200,
        fit: BoxFit.cover,
        errorBuilder: (context, error, stackTrace) =>
            Image.asset('assets/placeholder.png'),
      ),
    );
  }
}
