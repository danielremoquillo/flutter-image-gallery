import 'package:flutter/material.dart';
import 'package:flutter_image_gallery/components/gallery_theme.dart';
import 'package:flutter_image_gallery/widgets/image_file.dart';

class FolderScreen extends StatelessWidget {
  final String folderName;
  final List<String>? folderFiles;
  const FolderScreen(
      {super.key, required this.folderName, required this.folderFiles});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: GalleryTheme.tertiary,
      body: CustomScrollView(
        slivers: [
          SliverAppBar(
            pinned: true,
            elevation: 4,
            actions: const [
              IconButton(
                  onPressed: null,
                  icon: Icon(
                    Icons.more_vert_outlined,
                    color: Colors.white,
                  ))
            ],
            backgroundColor: GalleryTheme.primary,
            bottom: PreferredSize(
              preferredSize: const Size.fromHeight(150.0),
              child: Padding(
                padding: const EdgeInsets.symmetric(vertical: 40.0),
                child: Column(
                  children: [
                    Text(
                      '$folderName (${folderFiles?.length})',
                      style: const TextStyle(color: Colors.white, fontSize: 25),
                    ),
                    const SizedBox(
                      height: 10.0,
                    ),
                    Text(
                      folderFiles![0]
                          .split('/')
                          .getRange(0, folderFiles![0].split('/').length - 1)
                          .join('/')
                          .toString(),
                      style: const TextStyle(color: Colors.white, fontSize: 18),
                    ),
                  ],
                ),
              ),
            ),
          ),
          SliverGrid(
              delegate: SliverChildBuilderDelegate((context, index) {
                return ImageFiles(
                  path: folderFiles![index],
                  index: index + 1,
                  backgroundColor: GalleryTheme.secondary,
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
