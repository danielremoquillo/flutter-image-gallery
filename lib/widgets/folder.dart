import 'package:flutter/material.dart';
import 'package:flutter_image_gallery/screens/images.dart';

class FolderWidget extends StatefulWidget {
  final String folderName;
  const FolderWidget({super.key, required this.folderName});

  @override
  State<FolderWidget> createState() => _FolderWidgetState();
}

class _FolderWidgetState extends State<FolderWidget> {
  @override
  Widget build(BuildContext context) {
    return GestureDetector(
        onTap: () {
          Navigator.of(context).push(MaterialPageRoute<void>(
              builder: (BuildContext context) =>
                  Images(folderName: widget.folderName)));
        },
        child: GridTile(
          footer: Container(
            padding: const EdgeInsets.all(12.0),
            color: const Color.fromARGB(137, 0, 0, 0),
            child: Text(
              widget.folderName,
              style: const TextStyle(color: Colors.white),
            ),
          ),
          child: Container(height: 200, width: 200, color: Colors.amber),
        ));
  }
}
