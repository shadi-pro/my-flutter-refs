/*
    [A]  part 2 [E-commerce]
    [] [Commerce App ] project structure  [course app ] :

    lib/
    ├── main.dart
    ├── home_page.dart
    ├── screens/
    │    ├──  .dart
    │    ├──  .dart
    │    ├──  .dart
    │    ├──  .dart
    ├── widgets/
    │    ├── .dart
    │    ├── .dart
    │    ├── .dart
    └── models/
          └── product_model.dart
    assets/
    └── images/
          └── shadi.jpg
          └── img1.jpg
          └── img2.jpg
          └── img3.jpg
  // ----------------------------------------------

  B]  


 

*/

import 'package:flutter/material.dart';
import 'homepage.dart';

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
    return MaterialApp(debugShowCheckedModeBanner: false, home: Homepage());
  }
}
