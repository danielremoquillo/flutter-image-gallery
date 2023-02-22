import 'package:flutter/material.dart';
import 'package:flutter_image_gallery/widgets/folder.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  List<Widget> imageFiles = [
    const FolderWidget(
      folderName: 'Camera',
    ),
    const FolderWidget(
      folderName: 'Facebook',
    ),
    const FolderWidget(
      folderName: 'DCIM',
    ),
    const FolderWidget(
      folderName: 'Messenger',
    ),
  ];
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Gallery'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(3.0),
        child: CustomScrollView(
          slivers: [
            SliverGrid(
                delegate: SliverChildBuilderDelegate(
                  (context, index) {
                    return imageFiles[index];
                  },
                  childCount: imageFiles.length,
                ),
                gridDelegate: const SliverGridDelegateWithMaxCrossAxisExtent(
                    maxCrossAxisExtent: 200.0,
                    mainAxisSpacing: 2.0,
                    crossAxisSpacing: 2.0))
          ],
        ),
      ),
    );
  }
}
