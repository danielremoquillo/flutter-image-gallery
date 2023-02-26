import 'dart:io';
import 'package:easy_image_viewer/easy_image_viewer.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import '../providers/file_image.dart';

class ImageFiles extends StatelessWidget {
  final String path;
  final int index;
  final Color? backgroundColor;

  final List<String>? folderFiles;
  const ImageFiles(
      {super.key,
      required this.path,
      required this.index,
      this.backgroundColor,
      this.folderFiles});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        showImageViewerPager(
          context,
          FilesImageProvider(folderFiles: folderFiles, initialIndex: index),
          useSafeArea: true,
          doubleTapZoomable: true,
          onViewerDismissed: (_) {
            SystemChrome.setEnabledSystemUIMode(SystemUiMode.manual,
                overlays: SystemUiOverlay.values);
          },
        );
      },
      child: Hero(
        tag: 'selectedImage$index',
        child: Container(
          color: backgroundColor,
          child: Image.file(
            File(path),
            cacheHeight: 200,
            fit: BoxFit.cover,
            errorBuilder: (context, error, stackTrace) =>
                Image.asset('assets/placeholder.png'),
          ),
        ),
      ),
    );
  }
}
