import 'package:flutter/material.dart';
import 'VideoCallSettings.dart';

class JoinVideoScreen extends StatefulWidget {
  const JoinVideoScreen({super.key, required this.title , required this.conferenceID});
  final String title;
  final String conferenceID;
  @override
  State<JoinVideoScreen> createState() => _JoinVideoScreenState();
}

class _JoinVideoScreenState extends State<JoinVideoScreen> {

  @override
  Widget build(BuildContext context) {

    return Container(

        child: Scaffold(
          body: Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children:  [
                ElevatedButton(

                    onPressed: () => {
                      Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (context) => VideoCallSettings(conferenceID: widget.conferenceID)
                          ))
                    },
                    child: const Text("Join Live")),
              ],
            ),
          ),

        ));
  }
}
