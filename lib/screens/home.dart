import 'dart:convert';
import 'dart:collection';
import 'package:flutter/material.dart';
import 'package:flutter_image_gallery/components/gallery_theme.dart';
import 'package:flutter_image_gallery/widgets/folder_cover.dart';
import 'package:flutter_image_gallery/screens/folder.dart';
import 'package:flutter_storage_path/flutter_storage_path.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  List<dynamic> imageDirectories = [];

  bool isClickOrder = false;

  @override
  void initState() {
    _requestPermissionGetImageFiles();
    super.initState();
  }

  Future<Map<String, List<String>>> _pathImageFiles() async {
    SplayTreeMap<String, List<String>> folders =
        SplayTreeMap<String, List<String>>();

    for (var path in imageDirectories) {
      String folderName;
      int removeLast = path.split('/').length;

      folderName = path.split('/').getRange(0, removeLast - 1).last;
      folders.putIfAbsent(folderName, () => []);

      folders[folderName]?.add(path);
    }

    return folders;
  }

  //Request for Storage Permission
  Future<void> _requestPermissionGetImageFiles() async {
    //contains images path and folder name in json format
    var imagePath = await StoragePath.imagesPath;
    var images = jsonDecode(imagePath!) as List;
    var files = images.map((e) => e['files']).toList();
    imageDirectories = files.expand((element) => element).toList();

    setState(() {}); // refresh after request
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: GalleryTheme.primary,
      body: SafeArea(
        child: FutureBuilder<Map<String, List<String>>>(
            future: _pathImageFiles(),
            builder: (context, snapshot) {
              if (snapshot.data == null) {
                return const CircularProgressIndicator();
              }
              return Container(
                decoration: const BoxDecoration(
                  gradient: GalleryTheme.backgroundColor,
                ),
                child: CustomScrollView(
                  slivers: [
                    SliverAppBar(
                      pinned: true,
                      collapsedHeight: 100,
                      title: const Text('All Album'),
                      actions: [
                        IconButton(
                          onPressed: () {
                            showDialog(
                                context: context,
                                builder: (context) {
                                  return AlertDialog(
                                    backgroundColor: GalleryTheme.primary,
                                    title: const Text(
                                      'Project Details',
                                      style: TextStyle(
                                          color: GalleryTheme.secondary),
                                    ),
                                    content: const Text.rich(
                                      TextSpan(
                                        children: [
                                          TextSpan(
                                              text: 'Project Name: ',
                                              style: TextStyle(
                                                color: GalleryTheme.secondary,
                                              ),
                                              children: [
                                                TextSpan(
                                                  text: 'Flutter Gallery\n',
                                                  style: TextStyle(
                                                      color: GalleryTheme
                                                          .secondary),
                                                )
                                              ]),
                                          TextSpan(
                                              text: 'Created by: ',
                                              style: TextStyle(
                                                color: GalleryTheme.secondary,
                                              ),
                                              children: [
                                                TextSpan(
                                                  text: 'Daniel Remoquillo',
                                                  style: TextStyle(
                                                      color: GalleryTheme
                                                          .secondary),
                                                )
                                              ]),
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
                          ),
                        ),
                      ],
                      backgroundColor: GalleryTheme.primary,
                    ),
                    snapshot.data!.isNotEmpty
                        ? SliverGrid(
                            delegate: SliverChildBuilderDelegate(
                              (context, index) {
                                var folderName =
                                    snapshot.data!.keys.elementAt(index);

                                return GestureDetector(
                                  onTap: () {
                                    Navigator.push(
                                        context,
                                        MaterialPageRoute(
                                            builder: (context) => FolderScreen(
                                                storageName: snapshot
                                                    .data![folderName]![0]
                                                    .split('/')
                                                    .elementAt(2),
                                                folderName: folderName,
                                                folderFiles: snapshot
                                                    .data![folderName])));
                                  },
                                  child: FolderCover(
                                    imagePath: snapshot.data![folderName]![0],
                                    folderName: folderName,
                                    imageCount:
                                        snapshot.data![folderName]?.length,
                                  ),
                                );
                              },
                              childCount: snapshot.data!.length,
                            ),
                            gridDelegate:
                                SliverGridDelegateWithMaxCrossAxisExtent(
                                    maxCrossAxisExtent:
                                        MediaQuery.of(context).size.width * 0.6,
                                    mainAxisSpacing: 10.0,
                                    crossAxisSpacing: 10.0))
                        : const SliverToBoxAdapter(
                            child: Center(
                              child: Text(
                                'No Images found.',
                                style: TextStyle(color: GalleryTheme.secondary),
                              ),
                            ),
                          ),
                  ],
                ),
              );
            }),
      ),
    );
  }
}
