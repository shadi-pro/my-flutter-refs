/*
 Lessons applied in this application :  
   1- Text widget 
   2- Container  widget 
   3- Image widget => this lesson  

*/
// --------------------------

// import 'dart:io';

import 'package:flutter/material.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Scaffold(
        appBar: AppBar(title: const Text('Shadi App')),
        body: Container(
          child: Image.asset(
            // 1- first type of the [Image widget]
            "assets/images/download.png", // image path/url value

            width: 500,
            height: 500,

            fit:
                BoxFit
                    .cover, //  [this property will make the image fit the given width and height - but will be corped and not affect on its quality]
            // fit : BoxFit.fill, //  [this property will make the image fit the given width and height - but will be stretched and  affect on its quality]
          ),

          //  2- second type of the [Image widget]
          // child: Image.network(
          //   "https://img.freepik.com/free-photo/smiling-showing-thumb-up-young-male-teacher-wearing-glasses-points-blackboard-classroom_141793-114462.jpg",
          // ),
        ),
      ),
    );
  }
}
