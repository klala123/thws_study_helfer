
import 'dart:async';
import 'dart:io';
import 'dart:math';
import 'package:firebase_database/firebase_database.dart';
import 'AddVideoCallGroupp.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:flutter/cupertino.dart';
import 'VideoList.dart';
import 'package:smooth_page_indicator/smooth_page_indicator.dart';


class VideoHomeScreen extends StatefulWidget {
  const VideoHomeScreen({Key? key}) : super(key: key);

  @override
  _VideoHomeScreenState createState() => _VideoHomeScreenState();
}

//-------------------------------------------------------------------------------------
// Die klasse erhält die Fähigkeit, Ticker bereitzustellen, die von Animation verwendet werden
class _VideoHomeScreenState extends State<VideoHomeScreen> with TickerProviderStateMixin {
  List<VideoList> homeList = VideoList.homeList;
  // Um die Animation zu steueren (Bsp : stoppen, starten,umkeren)
  AnimationController? animationController;
  bool multiple = true;
  TextEditingController _textController = TextEditingController();
  String? _selectedImagePath;
  String? _searchQuery;
  bool checkNeuElement = false ;

//-------------------------------------------------------------------------------------
// Funktion zum Auswählen eines Bildes aus der Galerie
  Future<void> _pickImage() async {
    final ImagePicker _picker = ImagePicker();
    final XFile? pickedFile = await _picker.pickImage(source: ImageSource.gallery);

    if (pickedFile != null) {
      setState(() {
        _selectedImagePath = pickedFile.path;
      });
    }
  }


//-------------------------------------------------------------------------------------

  @override
  void initState() {
    animationController = AnimationController(
      // vsync : this --> Verbindet Animation Controller mit der Tickerprovider der Klasse _MyHomePageState
        duration: const Duration(milliseconds: 1500), vsync: this);
    //_searchFieldFocusNode = FocusNode();
    super.initState();
  }
//-------------------------------------------------------------------------------------
  Future<bool> getData() async {
    await Future<dynamic>.delayed(const Duration(milliseconds: 0));
    return true;
  }
//-------------------------------------------------------------------------------------
  // Um elemente aus dem Widget Baum zu entfernen
  /*
  Das Aufrufen von dispose() auf dem animationController gibt die Ressourcen frei,
  die von diesem AnimationController belegt wurden,
   */

  @override
  void dispose() {
    animationController?.dispose();
  //  _searchFieldFocusNode.dispose();
    super.dispose();
  }
//-------------------------------------------------------------------------------------

  String searchText = '';
  //FocusNode _searchFieldFocusNode = FocusNode();

  TextEditingController _searchController = TextEditingController();

  void _filterGroupList(String searchQuery) {
    setState(() {
      searchText = searchQuery;
    });
  }

  TextField getTextField (){
    return    TextField(
      onChanged: (value) {
        setState(() {
          searchText = value;
        });
      },
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
      style: TextStyle(fontSize: MediaQuery.of(context).textScaleFactor * 14 , color: Colors.white), // Update the text color
      cursorColor: Colors.white, // Update the cursor color
    );
  }
//----------------------------------------------------

  Future<void> _deleteGroup(String groupName) async {
   // Fetch Data
    final DatabaseReference databaseReference = FirebaseDatabase.instance.reference();
    String? groupId;

    await databaseReference
        .child('data')
        .orderByChild('id')
        .equalTo(groupName)
        .once()
        .then((DatabaseEvent event) {
      DataSnapshot dataSnapshot = event.snapshot;
      Map<String, dynamic>? data = dataSnapshot.value is Map<dynamic, dynamic> ? Map<String, dynamic>.from(dataSnapshot.value as Map<dynamic, dynamic>) : null;

      if (data != null) {
        data.forEach((key, value) {
          groupId = key;
        });
        print("Gruppen-ID für den Namen '$groupName' ist: $groupId");
      } else {
        print("Keine Gruppe mit dem Namen '$groupName' gefunden.");
      }
    }).catchError((error) {
      print('Fehler beim Abrufen der Gruppeninformationen: $error');
    });

    if(groupId != null ){
      _delet(groupId!);
    }
  }

  void _delet(String key ) {
    final DatabaseReference databaseReference = FirebaseDatabase.instance.reference();
    databaseReference.child('data').child(key).remove().then((_) {
      print('Gruppe mit Key $key wurde erfolgreich gelöscht');
    }).catchError((error) {
      print('Fehler beim Löschen der Gruppe: $error');
    });
  }
  //------------------------------------------------------




