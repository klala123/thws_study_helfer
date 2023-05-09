import 'dart:async';

import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import '../UserData.dart';
import '../videoScreen.dart';

class videoHomeList {
  videoHomeList({
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
  static List<videoHomeList> homeList = [ ] ;

  //---------------------------------------------------------------------
  static String entferneLeerzeichen(String eingabe) {
    return eingabe.replaceAll("\\s", "");
  }


  static void addInitData (){
    homeList.addAll( [
      videoHomeList(
        imagePath: 'assets/images/ElementHintergrund.png',
        isFromGallery: false,
        title: 'Algebra Gruppe ',
        navigateScreen: ZumVideoCallPage(title: 'Algebra', conferenceID: '11',),
      ),
      videoHomeList(
          imagePath: 'assets/images/ElementHintergrund.png',
          isFromGallery: false,
          title: 'Prog Gruppe ',
          navigateScreen: ZumVideoCallPage(title: 'Prog2', conferenceID: '12',)
      ),
      videoHomeList(
          imagePath: 'assets/images/ElementHintergrund.png',
          isFromGallery: false,
          title: 'Datenbank Gruppe ',
          navigateScreen: ZumVideoCallPage(title: 'Datenbank', conferenceID: '14',)
      ),
    ]);
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
            videoHomeList(
              key: key,
              imagePath: value['url'],
              groupKey: value['id'],
              isFromGallery: false,
              title: value['name'],
              navigateScreen: ZumVideoCallPage(title: value['name'], conferenceID:entferneLeerzeichen( value['name']),),
            )
        );
      });
    }
  }

//-----------------------------------------------------------
  static Stream<List<videoHomeList>> getVideoHomeListStream() {
    final databaseReference = FirebaseDatabase.instance.reference();
    DatabaseReference dbRef = databaseReference.child('data');

    return dbRef.onValue.map((event) {
      List<videoHomeList> tempList = [];
      DataSnapshot snapshot = event.snapshot;
      if (snapshot.value is Map) {
        Map<String, dynamic> videoMap =
        Map<String, dynamic>.from(snapshot.value as Map<dynamic, dynamic>);
        videoMap.forEach((key, value) {
          tempList.add(videoHomeList(
            key: key,
            groupKey: value['id'],
            imagePath: value['url'],
            isFromGallery: false,
            title: value['name'],
            navigateScreen: ZumVideoCallPage(
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




