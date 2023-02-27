import 'package:flutter/material.dart';
import 'package:flutter_image_gallery/components/gallery_theme.dart';
import 'package:flutter_image_gallery/screens/home.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Gallery App',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
          primarySwatch:
              GalleryTheme.buildMaterialColor(const Color(0xFF393E46)),
          fontFamily: 'DINRound'),
      home: const HomeScreen(),
    );
  }
}
