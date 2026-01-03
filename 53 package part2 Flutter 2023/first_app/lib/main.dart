// [lesson 53]  :   Package in Flutter part  2

import 'package:flutter/material.dart';

// importing  the   {AwesomeDialog }:
import ''; 


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
      title: 'lesson 53 : Package in Flutter part 2  ',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
      ),
      home: const MyHomePage(
        title:
            'Package in Flutter part 2    [ How to use the installed package {aweome_dialog 3.1.0 }  ]',
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

  //  disposing the defined controller  [scrollController] :
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
          'Package [ How to use  the installed package] in Flutter project  part 2',
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
              child: Text(
                "using the deownloaded  package of the {awesome_dialog)  form    the {pub.dev/packages/awesome_dilaog}  mainfest  exaple  ",
              ),
            ),

            Spacer(),

            Container(
              margin: EdgeInsets.symmetric(horizontal: 30),

              child: MaterialButton(
                color: Colors.red,
                textColor: Colors.white,
                onPressed: () {
                  AwesomeDialog(
                    context: context,
                    dialogType: Dialog.info,
                    animType: AnimType.rightSlider,
                    title   :  ,
                     desc:  ,
                     butCancelOnPress: () {} ,
                     butOkOnPress: () {} ,
                  )..show() ;
                },
                child: Text("Show Dialog "),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
