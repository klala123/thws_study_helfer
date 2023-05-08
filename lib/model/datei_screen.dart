

import 'dart:math';

import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';
import 'package:flutter_staggered_animations/flutter_staggered_animations.dart';
import 'package:smooth_page_indicator/smooth_page_indicator.dart';

import 'Folder.dart';
import 'FolderFileScreen.dart';
import 'FolderSearch.dart';

class FileStorageScreen extends StatefulWidget {
  @override
  _FileStorageScreenState createState() => _FileStorageScreenState();
}

class _FileStorageScreenState extends State<FileStorageScreen> {
  List<Folder> _folders = [];
  final TextEditingController _searchController = TextEditingController();
  List<Folder> _filteredFolders = [];
  DatabaseReference? _folderRef;
  String _searchQuery = '';
  PageController _pageController = PageController();


  @override
  void initState() {
    super.initState();
    _initializeFirebase();
    _searchController.addListener(_onSearchChanged); // Ändern Sie diese Zeile
    _filteredFolders = List.from(_folders);
    _getFolderList();
  }


  void _filterFolders() {
    setState(() {
      _filteredFolders = _folders
          .where((folder) => folder.name
          .toLowerCase()
          .contains(_searchController.text.toLowerCase()))
          .toList();
    });
  }

  void _onSearchChanged() {
    String query = _searchController.text;
    if (query.isEmpty) {
      setState(() {
        _filteredFolders = _folders;
      });
    } else {
      setState(() {
        _filteredFolders = _folders
            .where((folder) => folder.name.toLowerCase().contains(query.toLowerCase()))
            .toList();
      });
    }
  }
  @override
  void dispose() {
    _searchController.removeListener(_onSearchChanged);
    _searchController.dispose();
    super.dispose();
  }


  Future<void> _initializeFirebase() async {
    await Firebase.initializeApp();
    _folderRef = FirebaseDatabase.instance.reference().child('folders');
    _getFolderList();
  }


  Future<void> _getFolderList() async {

    _folderRef!.onChildAdded.listen((event) {
      Map<dynamic, dynamic> value = event.snapshot.value as Map<dynamic, dynamic>;
      Folder newFolder = Folder(name: value['name'] ?? '', key: event.snapshot.key!);
      setState(() {
        _folders.add(newFolder);
        _filteredFolders = List.from(_folders);
      });
    });

    _folderRef!.onChildRemoved.listen((event) {
      Folder removedFolder = _folders.firstWhere((folder) => folder.key == event.snapshot.key);
      setState(() {
        _folders.remove(removedFolder);
        _filteredFolders = List.from(_folders);
      });
    });
  }

  Future<void> _createFolder() async {
    TextEditingController folderNameController = TextEditingController();

    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text("Neuen Ordner erstellen"),
          content: TextField(
            controller: folderNameController,
            decoration: InputDecoration(hintText: "Ordnername"),
          ),
          actions: [
            TextButton(
              child: Text("Abbrechen"),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
            TextButton(
              child: Text("Erstellen"),
              onPressed: () async {
                DatabaseReference folderRef = _folderRef!.push();
                await folderRef.set({'name': folderNameController.text});
                setState(() {
                  _folders.add(Folder(
                      name: folderNameController.text, key: folderRef.key!));
                });
                Navigator.of(context).pop();
              },
            ),
          ],
        );
      },
    );
  }





  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        padding: EdgeInsets.fromLTRB(20, 80, 20, 10),
        decoration: BoxDecoration(
          image: DecorationImage(
            image: AssetImage('assets/images/hintergrundBild.png'),
            fit: BoxFit.cover,
          ),
        ),
        child: Column(
          children: [
            Padding(
              padding: EdgeInsets.fromLTRB( 10 , 40, 10, 10 ),
              child: TextField(
                onChanged: (value) {
                  _filterFolders();
                },
                controller: _searchController,
                decoration: InputDecoration(
                  hintText: 'Suche...',
                  hintStyle: TextStyle(color: Colors.white54),
                  fillColor: Colors.white.withOpacity(0.3),
                  filled: true,
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(16.0),
                    borderSide: BorderSide(
                      color: Colors.white,
                    ),
                  ),
                  focusedBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(16.0),
                    borderSide: BorderSide(
                      color: Colors.white,
                    ),
                  ),
                  prefixIcon: Icon(Icons.search, color: Colors.white),
                ),
              ),
            ),

            SizedBox(height: 70),

            Expanded(
              child: AnimationLimiter(
                child: Column(
                  children: [
                    Expanded(
                      child: PageView.builder(
                        controller: _pageController,
                        scrollDirection: Axis.horizontal,
                       itemCount: (_filteredFolders.length / 8).ceil(),
                        itemBuilder: (BuildContext context, int pageIndex) {
                          return Container(
                            width: MediaQuery.of(context).size.width,
                            child: GridView.builder(
                              itemCount: min(8, _filteredFolders.length - pageIndex * 8), // Ändern Sie diese Zeile
                              padding: EdgeInsets.fromLTRB(20.0, 0.0, 20.0, 20.0),
                              gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                                crossAxisCount: 2,
                                childAspectRatio: 2,
                                mainAxisSpacing: 9.0,
                                crossAxisSpacing: 9.0,
                              ),
                              itemBuilder: (BuildContext context, int index) {
                                Folder folder = _filteredFolders[pageIndex * 8 + index]; // Ändern Sie diese Zeile
                                return AnimationConfiguration.staggeredGrid(
                                  position: index,
                                  duration: const Duration(milliseconds: 375),
                                  columnCount: 2,
                                  child: ScaleAnimation(
                                    child: FadeInAnimation(
                                      child: GestureDetector(
                                        onTap: () {
                                          Navigator.push(
                                            context,
                                            MaterialPageRoute(
                                              builder: (context) => FolderFilesScreen(folder: folder),
                                            ),
                                          );
                                        },
                                        child: Container(
                                          child: Column(
                                            mainAxisAlignment: MainAxisAlignment.center,
                                            crossAxisAlignment: CrossAxisAlignment.center,
                                            children: [
                                              Container(
                                                height: 100,
                                                width: 100,
                                                child: Stack(
                                                  children: [
                                                    Align(
                                                      alignment: Alignment.center,
                                                      child: Icon(
                                                        Icons.folder,
                                                        size: 30.0,
                                                        color: Colors.white,
                                                      ),
                                                    ),
                                                    Align(
                                                      alignment: Alignment.bottomCenter,
                                                      child: Padding(
                                                        padding: const EdgeInsets.only(bottom: 0.0, top: 20),
                                                        child: Text(
                                                          folder.name,
                                                          style: TextStyle(
                                                            color: Colors.white,
                                                            fontSize: 18.0,
                                                          ),
                                                        ),
                                                      ),
                                                    ),
                                                  ],
                                                ),
                                              ),
                                            ],
                                          ),
                                        ),
                                      ),
                                    ),
                                  ),
                                );
                              },
                            ),
                          );
                        },
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.only(bottom: 16.0),
                      child: SmoothPageIndicator(
                        controller: _pageController,
                        count: (_filteredFolders.length / 8).ceil(),
                        effect: ExpandingDotsEffect(
                          dotHeight: 8,
                          dotWidth: 8,
                          dotColor: Colors.grey,
                          activeDotColor: Colors.white,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: _createFolder,
        child: Icon(Icons.add),
        backgroundColor: Colors.blueGrey,
      ),
    );

  }

}
