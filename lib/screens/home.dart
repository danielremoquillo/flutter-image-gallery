import 'dart:io';

import 'package:external_path/external_path.dart';
import 'package:flutter/material.dart';
import 'package:flutter_image_gallery/components/gallery_theme.dart';
import 'package:flutter_image_gallery/widgets/folder_cover.dart';

import 'package:flutter_image_gallery/screens/folder.dart';
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
      backgroundColor: GalleryTheme.primary,
      body: SafeArea(
        child: FutureBuilder<Map<String, List<String>>>(
            future: _getImageFiles(),
            builder: (context, snapshot) {
              if (snapshot.data == null) {
                return const CircularProgressIndicator();
              }
              return Container(
                padding: const EdgeInsets.symmetric(horizontal: 20.0),
                decoration: const BoxDecoration(
                  gradient: GalleryTheme.backgroundColor,
                ),
                child: CustomScrollView(
                  slivers: [
                    SliverToBoxAdapter(
                      child: Padding(
                        padding: const EdgeInsets.symmetric(vertical: 18.0),
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children: const [
                                  Text(
                                    'Gallery',
                                    style: TextStyle(
                                        color: Colors.white, fontSize: 25),
                                  ),
                                  IconButton(
                                    onPressed: null,
                                    icon: Icon(
                                      Icons.search,
                                      color: Colors.white,
                                    ),
                                    iconSize: 30,
                                  ),
                                ]),
                            SizedBox(
                              height: 40,
                            ),
                            Text(
                              'Internal Storage',
                              style:
                                  TextStyle(color: Colors.white, fontSize: 20),
                            ),
                          ],
                        ),
                      ),
                    ),
                    SliverGrid(
                        delegate: SliverChildBuilderDelegate(
                          (context, index) {
                            var folderName =
                                snapshot.data!.keys.elementAt(index);

                            return GestureDetector(
                              onTap: () {
                                Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                        builder: (context) => Folder(
                                            folderName: folderName,
                                            folderFiles:
                                                snapshot.data![folderName])));
                              },
                              child: GridTile(
                                footer: GridTileBar(
                                  backgroundColor:
                                      const Color.fromARGB(120, 0, 0, 0),
                                  title: Text(
                                    folderName,
                                    style: const TextStyle(color: Colors.white),
                                    maxLines: 1,
                                  ),
                                  subtitle: Text(
                                    '${snapshot.data![folderName]?.length} images',
                                    style: const TextStyle(color: Colors.white),
                                  ),
                                ),
                                child: FolderCover(
                                  path: snapshot.data![
                                      snapshot.data!.keys.elementAt(index)]![0],
                                ),
                              ),
                            );
                          },
                          childCount: snapshot.data!.length,
                        ),
                        gridDelegate: SliverGridDelegateWithMaxCrossAxisExtent(
                            maxCrossAxisExtent:
                                MediaQuery.of(context).size.width * 0.6,
                            mainAxisSpacing: 10.0,
                            crossAxisSpacing: 10.0))
                  ],
                ),
              );
            }),
      ),
    );
  }
}