  @override
  Widget build(BuildContext context) {
    var brightness = MediaQuery.of(context).platformBrightness;
    bool isLightMode = brightness == Brightness.light;

    double screenWidth = MediaQuery.of(context).size.width;
    double screenHeight = MediaQuery.of(context).size.height;

    double horizontalPadding = screenWidth * 0.08;
    double gridViewSpacing = screenHeight * 0.02;
    double childAspectRatio = 3;

    return Scaffold(
      //backgroundColor: Color(0xFF111010),
      appBar: PreferredSize(

        preferredSize: Size.fromHeight(AppBar().preferredSize.height),
        child: appBar(),
      ),
      body: Container(
        decoration: const BoxDecoration(

         // borderRadius: BorderRadius.horizontal(
           // left: Radius.circular(10),
            //right: Radius.circular(10),

         // ),
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
        /*
        decoration: BoxDecoration(
          image: DecorationImage(
            image: AssetImage('assets/images/hintergrundBild.png'),
            fit: BoxFit.cover,
          ),

        ),
        */
        child: Column(
          children: [
            Padding(
              padding: EdgeInsets.only(top: screenHeight * 0.08, left: horizontalPadding, right: horizontalPadding, bottom: screenHeight * 0.02),
              child: getTextField(),
            ),
            Expanded(
              child: StreamBuilder<List<VideoList>>(
                  stream: VideoList.getVideoHomeListStream(),
                  builder: (context, snapshot) {
                    if (snapshot.connectionState == ConnectionState.waiting) {
                      return Center(child: CircularProgressIndicator());
                    } else if (snapshot.hasData) {
                      List<VideoList>? homeList = snapshot.data;

                      // Create a list of group widgets
                      List<Widget> groupWidgets = [];
                      int count = 0;

                      for (int i = 0; i < homeList!.length; i++) {
                        if (homeList[i]
                            .title
                            .toLowerCase()
                            .contains(searchText.toLowerCase())) {
                          count++;
                          final Animation<double> animation =
                          Tween<double>(begin: 0.0, end: 1.0).animate(
                            CurvedAnimation(
                              parent: animationController!,
                              curve: Interval((1 / count) * i, 1.0,
                                  curve: Curves.fastOutSlowIn),
                            ),
                          );
                          animationController?.forward();

                          groupWidgets.add(HomeListView(
                            animation: animation,
                            animationController: animationController,
                            listData: homeList[i],
                            callBack: () {
                              Navigator.push<dynamic>(
                                context,
                                MaterialPageRoute<dynamic>(
                                  builder: (BuildContext context) =>
                                  homeList[i].navigateScreen!,
                                ),
                              );
                            },
                            onDelete: () {
                              if (homeList[i].groupKey != null) {
                                _deleteGroup(homeList[i].groupKey!);
                                print("gelöscht");
                              }
                            },
                          ));
                        }
                      }

                      // Paginate the group widgets
                      List<Widget> pages = [];
                      int pageCount = (count / 3).ceil();
                      for (int i = 0; i < pageCount; i++) {
                        int startIndex = i * 3;
                        int endIndex = min(startIndex + 3, groupWidgets.length);
                        List<Widget> currentGroupWidgets =
                        groupWidgets.sublist(startIndex, endIndex);

                        pages.add(Padding(
                          padding: EdgeInsets.only(top: screenHeight * 0.1, left: horizontalPadding, right: horizontalPadding, bottom: screenHeight * 0.04),
                          child: GridView(
                            padding: EdgeInsets.all(0),
                            physics: const BouncingScrollPhysics(),
                            scrollDirection: Axis.vertical,
                            children: currentGroupWidgets,
                            gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                              crossAxisCount: 1,
                              mainAxisSpacing: gridViewSpacing,
                              crossAxisSpacing: gridViewSpacing,
                              childAspectRatio: childAspectRatio,
                            ),
                          ),
                        ));
                      }
                      // Create the PageController
                      final PageController pageController = PageController();

                      return Column(
                        children: [
                          Expanded(
                            child: PageView.builder(
                              controller: pageController,
                              itemBuilder: (BuildContext context, int index) {
                                return pages[index];
                              },
                              itemCount: pages.length,
                            ),
                          ),

                          // Add the DotsIndicator
                          Padding(
                            padding: EdgeInsets.only(bottom: screenHeight * 0.02),
                            child: SmoothPageIndicator(
                              controller: pageController,
                              count: pages.length,
                              effect: ExpandingDotsEffect(
                                dotHeight: 8,
                                dotWidth: 8,
                                dotColor: isLightMode ? Colors.grey : Colors.white,
                                activeDotColor:
                                isLightMode ? Colors.black : Colors.white,
                              ),
                            ),
                          ),
                        ],
                      );
                    } else {
                      return Center(child: Text("No data available"));
                    }
                  }),
            ),
          ],
        ),
      ),
      /*
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          Navigator.push(
            context,
            MaterialPageRoute(builder: (context) => AddVideoCallGroupp()),
          );
        },
        child: Icon(Icons.add),
        backgroundColor: Theme.of(context).primaryColor,
      ),

       */
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
              onPressed: () {
                Navigator.push(
                    context,
                    MaterialPageRoute(builder: (context) => AddVideoCallGroupp()) ) ;
              },
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







//-------------------------------------------------------------------------------------

  Widget appBar() {

    var brightness = MediaQuery.of(context).platformBrightness;
    bool isLightMode = brightness == Brightness.light;
    return Container(
      decoration: const BoxDecoration(

        // borderRadius: BorderRadius.horizontal(
        // left: Radius.circular(10),
        //right: Radius.circular(10),

        // ),
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
      child: SizedBox(

        height: AppBar().preferredSize.height,
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            Padding(
              padding: const EdgeInsets.only(top: 8, left: 8),
              child: Container(

                width: AppBar().preferredSize.height - 8,
                height: AppBar().preferredSize.height - 8,
              ),
            ),
            Expanded(
              child: Center(
                child: Padding(
                  padding: const EdgeInsets.only(top: 60),
                  child: Text(
                    'THWS StudiHelfer',
                    style: TextStyle(
                      fontSize: MediaQuery.of(context).textScaleFactor * 14,
                      color: Colors.white ,
                      //isLightMode ? AppTheme.darkText : AppTheme.white,
                      fontWeight: FontWeight.w700,
                    ),
                  ),
                ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.only(top: 60, right: 8),
              child: Container(
                width: AppBar().preferredSize.height - 8,
                height: AppBar().preferredSize.height - 8,
               // color: Colors.black,
                //isLightMode ? Colors.white : AppTheme.nearlyBlack,


              ),    ),   ], ),
      ),
    ); }


}

//-------------------------------------------------------------------------------------

class HomeListView extends StatelessWidget {
  const HomeListView(
      {Key? key,

        this.listData,
        this.callBack,
        this.animationController,
        this.animation,
        required this.onDelete ,
      })
      : super(key: key);
  final VoidCallback? onDelete;

  final VideoList? listData;
  final VoidCallback? callBack;
  final AnimationController? animationController;
  final Animation<double>? animation;

  void deleteGroup(String groupKey) {
    final DatabaseReference groupRef = FirebaseDatabase.instance.reference().child('groups');
    groupRef.child(groupKey).remove();
  }


  @override
  Widget build(BuildContext context) {
    // Bildschirmgröße und Skalierungsfaktor
    final screenWidth = MediaQuery.of(context).size.width;
    final screenHeight = MediaQuery.of(context).size.height;
    final textScaleFactor = MediaQuery.of(context).textScaleFactor;

    // Dynamische Schriftgröße, Abstände und Größen
    final fontSize = 20.0 * textScaleFactor;
    final borderRadius = 30.0 * (screenWidth / 400);
    final padding = EdgeInsets.all(8 * (screenWidth / 400));

    return AnimatedBuilder(
      animation: animationController!,
      builder: (BuildContext context, Widget? child) {
        return FadeTransition(
          opacity: animation!,
          child: Transform(
            transform: Matrix4.translationValues(
                0.0, 50 * (1.0 - animation!.value), 0.0),
            child: AspectRatio(
              aspectRatio: 1.5,
              child: ClipRRect(
                borderRadius: BorderRadius.all(Radius.circular(borderRadius)),
                child: Stack(
                  alignment: AlignmentDirectional.center,
                  children: <Widget>[
                    Positioned.fill(
                      child: listData!.isFromGallery
                          ? Image.file(
                        File(listData!.imagePath),
                        fit: BoxFit.cover,
                      )
                          : Image.asset(
                        listData!.imagePath,
                        fit: BoxFit.cover,
                      ),
                    ),
                    Positioned(
                      top: 15,
                      left: 40,
                      child: Text(
                        listData!.title,
                        style: TextStyle(
                          fontSize: fontSize,
                          fontWeight: FontWeight.bold,
                          color: Colors.black,
                        ),
                      ),
                    ),
                    Material(
                      color: Colors.transparent,
                      child: InkWell(
                        splashColor: Colors.grey.withOpacity(0.2),
                        borderRadius:
                        const BorderRadius.all(Radius.circular(12.0)),
                        onTap: callBack,
                      ),
                    ),
                    Positioned(
                      bottom: 8,
                      right: 8,
                      child: ScaleTransition(
                        scale: Tween<double>(begin: 0.0, end: 1.0).animate(
                          CurvedAnimation(
                            parent: animationController!,
                            curve: Curves.easeOutCubic,
                          ),
                        ),
                        child: Material(
                          color: Colors.transparent,
                          child: InkWell(
                            onTap: () {
                              if (onDelete != null) {
                                onDelete!();
                                print("onDelete-Callback wurde aufgerufen");
                              }
                            },
                            customBorder: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(30),
                            ),
                            child: Container(
                              decoration: BoxDecoration(

                                borderRadius: BorderRadius.circular(30),
                                boxShadow: [
                                  BoxShadow(

                                    color: Colors.black.withOpacity(0.15),
                                    blurRadius: 8,
                                    offset: Offset(0, 2),
                                  ),
                                ],
                                color: Colors.blueGrey,
                              ),
                              padding: EdgeInsets.all(8 * (screenWidth / 400)), // Padding innerhalb des Containers
                              margin: EdgeInsets.symmetric(horizontal: 12, vertical: 5), // Abstand um den Container herum

                              child: Icon(
                                Icons.delete,
                                color: Colors.white,
                              ),
                            ),
                          ),
                        ),
                      ),
                    )
                  ],
                ),
              ),
            ),
          ),
        );
      },
    );
  }
}


//-----------------------------------------------------------





