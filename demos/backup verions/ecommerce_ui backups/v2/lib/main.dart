import 'package:flutter/material.dart';
import 'pages/homepage.dart';

void main() {
  runApp(const EcommerceApp());
}

class EcommerceApp extends StatelessWidget {
  const EcommerceApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Ecommerce Demo',
      theme: ThemeData(primarySwatch: Colors.blue),
      home: const Homepage(),
    );
  }
}
