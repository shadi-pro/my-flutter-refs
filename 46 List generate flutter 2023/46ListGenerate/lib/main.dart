/*
    [A]  46 [ List Generator method ] :
      - with appliionh some applications :
        1- generating data from list of defined list 
        2- generating list of numbers of generator method's index
        3- generating list of birth dates by usign both of generator method's index + years values
 

    lib/
    ├── main.dart
    ├── homepage.dart
    ├── listgenerate.dart
     
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

  C]  {details.dart} :
    -  dynamic product page include  dynamic data sent form [homepage.dart] the  following   :
      1- bottomNavigationBar section [op[toinal]
      2- Appbar => lesson  title [op[toinal]  
      3- list.generate => with (3)  emaples    
      4-  => endDrawer  
*/

import 'package:flutter/material.dart';
// import 'homepage.dart';
import 'listgenerate.dart';

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
    return MaterialApp(debugShowCheckedModeBanner: false, home: ListGenerate());
  }
}
