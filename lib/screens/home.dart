import 'dart:io';

import 'package:external_path/external_path.dart';
import 'package:flutter/material.dart';
import 'package:permission_handler/permission_handler.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  List<String> directories = [];

  @override
  void initState() {
    _requestPermission();
    _getStorages();
    super.initState();
  }

  Future<void> _getStorages() async {
    var path = await ExternalPath.getExternalStorageDirectories();
    // please note: B3AE-4D28 is external storage (SD card) folder name it can be any.
    setState(() {
      directories = path;
    });
  }

  Future<Map<String, List<String>>> _getImageFiles() async {
    Directory internal = Directory(directories[0]);

//Get the folder names
    Map<String, List<String>> folders = <String, List<String>>{};

    List<FileSystemEntity> files = [];
    files =
        internal.listSync(recursive: true, followLinks: false).where((file) {
      return file.path.endsWith('.jpg') ||
          file.path.endsWith('.jpeg') ||
          file.path.endsWith('.png') ||
          file.path.endsWith('.gif');
    }).toList();

    for (var file in files) {
      String folderName = file.path.split('/')[4];
      folders.putIfAbsent(folderName, () => []);
      folders[folderName]?.add(file.path);
    }

    return folders;
  }

  //Request for Storage Permission
  Future<bool> _requestPermission() async {
    var statusStorage = await Permission.storage.status;

    if (statusStorage != PermissionStatus.granted) {
      Map<Permission, PermissionStatus> result = await [
        Permission.storage,
      ].request();

      if (result[Permission.storage] == PermissionStatus.granted) {
        return true;
      }
    } else {
      return true;
    }
    return false;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Gallery'),
      ),
      body: FutureBuilder<Map<String, List<String>>>(
          future: _getImageFiles(),
          builder: (context, snapshot) {
            if (snapshot.data == null) {
              return const CircularProgressIndicator();
            }
            print(snapshot.data![snapshot.data!.keys.elementAt(0)]);
            return Padding(
              padding: const EdgeInsets.all(3.0),
              child: CustomScrollView(
                slivers: [
                  SliverGrid(
                      delegate: SliverChildBuilderDelegate(
                        (context, index) {
                          return GridTile(
                            footer: GridTileBar(
                              backgroundColor: Color.fromARGB(120, 0, 0, 0),
                              title: Text(
                                snapshot.data!.keys.elementAt(index),
                                style: TextStyle(color: Colors.white),
                                maxLines: 1,
                              ),
                              subtitle: Text(
                                '${snapshot.data!.keys.elementAt(index).length} images',
                                style: TextStyle(color: Colors.white),
                              ),
                            ),
                            child: SizedBox(
                                height: 200,
                                width: 200,
                                child: Image.file(
                                  File(snapshot.data![snapshot.data!.keys
                                      .elementAt(index)]![0]),
                                  errorBuilder: (context, error, stackTrace) {
                                    return Image.asset(
                                        'assets/placeholder.png');
                                  },
                                  fit: BoxFit.cover,
                                )),
                          );
                        },
                        childCount: snapshot.data!.length,
                      ),
                      gridDelegate: SliverGridDelegateWithMaxCrossAxisExtent(
                          maxCrossAxisExtent:
                              MediaQuery.of(context).size.width * 0.6,
                          mainAxisSpacing: 2.0,
                          crossAxisSpacing: 2.0))
                ],
              ),
            );
          }),
    );
  }
}
