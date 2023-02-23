import 'package:flutter/material.dart';

class ImageScreen extends StatelessWidget {
  final Image selectedImage;
  final int index;
  const ImageScreen(
      {super.key, required this.selectedImage, required this.index});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      body: Center(
        child: Hero(tag: 'selectedImage$index', child: selectedImage),
      ),
    );
  }
}
