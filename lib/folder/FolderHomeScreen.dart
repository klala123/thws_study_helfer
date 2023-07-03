import 'dart:math';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';
import 'package:flutter_staggered_animations/flutter_staggered_animations.dart';
import 'package:smooth_page_indicator/smooth_page_indicator.dart';
import 'Folder.dart';
import 'FileHomeScreen.dart';
class FolderHomeScreen extends StatefulWidget {
  @override
  _FolderHomeScreenState createState() => _FolderHomeScreenState();
}

class _FolderHomeScreenState extends State<FolderHomeScreen> {
  List<Folder> _folders = [];
  final TextEditingController _searchController = TextEditingController();
  List<Folder> _filteredFolders = [];
  DatabaseReference? _folderRef;
  PageController _pageController = PageController();

  @override
  void initState() {
    super.initState();
    _initializeFirebase();
    _searchController.addListener(_onSearchChanged);
    _filteredFolders = List.from(_folders);
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
                Navigator.of(context).pop();   },
            ),
            TextButton(
              child: Text("Erstellen"),
              onPressed: () async {
                DatabaseReference folderRef = _folderRef!.push();
                await folderRef.set({'name': folderNameController.text});
                setState(() {
                  _folders.add(Folder(
                      name: folderNameController.text, key: folderRef.key!));
                });   Navigator.of(context).pop();
              },   ),
          ], );
      }, );
  }

  @override
  Widget build(BuildContext context) {
    double screenWidth = MediaQuery.of(context).size.width;
    double screenHeight = MediaQuery.of(context).size.height;
    // Anpassbare Größen und Abstände
    double textFieldWidth = screenWidth * 0.7;
    double textFieldHeight = screenHeight * 0.07;
    double gridPaddingHorizontal = screenWidth * 0.05;
    double gridPaddingVertical = screenHeight * 0.025;
    return Scaffold(
      body: Container(
        padding: EdgeInsets.only(top: screenHeight * 0.10 , left: gridPaddingHorizontal, right: gridPaddingHorizontal), // Increase the top padding to move content down
        decoration: const BoxDecoration(
          borderRadius: BorderRadius.horizontal(
            left: Radius.circular(10),
            right: Radius.circular(10),
          ),
          gradient: LinearGradient(
            colors: [
              Color(0xFF272928),
              Color(0xFF4D5D68),
            ],
            begin: Alignment.centerRight,
            end: Alignment.centerLeft,
          ),
        ),
        child: Column(
          children: [
            Padding(
              padding: EdgeInsets.symmetric(horizontal: gridPaddingHorizontal, vertical: gridPaddingVertical),
              child: Container(
                width: textFieldWidth,
                height: textFieldHeight,
              child: TextField(
                  onChanged: (value) {
                    _filterFolders();  },
                  controller: _searchController,
                  decoration: InputDecoration (
                    labelText: 'Suche',
                    labelStyle: TextStyle(color: Colors.white),
                    hintText: 'Suchbegriff eingeben',
                    hintStyle: TextStyle(color: Colors.blueGrey),
                    prefixIcon: Icon(Icons.search, color: Colors.white), // Update the icon color
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.all(
                        Radius.circular(25.0),
                      ),),
                    enabledBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.all(
                        Radius.circular(25.0),
                      ),
                      borderSide: BorderSide(color: Colors.grey, width: 2.0), // Update the enabled border color and width
                    ),
                    focusedBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.all(
                        Radius.circular(25.0),
                      ),
                      borderSide: BorderSide(color: Colors.white, width: 2.0), // Update the focused border color and width
                    ),
                    contentPadding: EdgeInsets.symmetric(vertical: 10.0, horizontal: 10.0),
                  ),
                  style: TextStyle(fontSize:  MediaQuery.of(context).textScaleFactor *16, color: Colors.white),
                ), ), ),
            SizedBox(height: screenWidth * 0.02),
            Expanded(
              child: AnimationLimiter(
                child: Column(
                  children: [  Expanded(
                      child: PageView.builder(
                        controller: _pageController,
                        scrollDirection: Axis.horizontal,
                        itemCount: _filteredFolders.isNotEmpty ? (_filteredFolders.length / 8).ceil() : 1,
                        itemBuilder: (BuildContext context, int pageIndex) {
                          return Container(
                            width: MediaQuery.of(context).size.width,
                            child: GridView.builder(
                              itemCount: min(8, _filteredFolders.length - pageIndex * 8),
                              padding: EdgeInsets.symmetric(horizontal: gridPaddingHorizontal, vertical: gridPaddingVertical),
                              gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                                crossAxisCount: 2,
                                childAspectRatio: 2,
                                mainAxisSpacing: screenHeight * 0.04,
                                crossAxisSpacing: 9.0,
                              ),
                              itemBuilder: (BuildContext context, int index) {
                                Folder folder = _filteredFolders[pageIndex * 8 + index];
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
                                              builder: (context) => FileHomeScreen(folder: folder),
                                            ),
                                          );
                                        },
                                        child: Container(
                                          child: Column(
                                            mainAxisAlignment: MainAxisAlignment.center,
                                            crossAxisAlignment: CrossAxisAlignment.center,
                                            children: [
                                              Container(
                                                alignment: Alignment.center,
                                                height: MediaQuery.of(context).size.height * 0.06, // 6% der Bildschirmhöhe für das Icon
                                                child: Icon(
                                                  Icons.folder,
                                                  size: screenWidth * 0.13,
                                                  color: Colors.white,
                                                ),
                                              ),
                                              SizedBox(height: screenHeight * 0.01), // You might want to adjust this
                                              Flexible(
                                                child: Container(
                                                  alignment: Alignment.center,
                                                  height: MediaQuery.of(context).size.height * 0.03, // 2% der Bildschirmhöhe für den Text
                                                  child: Text(
                                                    folder.name,
                                                    textAlign: TextAlign.center,
                                                    maxLines: 2,
                                                    overflow: TextOverflow.ellipsis,
                                                    style: TextStyle(
                                                      color: Colors.white,
                                                      fontSize: MediaQuery.of(context).textScaleFactor * 16,
                                                    ),
                                                  ),
                                                ),
                                              ),
                                            ],
                                          ),
                                        ),),
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
                        count: _filteredFolders.isNotEmpty ? (_filteredFolders.length / 8).ceil() : 1,
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
        child: Icon(Icons.add_comment_rounded  ,
    size: MediaQuery.of(context).size.width* 0.07,),
        backgroundColor: Colors.transparent,
        elevation: 0,
        splashColor: Colors.transparent,
      ), );
  }
}
