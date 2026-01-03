// [lesson 52]  :   Package in Flutter part 1

import 'package:flutter/material.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatefulWidget {
  const MyApp({super.key});

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'lesson 52 : Package in Flutter part 1  ',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
      ),
      home: const MyHomePage(
        title:
            'Package in Flutter part 1    [ types +  installaion   methods  ]',
      ),
    );
  }
}

class MyHomePage extends StatefulWidget {
  const MyHomePage({super.key, required this.title});

  final String title;

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  //  define the main  ScrollController before buillding the  widget (to be assigned later ) :
  late ScrollController scrollController;

  // define a {initState} void {initState} function to set the defined [ScrollController] :
  @override
  void initState() {
    // [assign the ScrollController() by the value of upper defined {scrollController}] :
    scrollController = ScrollController();

    // [this function will be implemented while scroller is working] :
    scrollController.addListener(() {
      // [printing the current value of offset scrolling inside Terminal -while scroling -  ]
      print("${scrollController.offset}");
    });
    super.initState();
  }

  //  disposing  the defined controller  [scrollController] :
  @override
  void dispose() {
    scrollController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'Package [ Types + installation methods] in Flutter part 1',
        ),
        actions: [],
      ),

      body: Center(
        child: ListView(
          // setting a custom controller (assinged by value upper devined variable {scrollController} ) for the [scroll] inside the main parent contianer :
          controller: scrollController,

          // [I/ Types of packages in Flutter ] :
          children: [
            Container(
              alignment: Alignment.center,
              decoration: BoxDecoration(border: Border.all(width: 3)),
              child: Text(
                "I - Flutter package types :",
                style: TextStyle(fontSize: 24),
              ),
            ),

            //  /I/ Types of packages in Flutter   a - Service Packages  :
            Container(
              alignment: Alignment.center,
              child: Text(
                "a- Service package type : google map servie package , SQL-lite local databasa , firebase services  , Notifications service   ",
                style: TextStyle(fontSize: 18),
              ),
            ),
            Spacer(),

            //  /I/ Types of packages in Flutter /    b - Hardwares Packages  :
            Container(
              alignment: Alignment.center,
              child: Text(
                "b -  Mobile Hardwares Packages type   :   Wifi  Router service  package , Bluetooth service package ",
                style: TextStyle(fontSize: 18),
              ),
            ),
            Spacer(),

            //  /I/ Types of packages in Flutter c - Custom Widgets Shortcuts Packages  :
            Container(
              alignment: Alignment.center,
              child: Text(
                "c -  Custom Widgets Shortcuts Packages type  :  Bottom Navagation Bar with inner timed custom formating \n  Benefit : Optional , but type can save  in creating code  ",
                style: TextStyle(fontSize: 18),
              ),
            ),
            Spacer(),

            // II/ Custom Widgets Shortcuts Packages  :
            Container(
              decoration: BoxDecoration(border: Border.all(width: 3)),
              alignment: Alignment.center,
              child: Text(
                "II/  Download & Installation packages  methods :   ",
                style: TextStyle(fontSize: 24),
              ),
            ),

            Spacer(),

            Container(
              alignment: Alignment.center,
              child: Text(
                "a-   by using  serveral methods : \n 1- using  the official site of the {pub.dev} : provide more than 10000 packages ready to be used  + live searching  within   categorizd menu  \n    ",
                style: TextStyle(fontSize: 18),
              ),
            ),

            Container(
              alignment: Alignment.center,
              child: Text(
                "b-  by using  serveral methods : \n  2- using cmd coding commands \n ",
                style: TextStyle(fontSize: 18),
              ),
            ),

            Spacer(),
          ],
        ),
      ),
    );
  }
}
