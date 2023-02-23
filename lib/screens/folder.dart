import 'package:flutter/material.dart';
import 'package:flutter_image_gallery/widgets/images.dart';

class Folder extends StatefulWidget {
  final String folderName;
  final List<String>? folderFiles;
  const Folder(
      {super.key, required this.folderName, required this.folderFiles});

  @override
  State<Folder> createState() => _FolderState();
}

class _FolderState extends State<Folder> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.folderName),
      ),
      body: CustomScrollView(
        slivers: [
          SliverGrid(
              delegate: SliverChildBuilderDelegate((context, index) {
                return ImageFiles(path: widget.folderFiles![index]);
              }, childCount: widget.folderFiles!.length),
              gridDelegate: const SliverGridDelegateWithMaxCrossAxisExtent(
                  maxCrossAxisExtent: 200))
        ],
      ),
    );
  }
}
