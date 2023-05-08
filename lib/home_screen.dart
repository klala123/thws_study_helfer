
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
        duration: const Duration(milliseconds: 3000), vsync: this);
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




//-------------------------------------------------------------------------------
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

 //----------------------------------------------------------------
  Widget appBar() {
    var brightness = MediaQuery.of(context).platformBrightness;
    bool isLightMode = brightness == Brightness.light;
    return SizedBox(

      height: 100 ,
      //AppBar().preferredSize.height,
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
                padding: const EdgeInsets.only(top: 4 , bottom: 9),
                child:Align(
                  alignment: Alignment.center, // Zentrieren des Textes
                  child: Text(
                    'ADAM, WILLKOMMEN\nZURÜCK ',
                    textAlign: TextAlign.center, // Zentrieren innerhalb des Text-Widgets
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
              ),
            ),
          ),
          Padding(
            padding: const EdgeInsets.only(  right: 8),
            child: Container(
              width: AppBar().preferredSize.height - 8,
              height: AppBar().preferredSize.height - 8,
             // color: Colors.black ,
              //isLightMode ? Colors.white : AppTheme.nearlyBlack,
              child: Material(
                color: Colors.transparent,
                child: InkWell(
                  borderRadius:
                      BorderRadius.circular(AppBar().preferredSize.height),
                  child: Icon(
                    multiple ? Icons.dashboard : Icons.view_agenda,
                    color: AppTheme.white,
                    //isLightMode ? AppTheme.dark_grey : AppTheme.white,
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

/*
  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: animationController!,
      builder: (BuildContext context, Widget? child) {
        return FadeTransition(
          opacity: animation!,
          child: Transform(
            transform: Matrix4.translationValues(
                0.0, 50 * (1.0 - animation!.value), 0.0),
            child: AspectRatio(
              aspectRatio: 1.5,
              child: ClipRRect(
                borderRadius: const BorderRadius.all(Radius.circular(4.0)),
                child: Stack(
                  alignment: AlignmentDirectional.center,
                  children: <Widget>[
                    Positioned.fill(
                      child: Image.asset(
                        listData!.imagePath,
                        fit: BoxFit.cover,
                      ),
                    ),
                    Positioned( // Hinzufügen dieser Positioned-Widget
                      top: 8, // Abstand von oben
                      left: 8, // Abstand von links
                      child: Text(
                        listData!.title, // Text aus der HomeList
                        style: TextStyle(
                          color: Colors.black, // Textfarbe
                          fontSize: 12, // Schriftgröße
                          backgroundColor: Colors.black12,
                          fontWeight: FontWeight.bold, // Schriftstil
                        ),
                      ),
                    ),
                    Material(
                      color: Colors.transparent,
                      child: InkWell(
                        splashColor: Colors.grey.withOpacity(0.2),
                        borderRadius:
                        const BorderRadius.all(Radius.circular(4.0)),
                        onTap: callBack,
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        );
      },
    );
  }


   */

  @override
  Widget build(BuildContext context) {
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
                          top: 8,
                          left: 8,
                          child: Text(
                            listData!.title,
                            style: TextStyle(
                              color: Colors.black,
                              fontSize: 12,
                              backgroundColor: Colors.black12,
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


