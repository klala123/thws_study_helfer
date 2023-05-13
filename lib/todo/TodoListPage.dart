import 'package:flutter/material.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:intl/intl.dart';
import 'AddTodo.dart';
import 'card.dart';

class TodoListPage extends StatefulWidget {
  @override
  _TodoListPageState createState() => _TodoListPageState();
}
//----------------------------------------------------------------------------------
class _TodoListPageState extends State<TodoListPage> {
  final dbRef = FirebaseDatabase.instance.reference().child("todos");
  final User? user = FirebaseAuth.instance.currentUser;
  List<Map<dynamic, dynamic>> lists = [];
  List<String> keys = [] ;
//----------------------------------------------------------------------------------
  @override
  void initState() {
    super.initState();
    dbRef.orderByChild('userId').equalTo(user?.uid).onValue.listen((event) {
      DataSnapshot snapshot = event.snapshot;
      lists.clear();
      keys.clear();
      if (snapshot.value is Map<dynamic, dynamic>) {

        Map<dynamic, dynamic> values = snapshot.value as Map<dynamic, dynamic>;
        values.forEach((key, values) {
          if (values != null) {
            lists.add(values);
            keys.add(key);
          }
        });
        setState(() {});
      } else {
        print('Unexpected value in the snapshot');
      }
    }).onError((error) {
      print("Failed to load Todos: $error");
    });
  }
//----------------------------------------------------------------------------------
  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    return Scaffold(
      backgroundColor: Color(0xFFFFFFFF),
      body: SizedBox(

        width: size.width,
        height: size.height,
        child: Stack(

          children: [
            Positioned(
              child: Container(

                width: size.width,
                height: size.height / 3,
                decoration: const BoxDecoration(

                  borderRadius: BorderRadius.horizontal(
                    left: Radius.circular(10),
                    right: Radius.circular(10),

                  ),
                  gradient: LinearGradient(
                    colors: [
                     // Color(0xFFDADDDF)
                      Color(0xFF272928),
                      Color(0xFF4D5D68),
                    ],
                    begin: Alignment.centerRight,
                    end: Alignment.centerLeft,
                  ),
                ),
                child: Column(
                  children: const [
                    SizedBox(
                      height: 60,
                    ),
                    Text(
                      'Deine ToDo Liste',
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 36,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ],
                ),
              ),
            ),
            Positioned(
              top: size.height / 4.5,
              left: 16,
              child: Container(
                width: size.width - 32,
                height: size.height / 1.4,
                decoration: const BoxDecoration(
                  color:Color(0xFFF0ECEB),
                  borderRadius: BorderRadius.horizontal(
                    left: Radius.circular(10),
                    right: Radius.circular(10),
                  ),
                ),
                child: Padding(
                  padding: const EdgeInsets.all(8),


                 child:  ListView.builder(
                    padding: const EdgeInsets.only(
                      top: 8,
                    ),
                    itemBuilder: (BuildContext context, int index) {
                      var inputFormat = DateFormat('dd.MM.yyyy');
                      var inputDate = inputFormat.parse(lists[index]["date"]);
                      return CardWidget(
                        title: lists[index]["title"],
                        subtitle: lists[index]["subtitle"],
                        date: inputDate,
                        time: lists[index]["time"],
                        onDelete: () {
                          dbRef.child(keys[index]).remove();
                          setState(() {

                          });
                        }, done:lists[index]["done"],
                        onDone: () {
                      setState(() {
                        lists[index]["done"] = !lists[index]["done"];
                        dbRef.child(keys[index]).update({'done': lists[index]["done"]});
                      }); },
                      );
                    },
                    itemCount: lists.length,
                  ),



                ),
              ),
            ),
          ],
        ),
      ),
      bottomNavigationBar: BottomAppBar(
        color: const   Color(0xFF4D5D68),
        shape: const CircularNotchedRectangle(),
        notchMargin: 8,
        child: Row(
          mainAxisSize: MainAxisSize.max,
          mainAxisAlignment: MainAxisAlignment.spaceAround,
          children: [
            IconButton(
              onPressed: () {},
              icon: Icon(Icons.abc_rounded),
            ),
          ],
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          Navigator.of(context).push(
            MaterialPageRoute(builder: (context) => AddTodo()),
          );
        },
        child: Icon(Icons.add),
        backgroundColor: const   Color(0xFF4D5D68),
        foregroundColor: const Color(0xffffffff),
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerDocked,
    );
  }


}
