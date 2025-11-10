/*

  A]  [Commerce App ] project structure  [course app ] :

      lib/
    ├── main.dart
    ├── screens/
    │    ├── home_page.dart
    │    ├── cart_page.dart
    │    ├── about_page.dart
    │    ├── contact_page.dart
    ├── widgets/
    │    ├── custom_drawer.dart
    │    ├── product_card.dart
    │    ├── category_item.dart
    └── models/
          └── product_model.dart
    assets/
    └── images/
          └── shadi.jpg
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
    return MaterialApp(debugShowCheckedModeBanner: false, home: HomePage());
  }
}
