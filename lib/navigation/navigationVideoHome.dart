import 'package:flutter/material.dart';
import '../app_theme.dart';
import '../custom_drawer/drawer_user_controller.dart';
import '../scound_screens/feedback_screen.dart';
import '../scound_screens/help_screen.dart';
import '../custom_drawer/home_drawer.dart';
import '../todo/TodoListPage.dart';
import '../videoCall/VideoHomeScreen.dart';
import '../scound_screens/invite_friend_screen.dart';
import 'navigationHomeScreen.dart';
import 'navigationToDoScreen.dart';

class NavigationVideoScreen extends StatefulWidget {
  @override
  _NavigationVideoScreenState createState() => _NavigationVideoScreenState();
}
//----------------------------------------------------------------------------------
class _NavigationVideoScreenState extends State<NavigationVideoScreen> {
  Widget? screenView;
  DrawerIndex? drawerIndex;
//----------------------------------------------------------------------------------
  @override
  void initState() {
    drawerIndex = DrawerIndex.Video;
    screenView =  VideoHomeScreen();
    super.initState();
  }
//----------------------------------------------------------------------------------
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
//----------------------------------------------------------------------------------
  void changeIndex(DrawerIndex drawerIndexdata) {
    if (drawerIndex != drawerIndexdata) {
      drawerIndex = drawerIndexdata;
      switch (drawerIndex) {
        case DrawerIndex.HOME:
          Navigator.of(context).pushAndRemoveUntil(
              MaterialPageRoute(builder: (context) => NavigationHomeScreen()),
                  (route) => false
          );
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

        case DrawerIndex.ToDoList:
          setState(() {
            screenView = NavigationToDoScreen() ;
            //TodoListPage () ;
            //TodoList();
            //FolderHomeScreen();
          });
          break;
        default:
          break;
      }
    }
  }
}
