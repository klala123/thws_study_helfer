import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class CardWidget extends StatelessWidget {
  final String title;
  final String subtitle;
  final IconData icon;
  //final Widget route;
  final String date;
  final String time;

  const CardWidget({
    Key? key,
    required this.title,
    required this.subtitle,
    required this.icon,
  //  required this.route,
    required this.date,
    required this.time,
  }) : super(key: key);
//----------------------------------------------------------------------------------
  @override
  Widget build(BuildContext context) {
    double w = MediaQuery.of(context).size.width;
    return Opacity(
      opacity: 1,
      child: Transform.translate(
        offset: const Offset(0, 1.1),
        child: Container(
          height: w / 2.3,
          width: w,
          padding: EdgeInsets.fromLTRB(w / 20, 0, w / 20, w / 20),
          child: InkWell(
            highlightColor: Colors.transparent,
            splashColor: Colors.transparent,
            onTap: () {
              HapticFeedback.lightImpact();
            },
            child: Container(
              decoration: BoxDecoration(
                color: Colors.white.withOpacity(.2),
                borderRadius: const BorderRadius.all(Radius.circular(30)),
                border: Border.all(
                  color: Colors.white.withOpacity(.1),
                  width: 1,
                ),
              ),
              child: Padding(
                padding: EdgeInsets.all(w / 50),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: [
                    Container(
                      height: w / 3,
                      width: w / 3,
                      decoration: BoxDecoration(
                        color: Colors.white.withOpacity(.2),
                        borderRadius: BorderRadius.circular(20),
                      ),
                      child: Icon(
                        icon,
                        color: Colors.white,
                        size: w / 10,
                      ),
                    ),
                    SizedBox(width: w / 40),
                    SizedBox(
                      width: w / 2.05,
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            title,
                            maxLines: 2,
                            softWrap: true,
                            overflow: TextOverflow.ellipsis,
                            textAlign: TextAlign.start,
                            style: TextStyle(
                              color: Colors.white,
                              fontSize: w / 20,
                              fontWeight: FontWeight.bold,
                              letterSpacing: 1,
                              wordSpacing: 1,
                            ),
                          ),
                          Text(
                            subtitle,
                            maxLines: 1,
                            softWrap: true,
                            overflow: TextOverflow.ellipsis,
                            style: TextStyle(
                              color: Colors.white.withOpacity(1),
                              fontSize: w / 25,
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                          Text(
                            'Datum: $date  Zeit: $time',
                            maxLines: 1,
                            softWrap: true,
                            overflow: TextOverflow.ellipsis,
                            style: TextStyle(
                              color: Colors.white,
                              fontSize: w / 30,
                            ),
                          ),
                          Text(
                            'Tippen, um mehr zu erfahren',
                            maxLines: 1,
                            softWrap: true,
                            overflow: TextOverflow.ellipsis,
                            style: TextStyle(
                              color: Colors.white,
                              fontSize: w / 30,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
