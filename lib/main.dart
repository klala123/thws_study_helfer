import 'dart:async';
import 'dart:io';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import 'package:thws_study_helfer/videoCall/VideoList.dart';
import 'package:thws_study_helfer/navigation/navigationHomeScreen.dart';
import 'package:thws_study_helfer/videoCall/JoinVideoScreen.dart';
import 'package:firebase_auth/firebase_auth.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  await VideoList.init();

  runApp(MyApp());
}
//______________________________________________
class MyApp extends StatelessWidget {
   MyApp({super.key});




  // This widget is the root of your application
  @override
  Widget build(BuildContext context) {
    SystemChrome.setSystemUIOverlayStyle(SystemUiOverlayStyle(
      statusBarColor: Colors.transparent,
      statusBarIconBrightness: Brightness.dark,
      statusBarBrightness: !kIsWeb && Platform.isAndroid ? Brightness.dark : Brightness.light,
      systemNavigationBarColor: Colors.white,
      systemNavigationBarDividerColor: Colors.transparent,
      systemNavigationBarIconBrightness: Brightness.dark,
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

class MyHomePage extends StatefulWidget {



  const MyHomePage({super.key, required this.title});
  final String title;
  @override
  State<MyHomePage> createState() => _MyHomePageState();
}
//________________________________________________________________

class _MyHomePageState extends State<MyHomePage> {

  final StreamController<VideoList> _streamController = StreamController<VideoList>();
  DatabaseReference dbRef = FirebaseDatabase.instance.ref().child('data');

  Future<void> signInAnonymously() async {
    FirebaseAuth auth = FirebaseAuth.instance;

    try {
      UserCredential userCredential = await auth.signInAnonymously();
      print("Benutzer  id ${userCredential}");
    } on FirebaseAuthException catch (e) {
      print("FFehlerrr");
    }
  }

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

  void updateVideoHomeList(List<VideoList> newList) {
    setState(() {
      VideoList.homeList = newList;
    });
  }

  @override
  void initState() {
    String? lastKey;

    if (VideoList.homeList.isNotEmpty) {
      lastKey = VideoList.homeList.last.key;
    }
    videosData(lastKey);
    updateVideoHomeList(VideoList.homeList);
    signInAnonymously();
    super.initState();
  }



/*
  @override
  Widget build(BuildContext context) {
    return StreamBuilder<videoHomeList>(
      stream: _streamController.stream,
      builder: (BuildContext context, AsyncSnapshot<videoHomeList> snapshot) {
        if (snapshot.hasData) {
          videoHomeList.homeList.add(snapshot.data!);
        }
        return NavigationHomeScreen();
      },
    );
  }
}

 */

  @override
  Widget build(BuildContext context) {
    return StreamBuilder<VideoList>(
      stream: _streamController.stream,
      builder: (BuildContext context, AsyncSnapshot<VideoList> snapshot) {
        if (snapshot.hasData) {
          VideoList.homeList.add(snapshot.data!);
        }
        return NavigationHomeScreen();
      },
    );
  }
}

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
