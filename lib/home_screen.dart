
import 'app_theme.dart';
import 'package:flutter/material.dart';
import 'model/homelist.dart';

class MyHomePage extends StatefulWidget {
  const MyHomePage({Key? key}) : super(key: key);

  @override
  _MyHomePageState createState() => _MyHomePageState();
}

// Die klasse erhält die Fähigkeit, Ticker bereitzustellen, die von Animation verwendet werden
class _MyHomePageState extends State<MyHomePage> with TickerProviderStateMixin {
  List<HomeList> homeList = HomeList.homeList;
  // Um die Animation zu steueren (Bsp : stoppen, starten,umkeren)
  AnimationController? animationController;
  bool multiple = true;

  @override
  void initState() {
    animationController = AnimationController(
      // vsync : this --> Verbindet Animation Controller mit der Tickerprovider der Klasse _MyHomePageState
        duration: const Duration(milliseconds: 1000), vsync: this);
    super.initState();
  }

  Future<bool> getData() async {
    await Future<dynamic>.delayed(const Duration(milliseconds: 0));
    return true;
  }

  // Um elemente aus dem Widget Baum zu entfernen
  /*
  Das Aufrufen von dispose() auf dem animationController gibt die Ressourcen frei,
  die von diesem AnimationController belegt wurden,
   */

  @override
  void dispose() {
    animationController?.dispose();
    super.dispose();
  }

//-------------------------------------------------------------------------------
  /*
  @override
  Widget build(BuildContext context) {
    var brightness = MediaQuery.of(context).platformBrightness;
    bool isLightMode = brightness == Brightness.light;


    return Scaffold(
     // backgroundColor: Color(0xFFD2C6B6),
      body: FutureBuilder<bool>(
        future: getData(),
        builder: (BuildContext context, AsyncSnapshot<bool> snapshot) {
          if (!snapshot.hasData) {
            return const SizedBox();
          } else {
            return Container(

              decoration: BoxDecoration(
                image: DecorationImage(
                 image: AssetImage("assets/images/hintergrundBild.png"),
                 fit: BoxFit.cover,
               ),
              ),
              child: Padding(
                padding: EdgeInsets.only(top: MediaQuery.of(context).padding.top),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: <Widget>[
                    appBar(),


                    Expanded(
                      child: SingleChildScrollView(
                        child: Column(
                          children: [
                            GridView.builder(
                              itemCount: homeList.length - 2,
                              shrinkWrap: true,
                              padding: const EdgeInsets.only(top: 20, left: 30, right: 30),
                              physics: const NeverScrollableScrollPhysics(),
                              scrollDirection: Axis.vertical,
                              itemBuilder: (BuildContext context, int index) {
                                final int count = homeList.length - 1;
                                final Animation<double> animation =
                                Tween<double>(begin: 0.0, end: 1.0).animate(
                                  CurvedAnimation(
                                    parent: animationController!,
                                    curve: Interval((1 / count) * index, 1.0,
                                        curve: Curves.fastOutSlowIn),
                                  ),
                                );
                                animationController?.forward();
                                return HomeListView(
                                  animation: animation,
                                  animationController: animationController,
                                  listData: homeList[index],
                                  callBack: () {
                                    Navigator.push<dynamic>(
                                      context,
                                      MaterialPageRoute<dynamic>(
                                        builder: (BuildContext context) =>
                                        homeList[index].navigateScreen!,
                                      ),
                                    );
                                  },
                                );
                              },
                              gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                                crossAxisCount: multiple ? 2 : 1,
                                mainAxisSpacing: 20.0,
                                crossAxisSpacing: 30.0,
                                childAspectRatio: multiple ? 1.7: 12,
                                //childAspectRatio: multiple ? (MediaQuery.of(context).size.width / 2 - 30) / 170 : 12,

                              ),
                            ),
                            GridView.builder(
                              itemCount: 2,
                              shrinkWrap: true,
                              padding: const EdgeInsets.only(top: 20, left: 30, right: 30),
                              physics: const NeverScrollableScrollPhysics(),
                              scrollDirection: Axis.vertical,
                              itemBuilder: (BuildContext context, int index) {
                                int actualIndex = homeList.length - 2 + index;
                                final Animation<double> animation =
                                Tween<double>(begin: 0.0, end: 1.0).animate(
                                  CurvedAnimation(
                                    parent: animationController!,
                                    curve: Curves.fastOutSlowIn,
                                  ),
                                );
                                animationController?.forward();
                                return HomeListView(
                                  animation: animation,
                                  animationController: animationController,
                                  listData: homeList[actualIndex],
                                  callBack: () {
                                    Navigator.push<dynamic>(
                                      context,
                                      MaterialPageRoute<dynamic>(
                                        builder: (BuildContext context) =>
                                        homeList[actualIndex].navigateScreen!,
                                      ),
                                    );
                                  },
                                );
                              },
                              gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                                crossAxisCount: 1,
                                mainAxisSpacing: 20.0,
                                crossAxisSpacing: 16.0,
                                childAspectRatio: multiple ? 3 : 8,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            );
          }
        },
      ),
    );
  }


   */

