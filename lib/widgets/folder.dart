import 'dart:io';

import 'package:flutter/material.dart';

class FolderWidget extends StatefulWidget {
  final String folderName;
  final List<String>? folderFiles;

  const FolderWidget(
      {super.key, required this.folderName, required this.folderFiles});

  @override
  State<FolderWidget> createState() => _FolderWidgetState();
}

class _FolderWidgetState extends State<FolderWidget> {
  @override
  Widget build(BuildContext context) {
    return SliverToBoxAdapter(
      child: Container(
        height: MediaQuery.of(context).size.height * 0.2,
        width: MediaQuery.of(context).size.width,
        child: Column(
          children: [
            Text(widget.folderName),
            SingleChildScrollView(
              scrollDirection: Axis.horizontal,
              child: ListView.builder(
                  itemCount: widget.folderFiles?.length,
                  itemBuilder: (BuildContext context, index) {
                    return Container(
                      height: 200,
                      width: 200,
                      child: Image.file(
                        File(widget.folderFiles![index]),
                        fit: BoxFit.cover,
                      ),
                    );
                  }),
            ),
          ],
        ),
      ),
    );
  }
}
