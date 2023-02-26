import 'package:flutter/material.dart';
import 'package:flutter_image_gallery/components/gallery_theme.dart';
import 'package:flutter_image_gallery/widgets/image_file.dart';

class FolderScreen extends StatelessWidget {
  final String folderName;
  final String storageName;
  String? folderPath;

  final List<String>? folderFiles;
  FolderScreen(
      {super.key,
      required this.folderName,
      required this.folderFiles,
      required this.storageName});

  @override
  Widget build(BuildContext context) {
    folderPath =
        '${folderFiles![0].split('/').getRange(0, folderFiles![0].split('/').length - 2).join('/')}/';
    return Scaffold(
      backgroundColor: GalleryTheme.tertiary,
      body: CustomScrollView(
        slivers: [
          SliverAppBar(
            pinned: true,
            elevation: 4,
            title: Text(
              '$folderName (${folderFiles?.length})',
              textAlign: TextAlign.center,
              style: const TextStyle(color: Colors.white, fontSize: 18),
            ),
            actions: [
              IconButton(
                  onPressed: () {
                    showDialog(
                        context: context,
                        builder: (context) {
                          return AlertDialog(
                            backgroundColor: GalleryTheme.primary,
                            title: const Text(
                              'Folder Info',
                              style: TextStyle(color: GalleryTheme.secondary),
                            ),
                            content: Text.rich(
                              TextSpan(
                                children: [
                                  TextSpan(
                                    text: 'Folder name: $folderName \n',
                                    style: const TextStyle(
                                        fontSize: 14,
                                        color: GalleryTheme.secondary),
                                  ),
                                  TextSpan(
                                    text:
                                        'Image count: ${folderFiles?.length} \n',
                                    style: const TextStyle(
                                        fontSize: 14,
                                        color: GalleryTheme.secondary),
                                  ),
                                  TextSpan(
                                    text: 'Path: $folderPath',
                                    style: const TextStyle(
                                        fontSize: 14,
                                        color: GalleryTheme.secondary),
                                  ),
                                ],
                              ),
                            ),
                            actions: [
                              TextButton(
                                child: const Text('CLOSE'),
                                onPressed: () {
                                  Navigator.pop(context);
                                },
                              ),
                            ],
                          );
                        });
                  },
                  icon: const Icon(
                    Icons.info_outline,
                    color: Colors.white,
                  ))
            ],
            backgroundColor: GalleryTheme.primary,
          ),
          SliverGrid(
              delegate: SliverChildBuilderDelegate((context, index) {
                return ImageFiles(
                  path: folderFiles![index],
                  index: index,
                  backgroundColor: GalleryTheme.secondary,
                  folderFiles: folderFiles,
                );
              }, childCount: folderFiles!.length),
              gridDelegate: const SliverGridDelegateWithMaxCrossAxisExtent(
                  maxCrossAxisExtent: 150,
                  mainAxisSpacing: 2.0,
                  crossAxisSpacing: 2.0))
        ],
      ),
    );
  }
}
