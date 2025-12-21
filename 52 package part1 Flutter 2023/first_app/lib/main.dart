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
      home: const MyHomePage(title: 'Package in Flutter part 1'),
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
        title: const Text('Package in Flutter part 1'),
        actions: [],
      ),
      body: Center(
        child: ListView(
          // setting a custom controller (assinged by value upper devined variable {scrollController} ) for the [scroll] inside the main parent contianer :
          controller: scrollController,
          // [Types fo packages in Flutter ] :
          children: [
            // a - Service Packages  :
            Container(
              alignment: Alignment.center,
              child: Text(
                "a - Service package  : google map servie package , SQL-lite local databasa , firebase services  , Notifications service   ",
                style: TextStyle(fontSize: 24),
              ),
            ),

            // b - Hardwares Packages  :
            Container(
              alignment: Alignment.center,
              child: Text(
                "b -  Mobile Hardwares Packages  :   Wifi  Router service  package , Bluetooth service package ",
                style: TextStyle(fontSize: 24),
              ),
            ),
            Spacer(),

            // c - Custom Widgets Shortcuts Packages  :
            Container(
              alignment: Alignment.center,
              child: Text(
                "c -  Custom Widgets Shortcuts Packages :  Bottom Navagation Bar with inner timed custom formating \n  Benefit : Optional , but type can save  in creating code  ",
                style: TextStyle(fontSize: 24),
              ),
            ),
            Spacer(),

            // d - Custom Widgets Shortcuts Packages  :
            Container(
              alignment: Alignment.center,
              child: Text(
                " How to download the packages : by using  serveral  : \n 1- using  the official site of the {pub.dev} : provide more than 10000 packages ready to be used  + live searching  within   categorizd menu  \n  2- using cmd coding commands \n ",
                style: TextStyle(fontSize: 24),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
