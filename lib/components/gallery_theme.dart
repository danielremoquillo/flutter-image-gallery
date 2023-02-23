import 'package:flutter/material.dart';

class GalleryTheme {
  static const LinearGradient backgroundColor = LinearGradient(
      begin: Alignment.topLeft,
      end: Alignment.bottomLeft,
      colors: [
        Color(0xFF393E46),
        Color.fromARGB(255, 43, 47, 53),
        Color.fromARGB(255, 34, 38, 43),
      ]);

  static const Color primary = Color(0xFF393E46);
  static const Color secondary = Colors.white;
  static const Color tertiary = Color.fromARGB(255, 43, 47, 53);
}
