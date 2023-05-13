import 'dart:async';

import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import '../model/UserData.dart';
import 'JoinVideoScreen.dart';

class VideoList {
  VideoList({
    this.key,
    this.navigateScreen,
    this.imagePath = '',
    this.isFromGallery = false,
    this.title = '' ,
    this.groupKey,
  });

  Widget? navigateScreen;
  String imagePath;
  bool isFromGallery;
  String title;
  String? key;
  String? groupKey;


  final databaseReference = FirebaseDatabase.instance.reference();
  static List<VideoList> homeList = [ ] ;

  //---------------------------------------------------------------------
  static String entferneLeerzeichen(String eingabe) {
    return eingabe.replaceAll("\\s", "");
  }

//---------------------------------------------------------------
  static Future<void> init() async {
    // Add initial data
    //addInitData();
    DatabaseReference dbRef = FirebaseDatabase.instance.ref().child('data');
    DatabaseEvent event = await dbRef.once();
    DataSnapshot snapshot = event.snapshot;

    if (snapshot.value is Map) {
      Map<String, dynamic> videoMap = Map<String, dynamic>.from(snapshot.value as Map<dynamic, dynamic>);

      videoMap.forEach((key, value) {
        homeList.add(
            VideoList(
              key: key,
              imagePath: value['url'],
              groupKey: value['id'],
              isFromGallery: false,
              title: value['name'],
              navigateScreen: JoinVideoScreen(title: value['name'], conferenceID:entferneLeerzeichen( value['name']),),
            )
        );
      });
    }
  }

//-----------------------------------------------------------
  static Stream<List<VideoList>> getVideoHomeListStream() {
    final databaseReference = FirebaseDatabase.instance.reference();
    DatabaseReference dbRef = databaseReference.child('data');

    return dbRef.onValue.map((event) {
      List<VideoList> tempList = [];
      DataSnapshot snapshot = event.snapshot;
      if (snapshot.value is Map) {
        Map<String, dynamic> videoMap =
        Map<String, dynamic>.from(snapshot.value as Map<dynamic, dynamic>);
        videoMap.forEach((key, value) {
          tempList.add(VideoList(
            key: key,
            groupKey: value['id'],
            imagePath: value['url'],
            isFromGallery: false,
            title: value['name'],
            navigateScreen: JoinVideoScreen(
              title: value['name'],
              conferenceID: entferneLeerzeichen( value['name']),
            ),
          ));
        });
      }
      return tempList;
    });
  }


  }




