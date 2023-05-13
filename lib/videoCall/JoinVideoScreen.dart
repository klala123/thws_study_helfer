import 'package:flutter/material.dart';
import 'VideoCallSettings.dart';
import 'package:flutter/animation.dart';

class JoinVideoScreen extends StatefulWidget {
  const JoinVideoScreen({super.key, required this.title , required this.conferenceID});
  final String title;
  final String conferenceID;
  @override
  State<JoinVideoScreen> createState() => _JoinVideoScreenState();
}

class _JoinVideoScreenState extends State<JoinVideoScreen> with SingleTickerProviderStateMixin {
  late AnimationController _animationController;
  late Animation<double> _animation;
  @override
  void initState() {
    super.initState();
    _animationController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 500),
    );
    _animation = CurvedAnimation(parent: _animationController, curve: Curves.easeInOut);
    _animationController.forward();
  }

  @override
  void dispose() {
    _animationController.dispose();
    super.dispose();
  }


  @override
  Widget build(BuildContext context) {

    return Container(
        child: Scaffold(
          body:
          Container(
            decoration: const BoxDecoration(

              // borderRadius: BorderRadius.horizontal(
              // left: Radius.circular(10),
              //right: Radius.circular(10),

              // ),
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
            child: Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children:  [
                  /*
                  ElevatedButton(
                    style: ButtonStyle(backgroundColor: MaterialStateProperty.all<Color>(Colors.blueGrey) ),

                      onPressed: () => {
                        Navigator.push(
                            context,
                            MaterialPageRoute(
                                builder: (context) => VideoCallSettings(conferenceID: widget.conferenceID)
                            ))
                      },
                      child: const Text("Join Live")),

                   */
                  ElevatedButton(
                    style: ButtonStyle(
                      backgroundColor: MaterialStateProperty.all<Color>(Colors.blueGrey),
                      elevation: MaterialStateProperty.all<double>(5),
                      shape: MaterialStateProperty.all<RoundedRectangleBorder>(
                        RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(30),
                        ),
                      ),
                      padding: MaterialStateProperty.all<EdgeInsets>(
                        EdgeInsets.symmetric(horizontal: MediaQuery.of(context).size.width * 0.1, vertical: 15),
                      ),
                    ),
                    onPressed: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => VideoCallSettings(conferenceID: widget.conferenceID),
                        ),
                      );
                    },
                    child: ScaleTransition(
                      scale: _animation,
                      child: const Text("Join Live", style: TextStyle(fontSize: 20)),
                    ),
                  )


                ],
              ),
            ),
          ),

        ));
  }
}
