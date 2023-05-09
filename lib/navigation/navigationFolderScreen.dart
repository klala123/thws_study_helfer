
import 'package:flutter/material.dart';
import 'package:thws_study_helfer/folder/FolderHomeScreen.dart';
import '../app_theme.dart';
import '../custom_drawer/drawer_user_controller.dart';
import '../scound_screens/feedback_screen.dart';
import '../scound_screens/help_screen.dart';
import '../custom_drawer/home_drawer.dart';
import '../StartScreen.dart';
import '../videoCall/VideoHomeScreen.dart';
import '../scound_screens/invite_friend_screen.dart';

class NavigationFolderScreen extends StatefulWidget {
  @override
  _NavigationFolderScreenState createState() => _NavigationFolderScreenState();
}

class _NavigationFolderScreenState extends State<NavigationFolderScreen> {
  Widget? screenView;
  DrawerIndex? drawerIndex;

  @override
  void initState() {
    drawerIndex = DrawerIndex.Video;
    screenView =  FolderHomeScreen();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      color: AppTheme.white,
      child: SafeArea(
        top: false,
        bottom: false,
        child: Scaffold(
          // backgroundColor:   ,
          body: DrawerUserController(


            screenIndex: drawerIndex,
            drawerWidth: MediaQuery.of(context).size.width * 0.75,
            onDrawerCall: (DrawerIndex drawerIndexdata) {
              changeIndex(drawerIndexdata);
              //callback from drawer for replace screen as user need with passing DrawerIndex(Enum index)
            },
            screenView: screenView,


            //we replace screen view as we need on navigate starting screens like MyHomePage, HelpScreen, FeedbackScreen, etc...
          ),
        ),
      ),
    );
  }

  void changeIndex(DrawerIndex drawerIndexdata) {
    if (drawerIndex != drawerIndexdata) {
      drawerIndex = drawerIndexdata;
      switch (drawerIndex) {
        case DrawerIndex.HOME:
          setState(() {
            screenView =  StartScreen();
          });
          break;

        case DrawerIndex.Video:
          setState(() {
            screenView =  VideoHomeScreen();
          });
          break;

        case DrawerIndex.Help:
          setState(() {
            screenView = HelpScreen();
          });
          break;
        case DrawerIndex.FeedBack:
          setState(() {
            screenView = FeedbackScreen();
          });
          break;
        case DrawerIndex.Invite:
          setState(() {
            screenView = InviteFriend();
          });
          break;
        default:
          break;
      }
    }
  }
}
