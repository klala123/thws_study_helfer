import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import '../navigation/navigationHomeScreen.dart';
import 'animations.dart';
import 'signup_screen.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'constant.dart';

class LoginScreen extends StatefulWidget {
  LoginScreen({Key? key}) : super(key: key);
  @override
  State<LoginScreen> createState() => _LoginScreenState();
}
class _LoginScreenState extends State<LoginScreen> {
  final feature = ["Login", "Sign Up"];
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();
  int i = 0;
  bool _obscureText = true;

  Future<void> _signInWithEmailAndPassword() async {
    try {
      WidgetsFlutterBinding.ensureInitialized();
      await Firebase.initializeApp();
      final UserCredential userCredential = await FirebaseAuth.instance.signInWithEmailAndPassword(
        email: _emailController.text,
        password: _passwordController.text, );
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (context) => NavigationHomeScreen()),
      );
    } on FirebaseAuthException catch (e) {
      // Zeige Fehlermeldung an, wenn die Anmeldung fehlschlägt.
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(e.message ?? 'Anmeldung fehlgeschlagen. Bitte versuchen Sie es erneut.'),
        ),
      );
    }
  }
//---------------------------------------------------------------------
  @override
  Widget build(BuildContext context) {
    final width = MediaQuery.of(context).size.width;
    final height = MediaQuery.of(context).size.height;
    return SafeArea(
      child: GestureDetector(
        onTap: () => FocusManager.instance.primaryFocus?.unfocus(),
        child: Scaffold(
            backgroundColor: Color(0xfffdfdfdf),
            body: i == 0   ? SingleChildScrollView(
                    child: Column(
                      children: [ Container(
                          margin: EdgeInsets.all(25),
                          child: Column(   children: [
                              Row( children: [
                                Container(
                                  height: height / 19,
                                  width: width / 2,
                                  child: TopAnime( 2,  5,
                                    child: ListView.builder(
                                      itemCount: feature.length,
                                      scrollDirection: Axis.horizontal,
                                      itemBuilder:
                                          (BuildContext context, int index) {
                                        return GestureDetector(
                                          onTap: () {
                                            setState(() {
                                              i = index; });
                                          },
                                          child: Column(  children: [
                                              Padding( padding:
                                                    const EdgeInsets.symmetric(
                                                        horizontal: 20),
                                                child: Text(
                                                  feature[index],
                                                  style: TextStyle(
                                                    color: i == index ? Colors.black: Colors.grey,
                                                    fontSize: 20,
                                                    fontWeight: FontWeight.bold,
                                                  ), ),
                                              ),
                                              SizedBox(  height: 8,  ),
                                              i == index ? Container(
                                                      height: 3,
                                                      width: width / 9,
                                                      color: Colors.black, )  : Container(),
                                            ],), ); },  ),  ),   ),
                                Expanded(child: Container()),
                                // Profile
                                RightAnime(  1, 15,
                                  curve: Curves.easeInOutQuad,
                                  child: ClipRRect(
                                    borderRadius: BorderRadius.circular(20),
                                    child: Container(
                                      width: 60,
                                      height: 60,
                                      color: Colors.red[400],
                                      child: i == 0 ? Image(
                                              image: NetworkImage(
                                                  "https://i.pinimg.com/564x/5d/a3/d2/5da3d22d08e353184ca357db7800e9f5.jpg"),
                                            )
                                          : Icon(
                                              Icons.account_circle_outlined,
                                              color: Colors.white,
                                              size: 40,  ),
                                    ), ),  ), ]),
                              SizedBox(
                                height: 50,  ),
                              Container(
                                padding: EdgeInsets.only(left: 15),
                                width: width,
                                child: TopAnime(   1, 20,
                                  curve: Curves.fastOutSlowIn,
                                  child: Column(
                                    crossAxisAlignment:  CrossAxisAlignment.start,
                                    children: [
                                      Text("Welckommen zurück...... :)",
                                          style: TextStyle(
                                            fontSize: 40,
                                            fontWeight: FontWeight.w300, )),
                                      Text( "",
                                        style: TextStyle(
                                          fontSize: 40,
                                          fontWeight: FontWeight.bold,
                                        ), ),  ], ), ),  ),
                              SizedBox( height: height / 14,),
                              Column(  children: [ Container(
                                    width: width / 1.2,
                                    height: height / 3.10,
                                    child: TopAnime( 1, 15,
                                      curve: Curves.easeInExpo,
                                      child: Column(
                                        crossAxisAlignment:
                                            CrossAxisAlignment.start,
                                        children: [ TextField(
                                            controller: _emailController,
                                            cursorColor: Colors.black,
                                            style:    TextStyle(color: Colors.black),
                                            showCursor: true,
                                            decoration:   kTextFiledInputDecoration,   ),
                                          SizedBox(  height: 25,  ),
                                          TextField( controller: _passwordController,
                                            obscureText: _obscureText, // Fügt diese Zeile hinzu
                                            cursorColor: Colors.black,
                                            style: TextStyle(color: Colors.black),
                                            showCursor: true,
                                            decoration: InputDecoration(
                                              labelText: "Password",
                                              suffixIcon: IconButton(
                                                icon: Icon(
                                                  _obscureText ? Icons.visibility : Icons.visibility_off,  ),
                                                onPressed: () {   setState(() {
                                                    _obscureText = !_obscureText; // Wechselt den Zustand, wenn das Auge-Symbol angeklickt wird
                                                  });   },  ), ), ),
                                          SizedBox( height: 5, ),
                                          // FaceBook and Google ICon
                                          TopAnime(  1, 10,
                                            child: Row( children: [
                                                IconButton( icon: FaIcon(
                                                    FontAwesomeIcons.facebookF,
                                                    size: 30,   ),
                                                  onPressed: () {}, ),
                                                SizedBox(  width: 15, ),
                                                IconButton( icon: FaIcon(
                                                      FontAwesomeIcons
                                                          .googlePlusG,
                                                      size: 35),
                                                  onPressed: () {}, ),
                                              ], ),  )  ],),  ), ), ],    )  ], ), ),
                        // Bottom 
                        i == 0  ? TopAnime(2, 42,
                                curve: Curves.fastOutSlowIn,
                                child: Container(
                                  height: height / 6,
                                  // color: Colors.red,
                                  child: Stack( children: [
                                      Positioned(
                                        left: 30,
                                        top: 15,
                                        child: Text("Fogot Password?",
                                          style: TextStyle(
                                              fontSize: 16,
                                              fontWeight: FontWeight.w700),  ),  ),
                                      Padding( padding: const EdgeInsets.only(top: 43),
                                        child: Container(
                                            height: height / 9,
                                            color: Colors.grey.withOpacity(0.4)), ),
                                      Positioned(  left: 280,
                                        top: 10,
                                        child: GestureDetector(
                                          onTap: () {
                                            _signInWithEmailAndPassword(); },
                                          child: Container(
                                            decoration: BoxDecoration(
                                                color: Color(0xffF2C94C),
                                                borderRadius:
                                                    BorderRadius.circular(20)),
                                            width: width / 4,
                                            height: height / 12,
                                            child: Icon(
                                              Icons.arrow_forward,
                                              size: 35,
                                              color: Colors.white,
                                            ),
                                          ),  ), ),
                                    ], ),
                                ),
                              ): SignUPScreen()
                        //SignUPScreen()
                      ],  ),  )
                : SignUPScreen()
        ), ), );
  }
}
