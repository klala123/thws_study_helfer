import 'dart:io';
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import '../model/UserData.dart';
import 'VideoList.dart';

class AddVideoCallGroupp extends StatefulWidget {
  @override
  State<AddVideoCallGroupp> createState() => AddVideoCallGrouppState();
}

class AddVideoCallGrouppState extends State<AddVideoCallGroupp> with TickerProviderStateMixin {
 // static List<videoHomeList> homeList1 = [ ] ;
  List<VideoList> homeList = VideoList.homeList;
  TextEditingController name = TextEditingController();
  TextEditingController number = TextEditingController();
  File? file;
  ImagePicker image = ImagePicker();
  var url;
  DatabaseReference dbRef = FirebaseDatabase.instance.ref().child('data');
  late AnimationController _animationController;
  late Animation<double> _animation;

  @override
  void initState() {
    super.initState();
    _animationController =
        AnimationController(vsync: this, duration: Duration(milliseconds: 500));
    _animation = CurvedAnimation(parent: _animationController, curve: Curves.easeInOutCubic);
  }

  @override
  void dispose() {
    _animationController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    _animationController.forward();
    return Scaffold(
      body: Container(
        width: double.infinity,
        decoration: BoxDecoration(
          image: DecorationImage(
            image: AssetImage('assets/images/hintergrundBild.png'),
            fit: BoxFit.cover,
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
                    'Gruppe erstellen',
                    style: TextStyle(
                      fontSize: 30,
                      fontWeight: FontWeight.bold,
                      color: Colors.white,
                    ),
                  ),
                  SizedBox(
                    height: 20,
                  ),
                  Container(
                    width: MediaQuery.of(context).size.width * 0.8,
                    child: TextFormField(
                      controller: name,
                      decoration: InputDecoration(
                        filled: true,
                        fillColor: Colors.white,
                        hintText: 'Name',
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
                      style: TextStyle(
                        fontSize: 18,
                      ),
                    ),
                  ),
                  SizedBox(
                    height: 40,
                  ),
                  ScaleTransition(
                    scale: _animation,
                    child: MaterialButton(
                      height: 50,
                      minWidth: MediaQuery.of(context).size.width * 0.6,
                      onPressed: () {
                        uploadFile();
                      },
                      child: Text(
                        "Add",
                        style: TextStyle(
                          color: Color.fromARGB(255, 255, 255, 255),
                          fontSize: 20,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      color: Colors.indigo[900],
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(25),
                      ),
                      elevation: 5,
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }


  uploadFile() async {

    try {

      //-----------------------------------------
      UserData user = UserData(name: name.text) ;
      url = "assets/images/ElementHintergrund.png";
      Map<String, dynamic> contact = {
        'name': user.name,
        'url': url,
        'id' : '${user.name}ID'
      };
      print("dbRef:      ${dbRef}");
      dbRef!.push().set(contact).whenComplete(() => {
        //videosData()
      });
      Navigator.pop(context);
    } on Exception catch (e) {    print(e);   }

  }

  getImage() async {
    var img = await image.pickImage(source: ImageSource.gallery);
    setState(() {
      file = File(img!.path);
    });

    // print(file);
  }

}

