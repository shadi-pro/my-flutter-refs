/*
    [A]  48 [ Search Delegate  part 1 ] :
      -  applied in [Homepage]  isnside the Appbar



    [B]  project structure : 
      lib/
      ├── main.dart
      ├── homepage.dart
      ├── listgenerate.dart
      ├── contact.dart
      
      assets/
      └── images/
            └── shadi.jpg
            └── img1.jpg
            └── img2.jpg
            └── img3.jpg
  // ----------------------------------------------

  B]  {homepage.dart} : 
    - inlcuee the lessson new widget   


  // ------------------------------------------------

  C]  {.dart} :
    -  
       
       
*/

import 'package:flutter/material.dart';
import 'homepage.dart';
import 'popupmenubutton.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatefulWidget {
  const MyApp({super.key});

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  @override
  Widget build(BuildContext context) {
    // return MaterialApp(debugShowCheckedModeBanner: false, home: Homepage());
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: Homepage(),

      // assign all Routes  isnide  application   :
      // routes: {
      // "homepage": (context) => Homepage(),
      // "popupmenubutton": (context) => Popupmunubutton(),
      // },
    );
  }
}
