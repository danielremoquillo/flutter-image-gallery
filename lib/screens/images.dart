import 'package:flutter/material.dart';

class Images extends StatefulWidget {
  final String folderName;
  const Images({super.key, required this.folderName});

  @override
  State<Images> createState() => _ImagesState();
}

class _ImagesState extends State<Images> {
  double _zoom = 200.0;

  _zoomOut() {
    setState(() {
      if (_zoom <= 200) {
        _zoom -= 50.0;
        if (_zoom <= 100) {
          _zoom = 100.0;
        }
      } else {
        _zoom -= 200.0;
      }
    });
  }

  _zoomIn() {
    setState(() {
      if (_zoom >= 400) {
        _zoom = 400.0;
      } else {
        if (_zoom == 200.0) {
          _zoom += 200.0;
        } else {
          _zoom += 100.0;
        }
      }
    });
  }

  List<Widget> imageFiles = [
    Container(height: 200, width: 200, color: Colors.amber),
  ];
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.folderName),
        actions: [
          IconButton(
              onPressed: () {
                _zoomIn();
                print(_zoom);
              },
              icon: Icon(
                Icons.zoom_in,
                color: _zoom != 400.0 ? Colors.white : Colors.grey,
              )),
          IconButton(
              onPressed: () {
                _zoomOut();
                print(_zoom);
              },
              icon: Icon(
                Icons.zoom_out,
                color: _zoom != 100.0 ? Colors.white : Colors.grey,
              )),
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.all(3.0),
        child: CustomScrollView(
          slivers: [
            SliverGrid(
                delegate: SliverChildBuilderDelegate(
                  (context, index) {
                    return imageFiles[0];
                  },
                  childCount: 200,
                ),
                gridDelegate: SliverGridDelegateWithMaxCrossAxisExtent(
                    maxCrossAxisExtent: _zoom,
                    mainAxisSpacing: 2.0,
                    crossAxisSpacing: 2.0))
          ],
        ),
      ),
    );
  }
}
