import 'package:flutter/material.dart';
import 'package:flutter_swipe_action_cell/flutter_swipe_action_cell.dart';
import 'package:intl/intl.dart';

class CardListElement extends StatelessWidget {
  final String title;
  final String subtitle;
  final DateTime date;
  final String time;
  final VoidCallback onDelete;
  final bool done;
  final VoidCallback onDone;

  const CardListElement({
    Key? key,
    required this.title,
    required this.subtitle,
    required this.date,
    required this.time,
    required this.onDelete,
    required this.done,
    required this.onDone
  }) : super(key: key);
//----------------------------------------------------------------------------------
  @override
  Widget build(BuildContext context) {
    final screenHeight = MediaQuery.of(context).size.height;
    final screenWidth = MediaQuery.of(context).size.width;
    return SwipeActionCell(
      key: key ?? Key('swipeActionCell'),
      trailingActions: <SwipeAction>[
        SwipeAction(
            title: "Erledigt",
            onTap: (handler) {
              onDone();
            },
            color: done ? Colors.green : const Color(0xff5a7c92)),
        SwipeAction(
            title: "Löschen",
            onTap: (handler) {
              onDelete();
            },
            color: const Color(0xFFFE4A49)),
      ],
      child: Card(
        elevation: 8,
        shadowColor: const Color(0xff607582),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(
            screenWidth * 0.02, // 2% of screen width
          ),
        ),
        child: ListTile(
          contentPadding: EdgeInsets.symmetric(
            vertical: screenHeight * 0.01, // 1% of screen height
            horizontal: screenWidth * 0.04, // 4% of screen width
          ),
          minLeadingWidth: screenWidth * 0.01, // 2% of screen width
          leading: Container(
            width: screenWidth * 0.008, // 1% of screen width
            color: const Color(0xff236384),
          ),
          title: Padding(
            padding: EdgeInsets.symmetric(vertical: screenHeight * 0.01), // 1% of screen height
            child: Row(
              children: [
                Text(
                  title,
                  style: TextStyle(
                    fontSize: screenHeight * 0.02, // 3% of screen height
                    fontWeight: FontWeight.bold,
                  ),
                ),
                if(done)
                  Row(
                    children: [
                      SizedBox(width: screenWidth * 0.017), // 2% of screen width
                      Icon(Icons.check_circle, color: Colors.green, size: screenHeight * 0.03), // 4% of screen height
                    ],
                  ),
              ],
            ),
          ),
          subtitle: Text(
            subtitle,
            style: TextStyle(
              color: Colors.blueGrey,
              fontSize: screenHeight * 0.015, // 2% of screen height
            ),
          ),
          trailing: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              Text(
                DateFormat('dd.MM.yyyy').format(date),
                style: TextStyle(
                  color: Colors.black45,
                  fontSize: screenHeight * 0.02, // 2% of screen height
                ),
              ),
              SizedBox(width: screenWidth * 0.02), // 2% of screen width for spacing

              Text(
                //DateFormat('hh:mm a').format(date) + " " + time,
                time,
                style: TextStyle(
                  color: Colors.black45,
                  fontSize: screenHeight * 0.02, // 2% of screen height
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
