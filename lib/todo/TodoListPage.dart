import 'package:flutter/material.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:intl/intl.dart';
import 'AddTodo.dart';
import 'cardListElement.dart';
class TodoListPage extends StatefulWidget {
  @override
  _TodoListPageState createState() => _TodoListPageState();
}
//----------------------------------------------------------------------------------
class _TodoListPageState extends State<TodoListPage> {
  final dbRef = FirebaseDatabase.instance.reference().child("todos");
  final User? user = FirebaseAuth.instance.currentUser;
  List<Map<dynamic, dynamic>> todos = [];
//----------------------------------------------------------------------------------
  @override
  void initState() {
    super.initState();
    dbRef.orderByChild('userId').equalTo(user?.uid).onValue.listen((event) {
      DataSnapshot snapshot = event.snapshot;
      todos.clear();
      if (snapshot.value is Map<dynamic, dynamic>) {
        Map<dynamic, dynamic> values = snapshot.value as Map<dynamic, dynamic>;
        values.forEach((key, values) {
          if (values != null) {
            values["key"] = key ;
            todos.add(values);
          }
        });
        // Sortieren der Liste
        todos.sort((a, b) {
          var aDate = DateFormat('dd.MM.yyyy').parse(a["date"]);
          var bDate = DateFormat('dd.MM.yyyy').parse(b["date"]);
          var aTime = DateFormat('HH:mm').parse(a["time"]);
          var bTime = DateFormat('HH:mm').parse(b["time"]);
          if (aDate.compareTo(bDate) != 0) {
            return aDate.compareTo(bDate);
          } else {
            return aTime.compareTo(bTime);
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
                      var inputDate = inputFormat.parse(todos[index]["date"]);

                      return Dismissible(
                        key: Key(todos[index]["key"]),
                        onDismissed: (direction) {
                          dbRef.child(todos[index]["key"]).remove();
                          setState(() {});
                        },
                        child: CardListElement(
                          title: todos[index]["title"],
                          subtitle: todos[index]["subtitle"],
                          date: inputDate,
                          time: todos[index]["time"],
                          onDelete: () {
                            dbRef.child(todos[index]["key"]).remove();
                            setState(() {});
                          },
                          done:todos[index]["done"],
                          onDone: () {
                            setState(() {
                              todos[index]["done"] = !todos[index]["done"];
                              dbRef.child(todos[index]["key"]).update({'done': todos[index]["done"]});
                            });
                          },
                        ),
                      );
                    },
                    itemCount: todos.length,
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
