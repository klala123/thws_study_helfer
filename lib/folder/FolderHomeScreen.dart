

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
  String _searchQuery = '';
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

  //---------------------------------

  @override
  Widget build(BuildContext context) {

    // Bildschirmgröße und Skalierungsfaktoren
    double screenWidth = MediaQuery.of(context).size.width;
    double screenHeight = MediaQuery.of(context).size.height;
    double textScaleFactor = MediaQuery.of(context).textScaleFactor;
    // Anpassbare Größen und Abstände
    double textFieldWidth = screenWidth * 0.7;
    double textFieldHeight = screenHeight * 0.07;
    double gridPaddingHorizontal = screenWidth * 0.05;
    double gridPaddingVertical = screenHeight * 0.025;
    double iconSize = screenWidth * 0.075;
    double textSize = 18.0 * textScaleFactor;

    return Scaffold(
      backgroundColor: Color(0xFF111010),
      body: Container(
        padding: EdgeInsets.symmetric(horizontal: gridPaddingHorizontal, vertical: screenHeight * 0.06),
        decoration: const BoxDecoration(

          borderRadius: BorderRadius.horizontal(
            left: Radius.circular(10),
            right: Radius.circular(10),

          ),
          gradient: LinearGradient(
            colors: [
              // Color(0xFFDADDDF)
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
                    _filterFolders();
                  },
                  controller: _searchController,
                  decoration: InputDecoration (
                    labelText: 'Search',
                    labelStyle: TextStyle(color: Colors.white),
                    hintText: 'Enter a search term',
                    hintStyle: TextStyle(color: Colors.blueGrey),
                    prefixIcon: Icon(Icons.search, color: Colors.white), // Update the icon color
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.all(
                        Radius.circular(25.0),
                      ),
                    ),

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
                ),
              ),
            ),
            SizedBox(height: screenWidth * 0.02),
            Expanded(
              child: AnimationLimiter(
                child: Column(
                  children: [
                    Expanded(
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
                                mainAxisSpacing: 9.0,
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
                                                height: MediaQuery.of(context).size.height * 0.08,
                                                width: MediaQuery.of(context).size.width * 0.08,
                                                child: Stack(
                                                  children: [
                                                    Align(
                                                      alignment: Alignment.center,
                                                      child: Icon(
                                                        Icons.folder,
                                                        size: iconSize ,
                                                        color: Colors.white,
                                                      ),
                                                    ),
                                                    Align(
                                                      alignment: Alignment.bottomCenter,
                                                      child: Padding(
                                                        padding: const EdgeInsets.only(bottom: 0.0, top: 30),
                                                        child: Text(
                                                          folder.name,
                                                          style: TextStyle(
                                                            color: Colors.white,
                                                            fontSize:  MediaQuery.of(context).textScaleFactor * 14 ,
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
      floatingActionButton: LayoutBuilder(
        builder: (BuildContext context, BoxConstraints constraints) {
          double screenWidth = MediaQuery.of(context).size.width;
          double buttonWidth = screenWidth * 0.25; // 50% der Bildschirmbreite
          // 50% der Bildschirmbreite
          double textScaleFactor = MediaQuery.of(context).textScaleFactor;

          return Container(
            width: buttonWidth,
            height: 40,
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(30),
              boxShadow: [
                BoxShadow(
                  color: Colors.black12,
                  offset: Offset(0, 3),
                  blurRadius: 6,
                ),
              ],
            ),
            child: ElevatedButton(
              onPressed: _createFolder,
              style: ElevatedButton.styleFrom(
                primary: Colors.blueGrey,
                elevation: 0,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(30),
                ),
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  SizedBox(width: 8),
                  Text(
                    'Erstellen',
                    style: TextStyle(color: Colors.white, fontSize: 14 * MediaQuery.of(context).textScaleFactor),
                  ),
                ],
              ),
            ),
          );
        },
      ),
    );
  }



}
