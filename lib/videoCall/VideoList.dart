import 'dart:async';
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
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

//---------------------------------------------------------------
  static Future<void> init() async {
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
              navigateScreen: JoinVideoScreen(title: value['name'], conferenceID:key,),
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
              conferenceID: key,
            ),
          ));
        });
      }
      return tempList;
    });
  }


  }




