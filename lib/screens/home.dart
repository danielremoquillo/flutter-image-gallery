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

  Future<List<FileSystemEntity>> _getImageFiles() async {
    Directory internal = Directory(directories[0]);

    List<FileSystemEntity> files = [];

    files =
        internal.listSync(recursive: true, followLinks: false).where((file) {
      return file.path.endsWith('.jpg') ||
          file.path.endsWith('.jpeg') ||
          file.path.endsWith('.png') ||
          file.path.endsWith('.gif');
    }).toList();

    return files;
  }

  //Request for Storage Permission
  Future<bool> _requestPermission() async {
    var status = await Permission.storage.status;

    if (status != PermissionStatus.granted) {
      Map<Permission, PermissionStatus> result = await [
        Permission.storage,
        Permission.manageExternalStorage
      ].request();
      if (result[Permission.storage] == PermissionStatus.granted &&
          result[Permission.manageExternalStorage] ==
              PermissionStatus.granted) {
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
        title: const Text('Gallery'),
      ),
      body: FutureBuilder<List<FileSystemEntity>>(
        future: _getImageFiles(),
        builder: (context, snapshot) {
          if (snapshot.data == null) {
            return const CircularProgressIndicator();
          }

          if (snapshot.data!.isEmpty) {}

          return Padding(
            padding: const EdgeInsets.all(3.0),
            child: CustomScrollView(
              slivers: [
                SliverGrid(
                    delegate: SliverChildBuilderDelegate(
                      (context, index) {
                        return SizedBox(
                            height: 200,
                            width: 200,
                            child: Image.file(
                              File(snapshot.data![index].path),
                              errorBuilder: (context, error, stackTrace) {
                                return Image.asset('assets/placeholder.png');
                              },
                              fit: BoxFit.cover,
                            ));
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
        },
      ),
    );
  }
}