  @override
  Widget build(BuildContext context) {
    var brightness = MediaQuery.of(context).platformBrightness;
    bool isLightMode = brightness == Brightness.light;
    // Dynamische Größen und Abstände basierend auf Bildschirmgröße
    double screenWidth = MediaQuery.of(context).size.width;
    double screenHeight = MediaQuery.of(context).size.height;
    double appBarHeight = screenHeight * 0.12;
    double iconSize = screenWidth * 0.06;
    double textSize = screenWidth * 0.04;

    return Scaffold(
     backgroundColor: Color(0xFF111010),
      body: FutureBuilder<bool>(

        future: getData(),
        builder: (BuildContext context, AsyncSnapshot<bool> snapshot) {
          if (!snapshot.hasData) {
            return const SizedBox();
          } else {
            return Container(
              /*
              decoration: BoxDecoration(

                image: DecorationImage(
                  image: AssetImage("assets/images/hintergrundBild.png"),
                  fit: BoxFit.cover,
                ),
              ),

               */



              child: Padding(
                padding: EdgeInsets.only(top: MediaQuery.of(context).padding.top),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: <Widget>[
                    appBar(appBarHeight, iconSize),
                    Expanded(
                      child: SingleChildScrollView(
                        child: Column(
                          children: [
                            GridView.builder(
                              itemCount: homeList.length - 2,
                              shrinkWrap: true,
                              padding: EdgeInsets.symmetric(horizontal: screenWidth * 0.08, vertical: screenHeight * 0.02),
                              physics: const NeverScrollableScrollPhysics(),
                              scrollDirection: Axis.vertical,
                              itemBuilder: (BuildContext context, int index) {
                                final int count = homeList.length - 1;
                                final Animation<double> animation =
                                Tween<double>(begin: 0.0, end: 1.0).animate(
                                  CurvedAnimation(
                                    parent: animationController!,
                                    curve: Interval((1 / count) * index, 1.0,
                                        curve: Curves.fastOutSlowIn),
                                  ),
                                );
                                animationController?.forward();
                                return HomeListView(
                                  animation: animation,
                                  animationController: animationController,
                                  listData: homeList[index],
                                  callBack: () {
                                    Navigator.push<dynamic>(
                                      context,
                                      MaterialPageRoute<dynamic>(
                                        builder: (BuildContext context) =>
                                        homeList[index].navigateScreen!,
                                      ),
                                    );
                                  },
                                );
                              },
                              gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                                crossAxisCount: multiple ? 2 : 1,
                                mainAxisSpacing: screenHeight * 0.02,
                                crossAxisSpacing: screenWidth * 0.08,
                                childAspectRatio: multiple ? screenWidth / (screenHeight * 0.34) : 12,
                              ),
                            ),
                            GridView.builder(
                              itemCount:2,
                              shrinkWrap: true,
                              padding: EdgeInsets.symmetric(horizontal: screenWidth * 0.08, vertical: screenHeight * 0.02),
                              physics: const NeverScrollableScrollPhysics(),
                              scrollDirection: Axis.vertical,
                              itemBuilder: (BuildContext context, int index) {
                                int actualIndex = homeList.length - 2 + index;
                                final Animation<double> animation =
                                Tween<double>(begin: 0.0, end: 1.0).animate(
                                  CurvedAnimation(
                                    parent: animationController!,
                                    curve: Curves.fastOutSlowIn,
                                  ),
                                );
                                animationController?.forward();
                                return HomeListView(
                                  animation: animation,
                                  animationController: animationController,
                                  listData: homeList[actualIndex],
                                  callBack: () {
                                    Navigator.push<dynamic>(
                                      context,
                                      MaterialPageRoute<dynamic>(
                                        builder: (BuildContext context) =>
                                        homeList[actualIndex].navigateScreen!,
                                      ),
                                    );
                                  },
                                );
                              },
                              gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                                crossAxisCount: 1,
                                mainAxisSpacing: screenHeight * 0.02,
                                crossAxisSpacing: screenWidth * 0.02,
                                childAspectRatio: multiple ? screenWidth / (screenHeight * 0.23) : 8,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            );
          }
        },
      ),
    );
  }

//----------------------------------------------------------------
  Widget appBar(double appBarHeight, double iconSize) {
    var brightness = MediaQuery.of(context).platformBrightness;
    bool isLightMode = brightness == Brightness.light;
    double screenWidth = MediaQuery.of(context).size.width;
    double textSize = screenWidth * 0.04;
    return SizedBox(
      height: appBarHeight,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: <Widget>[
          Padding(
            padding: const EdgeInsets.only(top: 8, left: 8),
            child: Container(
              width: AppBar().preferredSize.height - 8,
              height: AppBar().preferredSize.height - 8,
            ),
          ),
          Expanded(
            child: Center(
              child: Padding(
                padding: const EdgeInsets.only(top: 4, bottom: 9),
                child: Align(
                  alignment: Alignment.center,
                  child: Text(
                    'Klala, WILLKOMMEN\nZURÜCK ',
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: textSize,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
              ),
            ),
          ),
          Padding(
            padding: const EdgeInsets.only(right: 8),
            child: Container(
              width: AppBar().preferredSize.height - 8,
              height: AppBar().preferredSize.height - 8,
              child: Material(
                color: Colors.transparent,
                child: InkWell(
                  borderRadius:
                  BorderRadius.circular(AppBar().preferredSize.height),
                  child: Icon(
                    multiple ? Icons.dashboard : Icons.view_agenda,
                    color: AppTheme.white,
                    size: iconSize  * 0.06,
                  ),
                  onTap: () {
                    setState(() {
                      multiple = !multiple;
                    });
                  },
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}


//------------------------------------------------------------
class HomeListView extends StatelessWidget {
  const HomeListView({Key? key,
    this.listData,
    this.callBack,
    this.animationController,
    this.animation})
      : super(key: key);

  final HomeList? listData;
  final VoidCallback? callBack;
  final AnimationController? animationController;
  final Animation<double>? animation;



  @override
  Widget build(BuildContext context) {
    double screenWidth = MediaQuery.of(context).size.width;
    double textSize = screenWidth * 0.025;

    return AnimatedBuilder(
      animation: animationController!,
      builder: (BuildContext context, Widget? child) {
        return FadeTransition(
          opacity: animation!,
          child: Transform(
            transform: Matrix4.translationValues(
                0.0, 50 * (1.0 - animation!.value), 0.0),
            child: SizedBox (
                width: MediaQuery.of(context).size.width * 0.3 ,
              child: AspectRatio(
                aspectRatio: 1.5,
                child: Container(

                  decoration: BoxDecoration(

                    borderRadius: const BorderRadius.all(Radius.circular(50.0)),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black.withOpacity(0.3),
                        blurRadius: 15.0,
                        offset: Offset(0, 8),
                      ),
                    ],
                  ),
                  child: ClipRRect(
                    borderRadius: const BorderRadius.all(Radius.circular(50.0)),
                    child: Stack(
                      alignment: AlignmentDirectional.center,
                      children: <Widget>[
                        Positioned.fill(
                          child: Image.asset(
                            listData!.imagePath,
                            fit: BoxFit.cover,
                          ),
                        ),
                        Positioned(
                          top: 18,
                          left: 20,
                          child: Text(
                            listData!.title,
                            style: TextStyle(
                              color: Colors.black,
                              fontSize: textSize ,
                             // backgroundColor: Colors.black12,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ),
                        Material(
                          color: Colors.transparent,
                          child: InkWell(
                            splashColor: Colors.grey.withOpacity(0.2),
                            borderRadius: const BorderRadius.all(Radius.circular(10.0)),
                            onTap: callBack,
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
      },
    );
  }



}


