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
                            const SizedBox(
                              height: 40,
                            ),
                            const Text(
                              'Folders',
                              style:
                                  TextStyle(color: Colors.white, fontSize: 22),
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
                                        builder: (context) => FolderScreen(
                                            folderName: folderName,
                                            folderFiles:
                                                snapshot.data![folderName])));
                              },
                              child: FolderCover(
                                imagePath: snapshot.data![folderName]![0],
                                folderName: folderName,
                                imageCount: snapshot.data![folderName]?.length,
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
