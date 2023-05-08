
import 'package:flutter/material.dart';
import 'app_theme.dart';
import 'drawer_user_controller.dart';
import 'feedback_screen.dart';
import 'help_screen.dart';
import 'home_drawer.dart';
import 'home_screen.dart';
import 'invite_friend_screen.dart';
import 'model/datei_screen.dart';


class NavigationHomeScreen extends StatefulWidget {
  @override
  _NavigationHomeScreenState createState() => _NavigationHomeScreenState();
}

class _NavigationHomeScreenState extends State<NavigationHomeScreen> {
  Widget? screenView;
  DrawerIndex? drawerIndex;

  @override
  void initState() {
    drawerIndex = DrawerIndex.HOME;
    screenView =  MyHomePage();
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
         // backgroundColor:   ThemeColor.createMaterialColor(Color(0xFFEDDDC9)) ,
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
        case DrawerIndex.Datei:
          setState(() {
            screenView = FileStorageScreen();
          });

          break;
        default:
          break;
      }
    }
  }
}
