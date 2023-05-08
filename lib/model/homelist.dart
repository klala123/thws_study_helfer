
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:thws_study_helfer/VideoConference.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:url_launcher/url_launcher_string.dart';
import '../design_course/home_design_course.dart';
import '../fitness_app/fitness_app_home_screen.dart';
import '../home_video.dart';
import '../hotel_booking/hotel_home_screen.dart';
import '../introduction_animation/introduction_animation_screen.dart';
import '../navigationVideoHome.dart';
import '../videoScreen.dart';
import 'datei_screen.dart';

class HomeList {
  HomeList({
    this.navigateScreen,
    this.imagePath = '',
    this.title = '' ,
  });

  Widget? navigateScreen;
  String imagePath;
  String title;

  static List<HomeList> homeList = [


    HomeList(
      title: 'E-Learning',
      imagePath: 'assets/images/elementeHintergrund.png',
      // 'assets/images/hintergrundBild.png'
      navigateScreen: Builder(
        builder: (BuildContext c){
          _ElearninglanchURL() ;
          Navigator.pop(c);
          return Container();
        },
      )
    ),
    HomeList(
      title: 'Campus Portal ',
      imagePath: 'assets/images/elementeHintergrund.png',
      navigateScreen: Builder(
        builder: (BuildContext c){
          _CampuslanchURL() ;
          Navigator.pop(c);
          return Container();
        },
      )
    ),
    HomeList(
      title: 'Veranstaltungen',
      imagePath: 'assets/images/elementeHintergrund.png',
      navigateScreen:  Builder(
        builder: (BuildContext c){
          _VeranstaltunglanchURL() ;
          Navigator.pop(c);
          return Container();
        },
      )
    ),
    HomeList(
      title: 'THWS-NEWS',
      imagePath: 'assets/images/elementeHintergrund.png',

      navigateScreen: Builder(
        builder: (BuildContext c){
          _THWS_NewslanchURL() ;
          Navigator.pop(c);
          return Container();
        },
      )
    ),

    HomeList(
      title: 'Grupppen Learning',
     imagePath: 'assets/images/videoCall1.png',
      navigateScreen:NavigationVideoScreen(),
    ),

    HomeList(
      title: 'Study Ordner',
     imagePath: 'assets/images/elementeHintergrund.png',
      navigateScreen: FileStorageScreen(),
    ),
  ];

  static _ElearninglanchURL() async{
    const url = 'https://elearning.fhws.de/login/index.php';
      await launchUrlString(url);
  }

  static _CampuslanchURL() async{
    const url = 'https://campusportal.fhws.de/qisserver/pages/cs/sys/portal/hisinoneStartPage.faces';
    await launch(url);

  }

  static _VeranstaltunglanchURL() async{
    const url = 'https://fiw.thws.de/studium/';
    await launch(url);

  }

  static _THWS_NewslanchURL() async{
    const url = 'https://iwinews.fiw.fhws.de/app/';
    await launch(url);

  }


}
