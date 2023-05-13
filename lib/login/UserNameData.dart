
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/cupertino.dart';

class UserName extends StatefulWidget {
  String userName = 'yoOor Name';



  @override
  _HomeUserName createState() => _HomeUserName();
}

class _HomeUserName extends State<UserName> {
  String userName = 'yoOor Name';

  Future<void> getUserName() async {
    final user = FirebaseAuth.instance.currentUser;
    if (user != null) {
      DatabaseReference usersRef = FirebaseDatabase.instance.reference().child(
          'users');
      DataSnapshot dataSnapshot = (await usersRef.child(user.uid).once())
          .snapshot;

      if (dataSnapshot.value is Map<dynamic, dynamic>) {
        Map<dynamic, dynamic> values = dataSnapshot.value as Map<
            dynamic,
            dynamic>;
        setState(() {
          userName = values['name'] ?? 'Unbekannter Name';
        });
      }
    }
  }

    @override
    Widget build(BuildContext context) {
      // TODO: implement build
      throw UnimplementedError();
    }
  }
