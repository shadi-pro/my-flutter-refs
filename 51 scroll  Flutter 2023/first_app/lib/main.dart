// [lesson 51]  :  Custom  scroll in Flutter

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
      title: 'lesson 51 : Custom Scroll in Flutter  ',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
      ),
      home: const MyHomePage(title: 'Custom Flutter Scroll'),
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
        title: const Text('Custom Scroll in Flutter'),
        actions: [],
      ),
      body: Center(
        child: ListView(
          // setting a custom controller (assinged by value upper devined variable {scrollController} ) for the [scroll] inside the main parent contianer :
          controller: scrollController,
          children: [
            // 1- [go to BOTTOM button -using defiend custom scroll - using (animateto) method ] :
            MaterialButton(
              child: Text("Jump to the Bottom "),
              onPressed: () {
                // scrollController.jumpTo(9433);
                scrollController.animateTo(
                  9560,
                  duration: Duration(seconds: 1),
                  curve: Curves.bounceIn,
                );
              },
            ),

            // 2- generating a list of conditional colored Containers
            ...List.generate(
              50,
              (index) => Container(
                height: 100,
                alignment: Alignment.center,
                child: Text("$index", style: TextStyle(fontSize: 24)),
                color: index.isEven ? Colors.red : Colors.green,
              ),
            ),

            // 3- [go to TOP button -using defined custom scroll - using the (animateto) method ] :
            MaterialButton(
              child: Text("Jump to the TOP"),
              onPressed: () {
                // scrollController.jumpTo(0);
                scrollController.animateTo(
                  0,
                  duration: Duration(seconds: 1),
                  curve: Curves.ease,
                );
              },
            ),
          ],
        ),
      ),
    );
  }
}
