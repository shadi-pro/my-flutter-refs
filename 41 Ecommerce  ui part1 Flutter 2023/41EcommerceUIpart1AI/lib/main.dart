/*

  A]  [Commerce App ] project structure :

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
import 'screens/home_page.dart';
import 'screens/cart_page.dart';
import 'screens/about_page.dart';
import 'screens/contact_page.dart';

void main() {
  runApp(ECommerceApp());
}

class ECommerceApp extends StatelessWidget {
  const ECommerceApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'E-Commerce App',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(primarySwatch: Colors.teal, useMaterial3: true),
      initialRoute: '/',
      routes: {
        '/': (context) => HomePage(),
        '/cart': (context) => CartPage(),
        '/about': (context) => AboutPage(),
        '/contact': (context) => ContactPage(),
      },
    );
  }
}
