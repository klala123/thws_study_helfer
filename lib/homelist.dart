
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:url_launcher/url_launcher_string.dart';
import 'navigation/navigationFolderScreen.dart';
import 'navigation/navigationVideoHome.dart';
import 'folder/FolderHomeScreen.dart';

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
      imagePath: 'assets/images/img_3.png',
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
      imagePath:'assets/images/campusportal.jpg',
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
      imagePath: 'assets/images/img2.png',
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
      imagePath: 'assets/images/img_2.png',

      navigateScreen: Builder(
        builder: (BuildContext c){
          _THWS_NewslanchURL() ;
          Navigator.pop(c);
          return Container();
        },
      )
    ),

    HomeList(
      title: 'Gemeinsamer Lern-Call',
     imagePath: 'assets/images/gruppen.jpg',
      navigateScreen:NavigationVideoScreen(),
    ),

    HomeList(
      title: 'Lernmaterialien',
     imagePath: 'assets/images/folder.jpg',
      navigateScreen: NavigationFolderScreen(),
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
