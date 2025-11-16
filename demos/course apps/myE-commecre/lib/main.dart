/*
    [A]  part 4 [E-commerce]
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

  B]  {homepage.dart} :
    - the main   E-commerce home page that include hte following   :
      1- Categories section  
      2- Items section  
      3- Product dynamic navigation
      
  B]  {homepage.dart} :
    - the main   E-commerce home page that include hte following   :
      1- Categories section  
      2- Items section  
      3- Product dynamic navigation

  // ------------------------------------------------

  C]  {details.dart} :
    -  dynamic product page include  dynamic data sent form [homepage.dart] the  following   :
      1- Items section 
      2- Appbar => with customized contents
      3- Drawer => endDrawer  
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
