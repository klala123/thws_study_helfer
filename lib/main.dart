import 'dart:async';
import 'dart:io';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:thws_study_helfer/StartScreen.dart';

import 'package:thws_study_helfer/videoCall/VideoList.dart';
import 'package:thws_study_helfer/navigation/navigationHomeScreen.dart';
import 'package:thws_study_helfer/videoCall/JoinVideoScreen.dart';
import 'package:firebase_auth/firebase_auth.dart';

import 'login/login_screen.dart';
import 'model/AuthService.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  await VideoList.init();

  runApp(MyApp());
}
//______________________________________________
class MyApp extends StatelessWidget {
   MyApp({super.key});

   String userName = 'yoOor Name';



  // This widget is the root of your application
  @override
  Widget build(BuildContext context) {
    SystemChrome.setSystemUIOverlayStyle(SystemUiOverlayStyle(
    ));

    return MaterialApp(
      debugShowCheckedModeBanner: false ,
      theme: ThemeData(
        //primarySwatch: ThemeColor.createMaterialColor(Color(0xFFEDD9C4)),
      ),
      home: const MyHomePage(title: 'THWS StudiHelfer'),
    );
  }
}

//--------------------------------------------------------------------------
class MyHomePage extends StatefulWidget {
  const MyHomePage({super.key, required this.title});
  final String title;
  @override
  State<MyHomePage> createState() => _MyHomePageState();
}
//________________________________________________________________

class _MyHomePageState extends State<MyHomePage> {
  User? user ;
  FirebaseAuth auth = FirebaseAuth.instance;

  final StreamController<VideoList> _streamController = StreamController<VideoList>();
  DatabaseReference dbRef = FirebaseDatabase.instance.ref().child('data');


//------------------------------------------------

  Future<void> videosData(String? lastKey) async {
    Query query = dbRef.orderByKey();

    if (lastKey != null) {
      query = query.startAfter(lastKey);
    }

    query.onChildAdded.listen((event) {
      DataSnapshot snapshot = event.snapshot;
      if (snapshot.value is Map) {
        Map<String, dynamic> value = Map<String, dynamic>.from(snapshot.value as Map<dynamic, dynamic>);
        VideoList videoHomeListItem = VideoList(
          key: snapshot.key,
          imagePath: value['url'],
          isFromGallery: false,
          title: value['name'],
          navigateScreen: JoinVideoScreen(
            title: value['name'],
            conferenceID: '343',
          ),
        );
        _streamController.add(videoHomeListItem);
      }
    });
  }
//----------------------------------------------------------
  void updateVideoHomeList(List<VideoList> newList) {
    setState(() {
      VideoList.homeList = newList;
    });
  }
//-----------------------------------------------------
  @override
  void initState() {
    super.initState();
    String? lastKey;

    if (VideoList.homeList.isNotEmpty) {
      lastKey = VideoList.homeList.last.key;
    }
    videosData(lastKey);
    updateVideoHomeList(VideoList.homeList);

    if(mounted) {
      auth.authStateChanges().listen((User? user) {
        setState(() {
          AuthService().setUser(user);
          this.user = user;
          print("KlalaUserId : ${user}");
          print("KlalaUserId"); //Hier hinzugefügt
        });
      });
    }

  }


//-----------------------------------------------------
  @override
  Widget build(BuildContext context) {
    return StreamBuilder<VideoList>(
      stream: _streamController.stream,
      builder: (BuildContext context, AsyncSnapshot<VideoList> snapshot) {
        if (snapshot.hasData) {
          VideoList.homeList.add(snapshot.data!);
        }
         if (AuthService().user != null) return NavigationHomeScreen();
        else return LoginScreen();

        //NavigationHomeScreen();
          //NavigationHomeScreen();
      },
    );
  }
}

//-----------------------------------------------------
class HexColor extends Color {
  HexColor(final String hexColor) : super(_getColorFromHex(hexColor));

  static int _getColorFromHex(String hexColor) {
    hexColor = hexColor.toUpperCase().replaceAll('#', '');
    if (hexColor.length == 6) {
      hexColor = 'FF' + hexColor;
    }
    return int.parse(hexColor, radix: 16);
  }
}
