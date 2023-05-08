import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:firebase_database/ui/firebase_animated_list.dart';
import 'package:flutter/material.dart';
import 'package:get/get_navigation/src/root/get_material_app.dart';

import '../home_video.dart';
import '_insert.dart';
import '_update.dart';

/*void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  runApp(MyApp());
}

 */

class addGrupp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'realtime CRUD',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: HomeGruppe(),
    );
  }
}

class HomeGruppe extends StatefulWidget {
  @override
  _HomeGruppeState createState() => _HomeGruppeState();
}

class _HomeGruppeState extends State<HomeGruppe> {
  DatabaseReference db_Ref = FirebaseDatabase.instance.ref().child('UserDataFile');

  void _navigateToMyVideoHomePage() {
    Navigator.pushReplacement(
      context,
      MaterialPageRoute(
        builder: (context) => MyVideoHomePage(),
      ),
    );
  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: StreamBuilder<DatabaseEvent>(
        stream: db_Ref.onValue,
        builder: (BuildContext context, AsyncSnapshot<DatabaseEvent> snapshot) {
          if (snapshot.connectionState == ConnectionState.active) {
            if (snapshot.hasData) {
              _navigateToMyVideoHomePage();
            }
            return Container(); // Hier können Sie einen leeren Container zurückgeben oder die ursprünglichen Widgets beibehalten, je nach Bedarf
          } else {
            return Center(
              child: CircularProgressIndicator(),
            );
          }
        },
      ),
    );
  }
}





