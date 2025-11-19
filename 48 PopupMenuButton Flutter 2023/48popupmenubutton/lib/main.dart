/*
    [A]  47 [ initState and Dispose  ] :
      - with application some applications :
        1- generating data from list of defined list 
        2- generating list of numbers of generator method's index
        3- generating list of birth dates by usign both of generator method's index + years values
 

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

  B]  {homepage.dart} :    [ abandened in this lesson]
    - the main E-commerce home page that include hte following   :
      1- Categories section  
      2- Items section  
      3- Product dynamic navigation
      
  // ------------------------------------------------

  C]  {popupmenubutton.dart} :
    - navigated throg a route button inside  [homepage.dart]  , including the following :
      1- 

       
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
      routes: {
        "homepage": (context) => Homepage(),
        "popupmenubutton": (context) => Popupmunubutton(),
      },
    );
  }
}
