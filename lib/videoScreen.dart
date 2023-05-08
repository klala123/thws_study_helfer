import 'package:flutter/material.dart';
import 'VideoConference.dart';

//void main() {
//  runApp(const MyApp());
//}


class ZumVideoCallPage extends StatefulWidget {
  const ZumVideoCallPage({super.key, required this.title , required this.conferenceID});
  final String title;
  final String conferenceID;
  @override
  State<ZumVideoCallPage> createState() => _ZumVideoCallPageState();
}

class _ZumVideoCallPageState extends State<ZumVideoCallPage> {

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
                              builder: (context) => VideoConference(conferenceID: widget.conferenceID)
                          ))
                    },
                    child: const Text("Join Live")),
              ],
            ),
          ),

        ));
  }
}
