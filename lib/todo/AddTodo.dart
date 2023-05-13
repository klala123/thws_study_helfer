import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'CardWidget.dart';

class AddTodo extends StatefulWidget {
  const AddTodo({Key? key}) : super(key: key);

  @override
  _AddTodoState createState() => _AddTodoState();
}

//-------------------------------------------------

class _AddTodoState extends State<AddTodo>  with SingleTickerProviderStateMixin {
  late AnimationController _animationController ;
  late Animation<double> _animation ;
  final _auth = FirebaseAuth.instance;
  final _db = FirebaseDatabase.instance;
  FirebaseMessaging messaging = FirebaseMessaging.instance;
  User? _user;
//----------------------------------------------------------------------------------
  @override
  void initState() {
    WidgetsFlutterBinding.ensureInitialized();
    initializeFirebase();
    super.initState();
    _user = _auth.currentUser;
    _animationController = AnimationController(
      duration: const Duration(seconds: 1),
      vsync: this,
    )..repeat(reverse: true);
    _animation = CurvedAnimation(
      parent: _animationController,
      curve: Curves.easeInOut,
    );
  }
//----------------------------------------------------------------------------------
  @override
  void dispose() {
    _animationController.dispose();
    super.dispose();
  }
//----------------------------------------------------------------------------------
  Future<void> initializeFirebase() async {
    await Firebase.initializeApp();
  }
//----------------------------------------------------------------------------------
  final TextEditingController _titleController = TextEditingController();
  final TextEditingController _subtitleController = TextEditingController();
  DateTime _selectedDate = DateTime.now();
  TimeOfDay _selectedTime = TimeOfDay.now();

  final List<CardWidget> _presentationCards = [];
  //----------------------------------------------------------

  void addTodo() {
    String? key = _db.reference().child('todos').push().key;  // Generiert einen eindeutigen Schlüssel
    _db.reference().child('todos').child(key!).set({
      'title': _titleController.text,
      'subtitle': _subtitleController.text,
      'date': DateFormat('dd.MM.yyyy').format(_selectedDate),
      'time': _selectedTime.format(context),
      'userId': _user?.uid,
      'done' : false ,
    }).then((_) {
      // Nachdem das  hinzugefügt wurde, kehren Sie zur vorherigen Seite zurück
      Navigator.pop(context);
    });
    _titleController.clear();
    _subtitleController.clear();
  }


  //---------------------------------------------------------------------

  @override
  Widget build(BuildContext context) {
    _animationController.forward();
    return Scaffold(
      body: Container(
        decoration: const BoxDecoration(

          borderRadius: BorderRadius.horizontal(
            left: Radius.circular(10),
            right: Radius.circular(10),

          ),
          gradient: LinearGradient(
            colors: [
              // Color(0xFFDADDDF)
              Color(0xFF272928),
              Color(0xFF465258),
            ],
            begin: Alignment.centerRight,
            end: Alignment.centerLeft,
          ),
        ),
        child: SingleChildScrollView(
          child: Center(
            child: ConstrainedBox(
              constraints: BoxConstraints(
                minHeight: MediaQuery.of(context).size.height,
              ),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Text(
                    'Add Todo',
                    style: TextStyle(
                      fontSize: 30,
                      fontWeight: FontWeight.bold,
                      color: Colors.white,
                    ),
                  ),
                  SizedBox(height: 20),
                  Container(
                    width: MediaQuery.of(context).size.width * 0.8,
                    child: TextField(
                      controller: _titleController,
                      decoration: InputDecoration(
                        filled: true,
                        fillColor: Colors.white,
                        hintText: 'Title',
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(25),
                          borderSide: BorderSide.none,
                        ),
                        focusedBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(25),
                          borderSide: BorderSide(
                            color: Colors.purple,
                            width: 2,
                          ),
                        ),
                      ),
                      textAlign: TextAlign.center,
                      style: TextStyle(fontSize: 18),
                    ),
                  ),
                  SizedBox(height: 20),
                  Container(
                    width: MediaQuery.of(context).size.width * 0.8,
                    child: TextField(
                      controller: _subtitleController,
                      decoration: InputDecoration(
                        filled: true,
                        fillColor: Colors.white,
                        hintText: 'Description',
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(25),
                          borderSide: BorderSide.none,
                        ),
                        focusedBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(25),
                          borderSide: BorderSide(
                            color: Colors.purple,
                            width: 2,
                          ),
                        ),
                      ),
                      textAlign: TextAlign.center,
                      style: TextStyle(fontSize: 18),
                    ),
                  ),
                  SizedBox(height: 40),
                  Container(
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(25) ,
                      border: Border.all( // color: Colors.purple,
                      width: 2 , )
                    ),
                    width: MediaQuery.of(context).size.width * 0.8,
                    child: ListTile(

                      title: Text(
                        'Date: ${DateFormat('dd.MM.yyyy').format(_selectedDate)}',
                        style: TextStyle(color: Colors.black),
                      ),
                      trailing: Icon(Icons.calendar_today, color: Colors.black),
                      onTap: () async {
                        final DateTime? pickedDate = await showDatePicker(
                          context: context,
                          initialDate: _selectedDate,
                          firstDate: DateTime.now().subtract(const Duration(days: 1)),
                          lastDate: DateTime.now().add(const Duration(days: 365)),
                        );
                        if (pickedDate != null && pickedDate != _selectedDate) {
                          setState(() {
                            _selectedDate = pickedDate;
                          });
                        }
                      },
                    ),
                  ),
                  SizedBox(height: 15),
                  Container(
                    decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(25) ,
                        border: Border.all( // color: Colors.purple,
                          width: 2 , )
                    ),
                    width: MediaQuery.of(context).size.width * 0.8,
                    child: ListTile(
                      title: Text(
                        'Time: ${_selectedTime.format(context)}',
                        style: TextStyle(color: Colors.black),
                      ),
                      trailing: Icon(Icons.access_time, color: Colors.black),
                      onTap: () async {
                        final TimeOfDay? pickedTime = await showTimePicker(
                          context: context,
                          initialTime: _selectedTime,
                        );
                        if (pickedTime != null && pickedTime != _selectedTime) {
                          setState(() {
                            _selectedTime = pickedTime;
                          });
                        }
                      },
                    ),
                  ),
                  SizedBox(height: 40),

                  ScaleTransition(
                    scale: _animation,
                    child: MaterialButton(
                      height: 50,
                      minWidth: MediaQuery.of(context).size.width * 0.6,
                      onPressed: () {
                        addTodo();
                        _titleController.clear();
                        _subtitleController.clear();
                      },
                      child: Text(
                        "Add Todo",
                        style: TextStyle(
                          color: Color.fromARGB(255, 255, 255, 255),
                          fontSize: 20,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      color: Colors.blueGrey,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(25),
                      ),
                      elevation: 5,
                    ),
                  ),
                  for (var card in _presentationCards)
                    AnimatedOpacity(
                      duration: Duration(milliseconds: 100),
                      opacity: 1.0,
                      child: card,
                    ),
                  SizedBox(height: 40),

                ],
              ),
            ),
          ),
        ),
      ),
    );
  }


}
