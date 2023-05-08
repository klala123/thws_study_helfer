
import 'package:flutter/material.dart';

import 'app_theme.dart';
import 'drawer_user_controller.dart';
import 'feedback_screen.dart';
import 'help_screen.dart';
import 'home_drawer.dart';
import 'home_screen.dart';
import 'home_video.dart';
import 'invite_friend_screen.dart';


class NavigationVideoScreen extends StatefulWidget {
  @override
  _NavigationVideoScreenState createState() => _NavigationVideoScreenState();
}

class _NavigationVideoScreenState extends State<NavigationVideoScreen> {
  Widget? screenView;
  DrawerIndex? drawerIndex;

  @override
  void initState() {
    drawerIndex = DrawerIndex.Video;
    screenView =  MyVideoHomePage();
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
            screenView =  MyHomePage();
          });
          break;

        case DrawerIndex.Video:
          setState(() {
            screenView =  MyVideoHomePage();
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
